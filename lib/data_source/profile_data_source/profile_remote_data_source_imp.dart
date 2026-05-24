import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/profile_entity.dart';
import 'profile_remote_data_source.dart';

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImp implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImp(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const Duration _operationTimeout = Duration(seconds: 12);

  @override
  Future<ProfileEntity> getProfile() async {
    final user = _requireUser();
    try {
      final snapshot = await _userDocument(user.uid).get();
      return _toEntity(user, snapshot.data());
    } on FirebaseException catch (error) {
      if (error.code == 'unavailable') {
        return _toEntity(user, null);
      }
      rethrow;
    }
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    final user = _requireUser();
    final profileData = {'name': name, 'phone': phone, 'avatarId': avatarId};
    try {
      await _userDocument(
        user.uid,
      ).set(profileData, SetOptions(merge: true)).timeout(_operationTimeout);
    } on TimeoutException {
      // Firestore can keep the write queued locally while waiting for network.
    }
    try {
      await user.updateDisplayName(name).timeout(_operationTimeout);
    } on TimeoutException {
      // Auth display name will retry on a later successful update.
    }
    return _toEntity(user, profileData);
  }

  @override
  Future<ProfileEntity> addMovieToWishlist(MovieEntity movie) {
    return _syncMovieList(field: 'wishlistMovies', movie: movie);
  }

  @override
  Future<ProfileEntity> addMovieToHistory(MovieEntity movie) {
    return _syncMovieList(field: 'historyMovies', movie: movie);
  }

  Future<ProfileEntity> _syncMovieList({
    required String field,
    required MovieEntity movie,
  }) async {
    final user = _requireUser();
    final movieData = _movieToJson(movie);

    try {
      await _userDocument(user.uid)
          .set({
            field: FieldValue.arrayUnion([movieData]),
          }, SetOptions(merge: true))
          .timeout(_operationTimeout);
    } on TimeoutException {
      // Firestore keeps local writes queued; do not block opening movies.
    }

    return _toEntity(user, {
      field: [movieData],
    });
  }

  DocumentReference<Map<String, dynamic>> _userDocument(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Please sign in to open your profile.',
      );
    }
    return user;
  }

  ProfileEntity _toEntity(User user, Map<String, dynamic>? data) {
    final values = data ?? const <String, dynamic>{};
    return ProfileEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: (values['name'] as String?)?.trim().isNotEmpty == true
          ? values['name'] as String
          : (user.displayName ?? 'User'),
      phone: values['phone'] as String? ?? '',
      avatarId: _validAvatarId(values['avatarId']),
      wishlistMovies: _toMovies(values['wishlistMovies']),
      historyMovies: _toMovies(values['historyMovies']),
    );
  }

  int _validAvatarId(Object? value) {
    final avatarId = value is int ? value : int.tryParse('$value');
    return avatarId != null && avatarId >= 1 && avatarId <= 9 ? avatarId : 1;
  }

  List<MovieEntity> _toMovies(Object? rawList) {
    if (rawList is! List) return const <MovieEntity>[];
    return rawList
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map((item) {
          final id = item['id'] is int
              ? item['id'] as int
              : int.tryParse('${item['id']}') ?? 0;
          final rating = item['rating'] is num
              ? (item['rating'] as num).toDouble()
              : double.tryParse('${item['rating']}') ?? 0;
          final imageUrl =
              (item['imageUrl'] ??
                      item['posterUrl'] ??
                      item['posterPath'] ??
                      '')
                  .toString();
          return MovieEntity(id: id, rating: rating, imageUrl: imageUrl);
        })
        .where((movie) => movie.imageUrl.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> _movieToJson(MovieEntity movie) {
    return {'id': movie.id, 'rating': movie.rating, 'imageUrl': movie.imageUrl};
  }
}
