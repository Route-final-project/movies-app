import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/auth_entity.dart';

abstract final class AuthMapper {
  static AuthEntity toEntity(User user) => AuthEntity(
    uid: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
    photoURL: user.photoURL,
  );
}
