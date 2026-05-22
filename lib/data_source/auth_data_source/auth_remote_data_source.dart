import '../../domain/entity/auth_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AuthEntity> signIn(String email, String password);
  Future<AuthEntity> register(String name, String email, String password);
  Future<AuthEntity> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
}
