import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/app_error.dart';
import '../../domain/entity/auth_entity.dart';
import '../../domain/repository_interface/auth_repository.dart';
import '../auth_data_source/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  AuthRepositoryImp(this._dataSource);

  @override
  Future<Either<AppError, AuthEntity>> signIn(String email, String password) =>
      _run(() => _dataSource.signIn(email, password));

  @override
  Future<Either<AppError, AuthEntity>> register(
    String name,
    String email,
    String password,
    String phone,
    int avatarId,
  ) => _run(() => _dataSource.register(name, email, password, phone, avatarId));

  @override
  Future<Either<AppError, AuthEntity>> signInWithGoogle() =>
      _run(() => _dataSource.signInWithGoogle());

  @override
  Future<Either<AppError, void>> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_mapError(e)));
    } catch (e) {
      return Left(AuthError(e.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_mapError(e)));
    } catch (e) {
      return Left(AuthError(e.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> deleteAccount() async {
    try {
      await _dataSource.deleteAccount();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_mapError(e)));
    } catch (e) {
      return Left(AuthError(e.toString()));
    }
  }

  Future<Either<AppError, AuthEntity>> _run(
    Future<AuthEntity> Function() fn,
  ) async {
    try {
      return Right(await fn());
    } on FirebaseAuthException catch (e) {
      return Left(AuthError(_mapError(e)));
    } catch (e) {
      return Left(AuthError(e.toString()));
    }
  }

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'cancelled':
        return 'Sign in was cancelled.';
      case 'requires-recent-login':
        return 'Please log out and log in again before deleting your account.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
