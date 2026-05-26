import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../entity/profile_entity.dart';
import '../repository_interface/profile_repository.dart';

@lazySingleton
class AddMovieToWishlistUseCase {
  const AddMovieToWishlistUseCase({required this.profileRepository});

  final ProfileRepository profileRepository;

  Future<Either<AppError, void>> call(MovieEntity movie) async {
    return await profileRepository.addMovieToWishlist(movie);
  }
}
