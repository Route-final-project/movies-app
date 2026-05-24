import 'package:dartz/dartz.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../entity/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<AppError, ProfileEntity>> getProfile();

  Future<Either<AppError, ProfileEntity>> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  });

  Future<Either<AppError, ProfileEntity>> addMovieToWishlist(MovieEntity movie);

  Future<Either<AppError, ProfileEntity>> addMovieToHistory(MovieEntity movie);
}
