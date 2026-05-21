sealed class AppError {
  final String message;
  AppError(this.message);

}
class NoInternetError extends AppError {
  NoInternetError(String message) : super(message);
}

class NetworkError extends AppError {
  NetworkError(String message) : super(message);
}

class LocalError extends AppError {
  LocalError(String message) : super(message);
}