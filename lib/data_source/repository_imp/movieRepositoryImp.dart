
import 'package:dartz/dartz.dart';
import 'package:movies/domain/model/movie.dart';

import '../../domain/repository_interface/movieRepository.dart';



class MovieRepositoryImp implements MovieRepository{
  @override
  Either<Error, Future<List<MovieModel>>> getPopularMovies() {
    // TODO: implement getPopularMovies
    throw UnimplementedError();
  }


}