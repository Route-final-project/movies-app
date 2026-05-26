part of 'browse_cubit.dart';

class BrowseState {
  const BrowseState({
    this.selectedGenre = 'Action',
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage = '',
  });

  final String selectedGenre;
  final List<MovieEntity> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final String errorMessage;

  BrowseState copyWith({
    String? selectedGenre,
    List<MovieEntity>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return BrowseState(
      selectedGenre: selectedGenre ?? this.selectedGenre,
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
