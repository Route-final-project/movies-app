import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/domain/app_error.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/domain/usecase/get_movie_details_by_id_user_case.dart';
import 'package:movies/domain/usecase/get_similar_movies_use_case.dart';
import 'package:movies/presentation/feature/movie_detail/movie_entity_extesion.dart';
import 'package:url_launcher/url_launcher.dart';

part 'movie_detail_state.dart';

@injectable
class MovieDetailCubit extends Cubit<MovieUiState> {
  MovieDetailCubit({
    required this.getMovieDetailsByIdUserCase,
    required this.getSimilarMoviesUseCase,
    required this.movieId,
  }) : super(MovieUiState.initial()) {
    getMovieDetails(movieId);
    getSimilarMovies(movieId);
  }

  GetMovieDetailsByIdUserCase getMovieDetailsByIdUserCase;
  GetSimilarMoviesUseCase getSimilarMoviesUseCase;
  int movieId;

  void getMovieDetails(int movieId) async {
    emit(state.copyWith(isLoading: true));
    Either<AppError, MovieEntity> result = await getMovieDetailsByIdUserCase(
      movieId,
    );
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (movie) => emit(movie.toUiState()),
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

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
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
