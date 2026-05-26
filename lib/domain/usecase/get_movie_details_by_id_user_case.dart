import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/domain/app_error.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/domain/repository_interface/movieRepository.dart';

@lazySingleton
class GetMovieDetailsByIdUserCase {
  MovieRepository movieRepository;
  GetMovieDetailsByIdUserCase(this.movieRepository);

  Future<Either<AppError,MovieEntity>> call(int movieId) async{
    return await movieRepository.getMovieDetailsById(movieId);
  }
}