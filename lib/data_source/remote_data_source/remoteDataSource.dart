import 'package:dio/dio.dart';
import 'package:movies/data_source/remote_data_source/response_object/MovieResponse.dart';

class RemoteDataSource {
  final Dio dio;
  RemoteDataSource({required this.dio});


  Future<List<MovieResponse>?> getPopularMovies() async{
    return null;
  }
}