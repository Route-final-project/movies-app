sealed class AppError {
  final String message;
  AppError(this.message);
}

class NoInternetError extends AppError {
  NoInternetError(super.message);
}

class NetworkError extends AppError {
  NetworkError(super.message);
}

class LocalError extends AppError {
  LocalError(super.message);
}

class AuthError extends AppError {
  AuthError(super.message);
}