import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/profile_entity.dart';
import '../mapper/firebase_exception_mapper.dart';
import '../mapper/profile_mapper.dart';
import 'profile_local_cache.dart';
import 'profile_remote_data_source.dart';

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImp implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImp(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const Duration _readTimeout = Duration(seconds: 5);
  static const Duration _writeTimeout = Duration(seconds: 10);

  @override
  Future<ProfileEntity> getProfile() async {
    final user = _requireUser();
    final cachedProfile = await ProfileLocalCache.read(user.uid);
    try {
      final results = await Future.wait([
        _userDocument(user.uid).get(),
        _movieCollection(user.uid, 'wishlist').get(),
        _movieCollection(user.uid, 'history').get(),
      ]).timeout(_readTimeout);
      final profile = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final wishlist = results[1] as QuerySnapshot<Map<String, dynamic>>;
      final history = results[2] as QuerySnapshot<Map<String, dynamic>>;
      final profileData = _mergeProfileData(profile.data(), cachedProfile);
      return ProfileMapper.toEntity(
        user,
        profileData,
        wishlist: wishlist.docs.map((document) => document.data()),
        history: history.docs.map((document) => document.data()),
      );
    } on TimeoutException {
      return ProfileMapper.toEntity(user, cachedProfile);
    } on FirebaseException catch (error) {
      if (cachedProfile != null &&
          (error.code == 'unavailable' ||
              error.code == 'network-request-failed')) {
        return ProfileMapper.toEntity(user, cachedProfile);
      }
      throw FirebaseExceptionMapper.firestore(error);
    }
  }

  Map<String, dynamic>? _mergeProfileData(
    Map<String, dynamic>? remoteProfile,
    Map<String, dynamic>? cachedProfile,
  ) {
    if (remoteProfile == null) return cachedProfile;
    if (cachedProfile == null) return remoteProfile;

    return {
      ...remoteProfile,
      if ((remoteProfile['phone'] as String?)?.trim().isNotEmpty != true)
        'phone': cachedProfile['phone'],
      if (remoteProfile['avatarId'] == null ||
          (remoteProfile['avatarId'] == 1 && cachedProfile['avatarId'] != null))
        'avatarId': cachedProfile['avatarId'],
    };
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    final user = _requireUser();
    final profileData = {
      'uid': user.uid,
      'name': name,
      'email': user.email ?? '',
      'phone': phone,
      'avatarId': avatarId,
    };
    await ProfileLocalCache.save(
      uid: user.uid,
      name: name,
      email: user.email ?? '',
      phone: phone,
      avatarId: avatarId,
    );
    try {
      await _userDocument(
        user.uid,
      ).set(profileData, SetOptions(merge: true)).timeout(_writeTimeout);
    } on TimeoutException {
      // Firestore may keep the write pending locally on web; reflect the user's
      // submitted profile instead of leaving the UI in a loading state forever.
    } on FirebaseException catch (error) {
      throw FirebaseExceptionMapper.firestore(error);
    }
    try {
      await user.updateDisplayName(name).timeout(_writeTimeout);
    } on TimeoutException {
      // The users/{uid} document is the profile source of truth.
    } on FirebaseException catch (error) {
      throw FirebaseExceptionMapper.firestore(error);
    }
    return ProfileMapper.toEntity(user, profileData);
  }

  @override
  Future<ProfileEntity> addMovieToWishlist(MovieEntity movie) {
    return _syncMovieList(collection: 'wishlist', movie: movie);
  }

  @override
  Future<ProfileEntity> addMovieToHistory(MovieEntity movie) {
    return _syncMovieList(collection: 'history', movie: movie);
  }

  Future<ProfileEntity> _syncMovieList({
    required String collection,
    required MovieEntity movie,
  }) async {
    final user = _requireUser();
    try {
      await _movieCollection(
        user.uid,
        collection,
      ).doc('${movie.id}').set(ProfileMapper.movieToJson(movie));
    } on FirebaseException catch (error) {
      print("==>erererer ${error.message}");
      throw FirebaseExceptionMapper.firestore(error);
    }
    return getProfile();
  }

  DocumentReference<Map<String, dynamic>> _userDocument(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  CollectionReference<Map<String, dynamic>> _movieCollection(
    String uid,
    String collection,
  ) {
    return _userDocument(uid).collection(collection);
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
}
