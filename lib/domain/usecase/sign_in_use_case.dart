import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/auth_entity.dart';
import '../repository_interface/auth_repository.dart';

@lazySingleton
class SignInUseCase {
  final AuthRepository authRepository;
  SignInUseCase({required this.authRepository});

  Future<Either<AppError, AuthEntity>> call({
    required String email,
    required String password,
  }) =>
      authRepository.signIn(email, password);
}
