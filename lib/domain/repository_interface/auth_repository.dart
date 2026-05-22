import 'package:dartz/dartz.dart';

import '../app_error.dart';
import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<AppError, AuthEntity>> signIn(String email, String password);
  Future<Either<AppError, AuthEntity>> register(String name, String email, String password);
  Future<Either<AppError, AuthEntity>> signInWithGoogle();
  Future<Either<AppError, void>> sendPasswordResetEmail(String email);
}
