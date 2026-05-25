
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../repository_interface/movieRepository.dart';

@lazySingleton
class GetSimilarMoviesUseCase {
  final MovieRepository movieRepository;
  GetSimilarMoviesUseCase({required this.movieRepository});
  Future<Either<AppError, List<MovieEntity>>> call(int movieId) async {
    return await movieRepository.getSimilarMovies(movieId);
  }
}