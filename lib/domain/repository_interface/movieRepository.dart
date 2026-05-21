import 'package:dartz/dartz.dart';
import 'package:movies/domain/app_error.dart';

import '../entity/movie_entity.dart';

abstract class MovieRepository{
  Future<Either<AppError,List<MovieEntity>>> getLatestMovies();
}