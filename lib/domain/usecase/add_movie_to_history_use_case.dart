import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../entity/profile_entity.dart';
import '../repository_interface/profile_repository.dart';

@lazySingleton
class AddMovieToHistoryUseCase {
  const AddMovieToHistoryUseCase({required this.profileRepository});

  final ProfileRepository profileRepository;

  Future<Either<AppError, ProfileEntity>> call(MovieEntity movie) {
    return profileRepository.addMovieToHistory(movie);
  }
}
