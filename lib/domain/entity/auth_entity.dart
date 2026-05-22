class AuthEntity {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;

  const AuthEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });
}
