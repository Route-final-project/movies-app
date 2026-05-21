
import 'package:movies/data_source/remote_data_source/exception/remote_exception.dart';
import 'package:movies/domain/app_error.dart';

AppError mapExceptionToError(RemoteAppException exception){
  AppError appError;
  if ( exception is NoInternetException){
    appError = NoInternetError(exception.message);
  }else {
    appError = NetworkError(exception.message);
  }
  return appError;
}