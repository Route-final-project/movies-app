import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../app_error.dart';
import '../entity/movie_entity.dart';
import '../repository_interface/movieRepository.dart';

@lazySingleton
class GetLatestMoviesUseCase{
  final MovieRepository movieRepository;
  GetLatestMoviesUseCase({required this.movieRepository});
  Future<Either<AppError, List<MovieEntity>>> call() async {
    return await movieRepository.getLatestMovies();
  }
}