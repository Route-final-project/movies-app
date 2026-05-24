import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  });

  Future<ProfileEntity> addMovieToWishlist(MovieEntity movie);

  Future<ProfileEntity> addMovieToHistory(MovieEntity movie);
}
