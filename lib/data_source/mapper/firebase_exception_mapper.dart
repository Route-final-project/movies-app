import 'package:firebase_core/firebase_core.dart';

import '../remote_data_source/exception/remote_exception.dart';

abstract final class FirebaseExceptionMapper {
  static RemoteAppException firestore(FirebaseException exception) {
    if (exception.code == 'unavailable' ||
        exception.code == 'network-request-failed') {
      return NoInternetException('No internet connection.');
    }
    return RemoteException(exception.message ?? 'Firebase operation failed.');
  }

  static RemoteAppException timeout(String action) {
    return RemoteException('$action timed out. Please check your connection.');
  }
}
