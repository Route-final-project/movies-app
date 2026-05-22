
import '../../app_exception.dart';

sealed class RemoteAppException extends AppException {
  @override
  final String message;
  RemoteAppException(this.message): super(message);
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
