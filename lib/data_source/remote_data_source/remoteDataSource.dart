import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/data_source/remote_data_source/response_object/movies_list_response.dart';

import '../../config/app_constants.dart';
import 'exception/handleDioException.dart';
import 'exception/remote_exception.dart';

@lazySingleton
class RemoteDataSource {
  final Dio dio;
  RemoteDataSource(this.dio);


  Future<List<Movie>> getLatestMovies() async {
    Response response;
    try {
      response = await dio.get(
        AppConstants.baseUrl + AppConstants.moviesListEndpoint,
        queryParameters: {"sort_by": "date_added", "order_by": "desc"},
      );
      MoviesListResponse moviesListResponse = MoviesListResponse.fromJson(
        response.data,
      );
      return moviesListResponse.data?.movies ?? [];
    } on SocketException catch (_) {
      throw NoInternetException('No Internet Connection');
    } on DioException catch (e) {
      throw handleDioException(e);
    } on Exception catch (_) {
      throw RemoteException('Network error');
    }
  }
}
