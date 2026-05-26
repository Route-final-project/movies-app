import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies/domain/app_error.dart';

import '../../../../domain/entity/movie_entity.dart';
import '../../../../domain/usecase/add_movie_to_history_use_case.dart';
import '../../../../domain/usecase/add_movie_to_wishlist_use_case.dart';
import '../../../../domain/usecase/get_latest_movies_use_case.dart';

part 'available_movies_state.dart';

@injectable
class AvailableMoviesCubit extends Cubit<AvailableMoviesState> {
  AvailableMoviesCubit({
    required this.getLatestMoviesUseCase,
    required this.addMovieToHistoryUseCase,
    required this.addMovieToWishlistUseCase,
  }) : super(AvailableMoviesState());
  final GetLatestMoviesUseCase getLatestMoviesUseCase;
  final AddMovieToHistoryUseCase addMovieToHistoryUseCase;
  final AddMovieToWishlistUseCase addMovieToWishlistUseCase;

  void getAvailableMovies() async {
    emit(state.copyWith(isLoading: true));
    final result = await getLatestMoviesUseCase();
    result.fold(
      (error) {
        switch (error) {
          case NoInternetError():
            emit(state.copyWith(isLoading: false, internetAvailable: false));
          case NetworkError():
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: error.message,
                internetAvailable: true,
              ),
            );

          case LocalError():
          case AuthError():
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: error.message,
                internetAvailable: true,
              ),
            );
        }
      },
      (movies) {
        emit(state.copyWith(isLoading: false, movies: movies));
      },
    );
  }

  Future<void> recordMovieInHistory(MovieEntity movie) async {
    final result = await addMovieToHistoryUseCase(movie);
    result.fold((_) {
      // History sync is best effort; movie browsing should stay uninterrupted.
    }, (_) => emit(state.copyWith(errorMessage: '')));
  }

  Future<void> addMovieToWishlist(MovieEntity movie) async {
    final result = await addMovieToWishlistUseCase(movie);
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (_) => emit(state.copyWith(errorMessage: '')),
    );
  }
}
