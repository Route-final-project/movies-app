import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/profile_entity.dart';
import '../repository_interface/profile_repository.dart';

@lazySingleton
class GetProfileUseCase {
  const GetProfileUseCase({required this.profileRepository});

  final ProfileRepository profileRepository;

  Future<Either<AppError, ProfileEntity>> call() {
    return profileRepository.getProfile();
  }
}
