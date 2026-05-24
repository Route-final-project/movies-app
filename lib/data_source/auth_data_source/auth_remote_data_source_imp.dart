import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/auth_entity.dart';
import 'auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  static const Duration _profileWriteTimeout = Duration(seconds: 8);

  AuthRemoteDataSourceImp(this._auth, this._googleSignIn, this._firestore);

  @override
  Future<AuthEntity> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(cred.user!);
  }

  @override
  Future<AuthEntity> register(
    String name,
    String email,
    String password,
    String phone,
    int avatarId,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    await _tryCreateOrUpdateUserProfile(
      uid: cred.user!.uid,
      name: name,
      phone: phone,
      avatarId: avatarId,
    );
    return _mapUser(cred.user!);
  }

  @override
  Future<AuthEntity> signInWithGoogle() async {
    if (kIsWeb) {
      // On web: use Firebase's signInWithPopup directly
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      await _ensureGoogleUserProfile(cred.user!);
      return _mapUser(cred.user!);
    } else {
      // On mobile: use google_sign_in package
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'cancelled',
          message: 'Google sign in was cancelled.',
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      await _ensureGoogleUserProfile(cred.user!);
      return _mapUser(cred.user!);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // FirebaseAuth.signOut is the app's source of truth.
      }
    }
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No signed-in account found.',
      );
    }
    await user.delete();
    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // FirebaseAuth deletion is already complete.
      }
    }
  }

  AuthEntity _mapUser(User user) => AuthEntity(
    uid: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoURL: user.photoURL,
  );

  Future<void> _ensureGoogleUserProfile(User user) async {
    try {
      final doc = _firestore.collection('users').doc(user.uid);
      final snapshot = await doc.get().timeout(_profileWriteTimeout);
      if (snapshot.exists) return;

      await _tryCreateOrUpdateUserProfile(
        uid: user.uid,
        name: user.displayName ?? user.email?.split('@').first ?? 'User',
        phone: '',
        avatarId: 1,
      );
    } on TimeoutException {
      // Profile creation is best effort for Google sign-in.
    } on FirebaseException catch (error) {
      if (error.code != 'unavailable') rethrow;
    }
  }

  Future<void> _tryCreateOrUpdateUserProfile({
    required String uid,
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    try {
      await _createOrUpdateUserProfile(
        uid: uid,
        name: name,
        phone: phone,
        avatarId: avatarId,
      );
    } on TimeoutException {
      // Auth already succeeded; Firestore can sync the profile later.
    } on FirebaseException catch (error) {
      if (error.code != 'unavailable') rethrow;
    }
  }

  Future<void> _createOrUpdateUserProfile({
    required String uid,
    required String name,
    required String phone,
    required int avatarId,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .set({
          'name': name,
          'phone': phone,
          'avatarId': avatarId,
          'wishlistMovies': <Map<String, dynamic>>[],
          'historyMovies': <Map<String, dynamic>>[],
        }, SetOptions(merge: true))
        .timeout(_profileWriteTimeout);
  }
}
