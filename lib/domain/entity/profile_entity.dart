import 'movie_entity.dart';

class ProfileEntity {
  const ProfileEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.avatarId,
    required this.wishlistMovies,
    required this.historyMovies,
  });

  final String uid;
  final String email;
  final String name;
  final String phone;
  final int avatarId;
  final List<MovieEntity> wishlistMovies;
  final List<MovieEntity> historyMovies;

  ProfileEntity copyWith({
    String? name,
    String? phone,
    int? avatarId,
    List<MovieEntity>? wishlistMovies,
    List<MovieEntity>? historyMovies,
  }) {
    return ProfileEntity(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarId: avatarId ?? this.avatarId,
      wishlistMovies: wishlistMovies ?? this.wishlistMovies,
      historyMovies: historyMovies ?? this.historyMovies,
    );
  }
}
