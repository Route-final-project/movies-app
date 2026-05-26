part of 'home_category_cubit.dart';

class HomeCategoryState {
  const HomeCategoryState({
    this.category = 'Action',
    this.movies = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage = '',
  });

  final String category;
  final List<MovieEntity> movies;
  final bool isLoading;
  final bool isRefreshing;
  final String errorMessage;

  HomeCategoryState copyWith({
    String? category,
    List<MovieEntity>? movies,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return HomeCategoryState(
      category: category ?? this.category,
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
