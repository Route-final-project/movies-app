
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../repository_interface/movieRepository.dart';

@lazySingleton
class SearchMoviesUseCase{
  final MovieRepository movieRepository;
  SearchMoviesUseCase({required this.movieRepository});
  Future<Either<AppError, List<MovieEntity>>> call(String query, int page) async {
    return await movieRepository.searchMovies(query, page);
  }
}