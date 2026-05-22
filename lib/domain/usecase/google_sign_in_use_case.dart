import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/auth_entity.dart';
import '../repository_interface/auth_repository.dart';

@lazySingleton
class GoogleSignInUseCase {
  final AuthRepository authRepository;
  GoogleSignInUseCase({required this.authRepository});

  Future<Either<AppError, AuthEntity>> call() =>
      authRepository.signInWithGoogle();
}
