import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/profile_entity.dart';

abstract final class ProfileMapper {
  static ProfileEntity toEntity(
    User user,
    Map<String, dynamic>? data, {
    Iterable<Map<String, dynamic>> wishlist = const [],
    Iterable<Map<String, dynamic>> history = const [],
  }) {
    final values = data ?? const <String, dynamic>{};
    return ProfileEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: (values['name'] as String?)?.trim().isNotEmpty == true
          ? values['name'] as String
          : (user.displayName ?? 'User'),
      phone: values['phone'] as String? ?? '',
      avatarId: _validAvatarId(values['avatarId']),
      wishlistMovies: wishlist.map(toMovie).whereType<MovieEntity>().toList(),
      historyMovies: history.map(toMovie).whereType<MovieEntity>().toList(),
    );
  }

  static Map<String, dynamic> movieToJson(MovieEntity movie) {
    return {'id': movie.id, 'rating': movie.rating, 'imageUrl': movie.imageUrl};
  }

  static MovieEntity? toMovie(Map<String, dynamic> item) {
    final id = item['id'] is int
        ? item['id'] as int
        : int.tryParse('${item['id']}') ?? 0;
    final rating = item['rating'] is num
        ? (item['rating'] as num).toDouble()
        : double.tryParse('${item['rating']}') ?? 0;
    final imageUrl =
        (item['imageUrl'] ?? item['posterUrl'] ?? item['posterPath'] ?? '')
            .toString();
    if (imageUrl.isEmpty) return null;
    return MovieEntity(id: id, rating: rating, imageUrl: imageUrl);
  }

  static int _validAvatarId(Object? value) {
    final avatarId = value is int ? value : int.tryParse('$value');
    return avatarId != null && avatarId >= 1 && avatarId <= 9 ? avatarId : 1;
  }
}
