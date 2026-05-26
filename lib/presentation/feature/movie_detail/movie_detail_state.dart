part of 'movie_detail_cubit.dart';

class MovieUiState extends Equatable {
  final bool isLoading;
  final bool isSimilarMoviesLoading;
  final String errorMessage;
  final String trailerErrorMessage;
  final int id;
  final String rating;
  final String imageUrl;
  final MovieDetailUiState? details;
  final bool isFavorite;
  final List<MovieUiState> similarMovies;

  @override
  String toString() {
    return '''
MovieUiState(
  isLoading: $isLoading,
  errorMessage: $errorMessage,
  id: $id,
  rating: $rating,
  imageUrl: $imageUrl,
  details: $details
)
''';
  }

  const MovieUiState({
    required this.isLoading,
    required this.errorMessage,
    required this.id,
    required this.rating,
    required this.imageUrl,
    required this.similarMovies,
    required this.isSimilarMoviesLoading,
    required this.isFavorite,
    required this.trailerErrorMessage,
    this.details,
  });

  MovieUiState copyWith({
    String? trailerErrorMessage,
    bool? isFavorite,
    bool? isLoading,
    String? errorMessage,
    bool? isSimilarMoviesLoading,
    int? id,
    String? rating,
    String? imageUrl,
    MovieDetailUiState? details,
    List<MovieUiState>? similarMovies,
  }) {
    return MovieUiState(
      trailerErrorMessage: trailerErrorMessage ?? this.trailerErrorMessage,
      isSimilarMoviesLoading:
          isSimilarMoviesLoading ?? this.isSimilarMoviesLoading,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      id: id ?? this.id,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      details: details,
      similarMovies: similarMovies ?? this.similarMovies,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory MovieUiState.initial() {
    return MovieUiState(
      id: 0,
      rating: '',
      imageUrl: '',
      details: MovieDetailUiState.initial(),
      isLoading: false,
      errorMessage: '',
      similarMovies: [],
      isSimilarMoviesLoading: false,
      isFavorite: false,
      trailerErrorMessage: '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    rating,
    imageUrl,
    details,
    isLoading,
    isSimilarMoviesLoading,
    errorMessage,
    similarMovies,
    isFavorite,
    trailerErrorMessage,
  ];
}

class MovieDetailUiState {
  final List<CastUiState> cast;
  final String title;
  final String year;
  final List<String> genres;
  final String likeCount;
  final String summary;
  final String trailerYTCode;
  final String backgroundImage;
  final List<String> screenshotImagesUrl;
  final String runtime;

  @override
  String toString() {
    return '''
MovieDetailUiState(
  cast: $cast,
  title: $title,
  year: $year,
  genres: $genres,
  likeCount: $likeCount,
  summary: $summary,
  trailerYTCode: $trailerYTCode,
  backgroundImage: $backgroundImage,
  screenshotImagesUrl: $screenshotImagesUrl,
  runtime: $runtime
)
''';
  }

  const MovieDetailUiState({
    required this.cast,
    required this.title,
    required this.year,
    required this.genres,
    required this.likeCount,
    required this.summary,
    required this.trailerYTCode,
    required this.backgroundImage,
    required this.screenshotImagesUrl,
    required this.runtime,
  });

  factory MovieDetailUiState.initial() {
    return const MovieDetailUiState(
      cast: [],
      title: '',
      year: '',
      genres: [],
      likeCount: '',
      summary: '',
      trailerYTCode: '',
      backgroundImage: '',
      screenshotImagesUrl: [],
      runtime: '',
    );
  }
}

class CastUiState {
  final String name;
  final String character;
  final String imageUrl;

  const CastUiState({
    required this.name,
    required this.character,
    required this.imageUrl,
  });

  @override
  String toString() {
    return '''
CastUiState(
  name: $name,
  character: $character,
  imageUrl: $imageUrl
)
''';
  }

  factory CastUiState.initial() {
    return const CastUiState(name: '', character: '', imageUrl: '');
  }
}
