import 'package:dio/dio.dart';
import 'package:movies/data_source/remote_data_source/exception/remote_exception.dart';

RemoteAppException handleResponse(Response response) {
  switch (response.statusCode) {
    case 400:
      return BadRequestException('Bad Request');
    case 404:
      return NotFoundException('Not Found Data');
    case 503:
      return RemoteException('Service Unavailable');
    default:
      return RemoteException(
        response.data['message'] ?? 'Unexpected Network Error',
      );
  }
}
