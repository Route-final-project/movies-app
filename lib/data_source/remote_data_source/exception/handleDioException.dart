
import 'package:dio/dio.dart';
import 'package:movies/data_source/remote_data_source/exception/remote_exception.dart';

import 'handle_response.dart';

RemoteAppException handleDioException (DioException e){
  switch (e.type) {
    case DioExceptionType.connectionError:
      return NoInternetException('No internet connection');

    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return RemoteException('Connection timeout');

    case DioExceptionType.badResponse:
      return handleResponse(e.response!);

    default:
      return RemoteException('Unexpected network error');
  }
}