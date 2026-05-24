import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../repository_interface/auth_repository.dart';

@lazySingleton
class DeleteAccountUseCase {
  const DeleteAccountUseCase({required this.authRepository});

  final AuthRepository authRepository;

  Future<Either<AppError, void>> call() {
    return authRepository.deleteAccount();
  }
}
