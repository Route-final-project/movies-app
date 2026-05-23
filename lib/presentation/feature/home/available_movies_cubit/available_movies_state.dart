part of 'available_movies_cubit.dart';

class AvailableMoviesState {
  List<MovieEntity> movies;
  int currentIndex;
  String errorMessage;
  bool internetAvailable;
  bool isLoading;

  AvailableMoviesState({
    this.movies = const [],
    this.errorMessage = "",
    this.currentIndex = 0,
    this.internetAvailable = true,
    this.isLoading = false,

  });

  AvailableMoviesState copyWith({
    List<MovieEntity>? movies,
    int? currentIndex,
    bool? internetAvailable,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AvailableMoviesState(
      movies: movies ?? this.movies,
      currentIndex: currentIndex ?? this.currentIndex,
      internetAvailable: internetAvailable ?? this.internetAvailable,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
//
// final class AvailableMoviesInitial extends AvailableMoviesState {}
// final class AvailableMoviesLoading extends AvailableMoviesState {}
// final class AvailableMoviesSuccess extends AvailableMoviesState {
//   final List<MovieEntity> movies;
//   AvailableMoviesSuccess({required this.movies});
// }
// final class AvailableMoviesError extends AvailableMoviesState {
//   final String message;
//   AvailableMoviesError({required this.message});
// }
