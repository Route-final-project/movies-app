import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile();

  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  });

  Future<void> addMovieToWishlist(MovieEntity movie);
  Future <void> removeMovieFromWishlist(int movieId);

  Future<ProfileEntity> addMovieToHistory(MovieEntity movie);
  Future<List<int>> getWishlist();
}
