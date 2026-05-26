import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../repository_interface/movieRepository.dart';

@lazySingleton
class BrowseMoviesUseCase {
  final MovieRepository movieRepository;

  BrowseMoviesUseCase({required this.movieRepository});

  Future<Either<AppError, List<MovieEntity>>> call(
    String genre,
    int page, {
    int limit = 20,
  }) async {
    return await movieRepository.browseMoviesByGenre(genre, page, limit: limit);
  }
}
