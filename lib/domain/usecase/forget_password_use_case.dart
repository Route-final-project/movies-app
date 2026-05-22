import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../repository_interface/auth_repository.dart';

@lazySingleton
class ForgetPasswordUseCase {
  final AuthRepository authRepository;
  ForgetPasswordUseCase({required this.authRepository});

  Future<Either<AppError, void>> call({required String email}) =>
      authRepository.sendPasswordResetEmail(email);
}
