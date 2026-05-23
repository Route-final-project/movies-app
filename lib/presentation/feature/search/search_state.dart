part of 'search_cubit.dart';

class SearchState {
  String query;
  List<MovieEntity> movies;
  bool isLoading;

  String errorMessage;

  SearchState({
     this.query = "",
     required this.movies ,
    this.isLoading = false,
    this.errorMessage = "",
  });
  @override
  toString() {
    return "SearchState(query: $query, movies: $movies, isLoading: $isLoading, errorMessage: $errorMessage)";
  }

  SearchState copyWith({
    String? query,
    List<MovieEntity>? movies,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
