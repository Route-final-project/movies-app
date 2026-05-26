import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/domain/app_error.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/domain/usecase/get_movie_details_by_id_user_case.dart';
import 'package:movies/domain/usecase/get_similar_movies_use_case.dart';
import 'package:movies/presentation/feature/movie_detail/movie_entity_extesion.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/usecase/add_movie_to_wishlist_use_case.dart';
import '../../../domain/usecase/get_wishlist_use_case.dart';
import '../../../domain/usecase/remove_movie_from_wishlist_use_case.dart';

part 'movie_detail_state.dart';

@injectable
class MovieDetailCubit extends Cubit<MovieUiState> {
  MovieDetailCubit({
    required this.getMovieDetailsByIdUserCase,
    required this.getSimilarMoviesUseCase,
    required this.addMovieToWishlistUseCase,
    required this.getWishlistUseCase,
    required this.removeMovieFromWishlistUseCase,
    required this.movieId,
  }) : super(MovieUiState.initial())  {
    getMovieDetails(movieId);
    getSimilarMovies(movieId);
    getWishlist();
  }

  GetMovieDetailsByIdUserCase getMovieDetailsByIdUserCase;
  GetSimilarMoviesUseCase getSimilarMoviesUseCase;
  AddMovieToWishlistUseCase addMovieToWishlistUseCase;
  GetWishlistUseCase getWishlistUseCase;
  RemoveMovieFromWishlistUseCase removeMovieFromWishlistUseCase;
  int movieId;

  void getMovieDetails(int movieId) async {
    emit(state.copyWith(isLoading: true));
    Either<AppError, MovieEntity> result = await getMovieDetailsByIdUserCase(
      movieId,
    );
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (movie) {
        emit(state.copyWith(
          id: movie.id,
          rating: movie.rating.toString(),
          imageUrl: movie.imageUrl,
          details: movie.movieDetail?.toUiState(),
          isLoading: false,
        ));

      },
    );
  }

  void getSimilarMovies(int movieId) async {
    emit(state.copyWith(isSimilarMoviesLoading: true));
    Either<AppError, List<MovieEntity>> result = await getSimilarMoviesUseCase(
      movieId,
    );
    result.fold(
      (error) => emit(
        state.copyWith(
          isSimilarMoviesLoading: false,
          errorMessage: error.message,
        ),
      ),
      (movie) => emit(
        state.copyWith(
          similarMovies: movie.map((m) => m.toUiState()).toList(),
          isSimilarMoviesLoading: false,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> toggleFavorite() async {
    if (!state.isFavorite) {
      var result = await addMovieToWishlistUseCase(
        MovieEntity(
          id: movieId,
          rating: double.tryParse(state.rating) ?? 0.0,
          imageUrl: state.imageUrl,
        ),
      );
      result.fold((_) {}, (_) {
        emit(state.copyWith(isFavorite: true));
      });
    } else {
      var result = await removeMovieFromWishlistUseCase(movieId);
      result.fold((_) {}, (_) {
        emit(state.copyWith(isFavorite: false));
      });
    }
  }

   void getWishlist() async {
    Either<AppError, List<int>> result = await getWishlistUseCase();
    List<int> moviesIds =  result.fold((error) => [], (list) => list);

    if(moviesIds.contains(movieId)){
      emit(state.copyWith(isFavorite: true));
    }else{
      emit(state.copyWith(isFavorite: false));
    }
  }

  void openYtTrailer() async {
    try {
      Uri ytTrailerLink = Uri(
        scheme: "https",
        host: "www.youtube.com",
        path: "/watch",
        queryParameters: {"v": state.details?.trailerYTCode ?? ""},
      );
      await launchUrl(ytTrailerLink);
    } catch (e) {
      emit(state.copyWith(trailerErrorMessage: "Error opening trailer"));
    }
  }
}
