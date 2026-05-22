import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/auth_entity.dart';
import '../repository_interface/auth_repository.dart';

@lazySingleton
class RegisterUseCase {
  final AuthRepository authRepository;
  RegisterUseCase({required this.authRepository});

  Future<Either<AppError, AuthEntity>> call({
    required String name,
    required String email,
    required String password,
  }) =>
      authRepository.register(name, email, password);
}
