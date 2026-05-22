import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/data_source/remote_data_source/exception/map_exception_to_error.dart';
import 'package:movies/data_source/remote_data_source/exception/remote_exception.dart';
import 'package:movies/data_source/remote_data_source/response_object/movies_list_response.dart';
import 'package:movies/domain/app_error.dart';

import '../../domain/entity/movie_entity.dart';
import '../../domain/repository_interface/movieRepository.dart';
import '../remote_data_source/remoteDataSource.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImp implements MovieRepository {
  final RemoteDataSource remoteDataSource;

  MovieRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<AppError, List<MovieEntity>>> getLatestMovies() async {
    try {
      List<Movie> moviesList = await remoteDataSource.getLatestMovies();
      List<MovieEntity> movies = moviesList
          .map((m) => m.toMovieEntity())
          .toList();
      return Right(movies);
    } on RemoteAppException catch (e) {
      return Left(mapExceptionToError(e));
    }
  }

  @override
  Future<Either<AppError, List<MovieEntity>>> searchMovies(String query, int page) async {
    try {
      List<Movie> moviesList = await remoteDataSource.findMovies(query, page);
      List<MovieEntity> movies = moviesList
          .map((m) => m.toMovieEntity())
          .toList();
      return Right(movies);
    } on RemoteAppException catch (e) {
      return Left(mapExceptionToError(e));
    }
  }
}
