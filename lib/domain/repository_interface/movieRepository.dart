import 'package:dartz/dartz.dart';

import '../model/movie.dart';

abstract class MovieRepository{
  Either<Error,Future<List<MovieModel>>> getPopularMovies();
}