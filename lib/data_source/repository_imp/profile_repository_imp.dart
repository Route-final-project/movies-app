import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

import '../../domain/app_error.dart';
import '../../domain/entity/movie_entity.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/repository_interface/profile_repository.dart';
import '../profile_data_source/profile_remote_data_source.dart';
import '../remote_data_source/exception/map_exception_to_error.dart';
import '../remote_data_source/exception/remote_exception.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImp implements ProfileRepository {
  ProfileRepositoryImp(this._dataSource);

  final ProfileRemoteDataSource _dataSource;

  @override
  Future<Either<AppError, ProfileEntity>> getProfile() {
    return _run(_dataSource.getProfile);
  }

  @override
  Future<Either<AppError, ProfileEntity>> updateProfile({
    required String name,
    required String phone,
    required int avatarId,
  }) {
    return _run(
      () => _dataSource.updateProfile(
        name: name,
        phone: phone,
        avatarId: avatarId,
      ),
    );
  }

  @override
  Future<Either<AppError, void>> addMovieToWishlist(
    MovieEntity movie,
  ) async {
    return  await _run(() => _dataSource.addMovieToWishlist(movie));
  }

  @override
  Future<Either<AppError, ProfileEntity>> addMovieToHistory(MovieEntity movie) {
    return _run(() => _dataSource.addMovieToHistory(movie));
  }

  Future<Either<AppError, T>> _run<T>(
    Future<T> Function() action,
  ) async {
    try {
      return Right(await action());
    } on RemoteAppException catch (error) {
      return Left(mapExceptionToError(error));
    } on TimeoutException {
      return Left(
        NetworkError('Request timed out. Please check your connection.'),
      );
    } on FirebaseException catch (error) {
      if (error.code == 'unavailable' ||
          error.code == 'network-request-failed') {
        return Left(NetworkError('No internet connection.'));
      }
      return Left(LocalError(error.message ?? 'Profile action failed.'));
    } catch (error) {
      return Left(LocalError(error.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> removeMovieFromWishlist(int movieId) async {
    return await _run(() => _dataSource.removeMovieFromWishlist(movieId));
  }

  @override
  Future<Either<AppError, List<int>>> getWishlist() async {
    return await _run(() => _dataSource.getWishlist());
  }


}
