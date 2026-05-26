import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entity/movie_entity.dart';
import '../../../domain/usecase/add_movie_to_history_use_case.dart';
import '../../../domain/usecase/add_movie_to_wishlist_use_case.dart';
import '../../../domain/usecase/search_movies_use_case.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.searchMoviesUseCase,
    required this.addMovieToHistoryUseCase,
    required this.addMovieToWishlistUseCase,
  }) : super(SearchState(movies: [])) {
    controller.addListener(() {
      if (controller.text.trim() == state.query) {
        return;
      }
      if (controller.text != state.query) {
        page = 1;
      }
      _findMovies(controller.text, page);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoading = true;
        page += 1;
        loadMore(controller.text, page);
        isLoading = false;
      }
    });
  }

  final SearchMoviesUseCase searchMoviesUseCase;
  final AddMovieToHistoryUseCase addMovieToHistoryUseCase;
  final AddMovieToWishlistUseCase addMovieToWishlistUseCase;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;

  void _findMovies(String query, int page) async {
    if (query.isEmpty) {
      return;
    }
    emit(state.copyWith(query: query, isLoading: true));
    final result = await searchMoviesUseCase(query, page);
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (movies) {
        emit(state.copyWith(isLoading: false, movies: movies));
      },
    );
  }

  void loadMore(String query, int page) async {
    if (query.isEmpty) {
      emit(state.copyWith(movies: []));
      return;
    }

    final result = await searchMoviesUseCase(query, page);
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (movies) => emit(
        state.copyWith(isLoading: false, movies: [...state.movies, ...movies]),
      ),
    );
  }

  Future<void> recordMovieInHistory(MovieEntity movie) async {
    final result = await addMovieToHistoryUseCase(movie);
    result.fold((_) {
      // History sync is best effort; search browsing should stay uninterrupted.
    }, (_) => emit(state.copyWith(errorMessage: '')));
  }

  Future<void> addMovieToWishlist(MovieEntity movie) async {
    final result = await addMovieToWishlistUseCase(movie);
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (_) => emit(state.copyWith(errorMessage: '')),
    );
  }

  @override
  Future<void> close() {
    controller.dispose();
    scrollController.dispose();
    return super.close();
  }
}
