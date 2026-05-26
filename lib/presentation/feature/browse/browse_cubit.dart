import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entity/movie_entity.dart';
import '../../../domain/usecase/add_movie_to_history_use_case.dart';
import '../../../domain/usecase/browse_movies_use_case.dart';

part 'browse_state.dart';

@injectable
class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit({
    required this.browseMoviesUseCase,
    required this.addMovieToHistoryUseCase,
    @factoryParam String? initialGenre,
  }) : super(BrowseState(selectedGenre: initialGenre ?? 'Action')) {
    scrollController.addListener(_onScroll);
    fetchGenre(state.selectedGenre);
  }

  final BrowseMoviesUseCase browseMoviesUseCase;
  final AddMovieToHistoryUseCase addMovieToHistoryUseCase;
  final ScrollController scrollController = ScrollController();

  static const int _limit = 20;
  int _page = 1;
  bool _hasMore = true;

  Future<void> fetchGenre(String genre) async {
    _page = 1;
    _hasMore = true;
    emit(
      state.copyWith(
        selectedGenre: genre,
        movies: [],
        isLoading: true,
        isLoadingMore: false,
        errorMessage: '',
      ),
    );

    final result = await browseMoviesUseCase(genre, _page, limit: _limit);
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (movies) {
        _hasMore = movies.length == _limit;
        emit(state.copyWith(isLoading: false, movies: movies));
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading || state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, errorMessage: ''));
    final nextPage = _page + 1;
    final result = await browseMoviesUseCase(
      state.selectedGenre,
      nextPage,
      limit: _limit,
    );

    result.fold(
      (error) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: error.message),
      ),
      (movies) {
        _page = nextPage;
        _hasMore = movies.length == _limit;
        emit(
          state.copyWith(
            isLoadingMore: false,
            movies: [...state.movies, ...movies],
          ),
        );
      },
    );
  }

  Future<void> recordMovieInHistory(MovieEntity movie) async {
    final result = await addMovieToHistoryUseCase(movie);
    result.fold((_) {
      // History sync is best effort; browsing should stay uninterrupted.
    }, (_) => emit(state.copyWith(errorMessage: '')));
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      loadMore();
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
