import '../../app_exception.dart';

sealed class RemoteAppException extends AppException {
  RemoteAppException(super.message);
}

class NoInternetException extends RemoteAppException {
  NoInternetException(super.message);
}

class BadRequestException extends RemoteAppException {
  BadRequestException(super.message);
}

class NotFoundException extends RemoteAppException {
  NotFoundException(super.message);
}

class RemoteException extends RemoteAppException {
  RemoteException(super.message);
}

class ProfileAlreadyExistsException extends RemoteAppException {
  ProfileAlreadyExistsException() : super('User profile already exists.');
}
