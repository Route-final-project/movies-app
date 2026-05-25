import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/data_source/remote_data_source/response_object/movies_list_response.dart';

import '../../config/app_constants.dart';
import 'exception/handleDioException.dart';
import 'exception/remote_exception.dart';
import 'response_object/movieDetailsResponse.dart'
    show MovieResponse, MovieDetail;

@lazySingleton
class RemoteDataSource {
  final Dio dio;

  RemoteDataSource(this.dio);

  Future<List<Movie>> getLatestMovies() async {
    Response response;
    try {
      response = await dio.get(
        AppConstants.moviesListEndpoint,
        queryParameters: {"sort_by": "date_added", "order_by": "desc"},
      );
      MoviesListResponse moviesListResponse = MoviesListResponse.fromJson(
        response.data,
      );
      return moviesListResponse.data?.movies ?? [];
    } on SocketException catch (_) {
      throw NoInternetException('No Internet Connection');
    } on DioException catch (e) {
      throw handleDioException(e);
    } on Exception catch (_) {
      throw RemoteException('Network error');
    }
  }

  Future<List<Movie>> findMovies(String query, int page) async {
    Response response;
    try {
      response = await dio.get(
        AppConstants.moviesListEndpoint,
        queryParameters: {
          "page": page,
          "limit": 20,
          "sort_by": "date_added",
          "order_by": "desc",
          "query_term": query,
        },
      );
      MoviesListResponse moviesListResponse = MoviesListResponse.fromJson(
        response.data,
      );
      return moviesListResponse.data?.movies ?? [];
    } on SocketException catch (_) {
      throw NoInternetException('No Internet Connection');
    } on DioException catch (e) {
      throw handleDioException(e);
    } on Exception catch (_) {
      throw RemoteException('Network error');
    }
  }

  Future<MovieDetail> getMovieDetailsById(int movieId) async {
    Response response;
    try {
      response = await dio.get(
        AppConstants.movieDetailsEndpoint,
        queryParameters: {
          "movie_id": movieId,
          "with_images": true,
          "with_cast": true,
        },
      );
      MovieResponse movieResponse;
      try {
        movieResponse = MovieResponse.fromJson(response.data);
      } catch (e) {
        rethrow;
      }
      MovieDetail movie;
      if (movieResponse.data?.movie == null) {
        throw RemoteException('Movie not found');
      } else {
        movie = movieResponse.data!.movie!;
      }
      return movie;
    } on SocketException catch (_) {
      throw NoInternetException('No Internet Connection');
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    Response response;
    try {
      response = await dio.get(
        AppConstants.similarMoviesEndpoint,
        queryParameters: {"movie_id": movieId},
      );

      MoviesListResponse moviesListResponse = MoviesListResponse.fromJson(
        response.data,
      );
      return moviesListResponse.data?.movies ?? [];
    } on SocketException catch (_) {
      throw NoInternetException('No Internet Connection');
    } on DioException catch (e) {
      throw handleDioException(e);
    } on Exception catch (_) {
      throw RemoteException('Network error');
    }
  }
}
