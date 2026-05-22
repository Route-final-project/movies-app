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

  AuthRemoteDataSourceImp(this._auth, this._googleSignIn);

  @override
  Future<AuthEntity> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(cred.user!);
  }

  @override
  Future<AuthEntity> register(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    return _mapUser(cred.user!);
  }

  @override
  Future<AuthEntity> signInWithGoogle() async {
    if (kIsWeb) {
      // On web: use Firebase's signInWithPopup directly
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
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
      return _mapUser(cred.user!);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  AuthEntity _mapUser(User user) => AuthEntity(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
      );
}
