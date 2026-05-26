import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/movie_genres.dart';
import '../../../../domain/entity/movie_entity.dart';
import '../../../../domain/usecase/add_movie_to_history_use_case.dart';
import '../../../../domain/usecase/add_movie_to_wishlist_use_case.dart';
import '../../../../domain/usecase/browse_movies_use_case.dart';

part 'home_category_state.dart';

@injectable
class HomeCategoryCubit extends Cubit<HomeCategoryState> {
  HomeCategoryCubit({
    required this.browseMoviesUseCase,
    required this.addMovieToHistoryUseCase,
    required this.addMovieToWishlistUseCase,
  }) : super(const HomeCategoryState());

  final BrowseMoviesUseCase browseMoviesUseCase;
  final AddMovieToHistoryUseCase addMovieToHistoryUseCase;
  final AddMovieToWishlistUseCase addMovieToWishlistUseCase;

  static int? _lastCategoryIndex;

  Future<void> loadNextCategory() async {
    final category = _nextCategory();
    emit(
      state.copyWith(
        isLoading: state.movies.isEmpty,
        isRefreshing: state.movies.isNotEmpty,
        errorMessage: '',
      ),
    );

    final result = await browseMoviesUseCase(category, 1, limit: 10);
    result.fold(
      (error) => emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: error.message,
        ),
      ),
      (movies) => emit(
        state.copyWith(
          category: category,
          movies: movies,
          isLoading: false,
          isRefreshing: false,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<void> recordMovieInHistory(MovieEntity movie) async {
    final result = await addMovieToHistoryUseCase(movie);
    result.fold((_) {
      // History sync is best effort; the Home shelf should stay uninterrupted.
    }, (_) => emit(state.copyWith(errorMessage: '')));
  }

  Future<void> addMovieToWishlist(MovieEntity movie) async {
    final result = await addMovieToWishlistUseCase(movie);
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (_) => emit(state.copyWith(errorMessage: '')),
    );
  }

  String _nextCategory() {
    final nextIndex = _lastCategoryIndex == null
        ? 0
        : (_lastCategoryIndex! + 1) % MovieGenres.all.length;
    _lastCategoryIndex = nextIndex;
    return MovieGenres.all[nextIndex];
  }
}
