import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/auth_entity.dart';
import '../mapper/auth_mapper.dart';
import '../mapper/firebase_exception_mapper.dart';
import '../profile_data_source/profile_local_cache.dart';
import '../remote_data_source/exception/remote_exception.dart';
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
    return AuthMapper.toEntity(cred.user!);
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
    await ProfileLocalCache.save(
      uid: cred.user!.uid,
      name: name,
      email: email,
      phone: phone,
      avatarId: avatarId,
    );
    await _createUserProfile(
      uid: cred.user!.uid,
      name: name,
      email: email,
      phone: phone,
      avatarId: avatarId,
    );
    return AuthMapper.toEntity(cred.user!);
  }

  @override
  Future<AuthEntity> signInWithGoogle() async {
    if (kIsWeb) {
      // On web: use Firebase's signInWithPopup directly
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      await _ensureGoogleUserProfile(cred.user!);
      return AuthMapper.toEntity(cred.user!);
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
      return AuthMapper.toEntity(cred.user!);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (!kIsWeb) {
        // Web Google auth is owned by FirebaseAuth.signInWithPopup.
        await _googleSignIn.signOut();
      }
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException catch (error) {
      throw FirebaseExceptionMapper.firestore(error);
    } catch (error) {
      throw RemoteException('Unable to sign out: $error');
    }
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
      } on FirebaseException catch (error) {
        throw FirebaseExceptionMapper.firestore(error);
      } catch (error) {
        throw RemoteException('Unable to clear Google sign-in session: $error');
      }
    }
  }

  Future<void> _ensureGoogleUserProfile(User user) async {
    try {
      await _createUserProfile(
        uid: user.uid,
        name: user.displayName ?? user.email?.split('@').first ?? 'User',
        email: user.email ?? '',
        phone: '',
        avatarId: 1,
      );
    } on FirebaseException catch (error) {
      throw FirebaseExceptionMapper.firestore(error);
    } on ProfileAlreadyExistsException {
      // The Google account already has a profile document.
      return;
    }
  }

  Future<void> _createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required int avatarId,
  }) async {
    try {
      final document = _firestore.collection('users').doc(uid);
      try {
        final snapshot = await document.get().timeout(_profileWriteTimeout);
        if (snapshot.exists) throw ProfileAlreadyExistsException();
      } on TimeoutException {
        // Auth uid is unique. If the existence check is slow on web, continue
        // creating the profile instead of leaving registration half-finished.
      }

      await document
          .set({
            'uid': uid,
            'name': name,
            'email': email,
            'phone': phone,
            'avatarId': avatarId,
          })
          .timeout(_profileWriteTimeout);
    } on TimeoutException {
      // Auth creation already succeeded. Firestore can still complete the
      // pending set, so do not leave the user stuck on registration.
    } on FirebaseException catch (error) {
      throw FirebaseExceptionMapper.firestore(error);
    }
  }
}
