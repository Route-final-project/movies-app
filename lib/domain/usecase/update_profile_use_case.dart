import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/profile_entity.dart';
import '../repository_interface/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase {
  const UpdateProfileUseCase({required this.profileRepository});

  final ProfileRepository profileRepository;

  Future<Either<AppError, ProfileEntity>> call({
    required String name,
    required String phone,
    required int avatarId,
  }) {
    return profileRepository.updateProfile(
      name: name,
      phone: phone,
      avatarId: avatarId,
    );
  }
}
