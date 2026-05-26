import '../../../domain/entity/movie_entity.dart';
import 'movie_detail_cubit.dart';

extension MovieEntityMapper on MovieEntity {
  MovieUiState toUiState() {
    return MovieUiState(
      isLoading: false,
      errorMessage: "",
      id: id,
      rating: rating.toString(),
      imageUrl: imageUrl,
      details: movieDetail?.toUiState(),
      similarMovies: [],
      isSimilarMoviesLoading: false,
      isFavorite: false,
      trailerErrorMessage: ""
    );
  }
}

extension MovieDetailEntityMapper on MovieDetailModel {
  MovieDetailUiState toUiState() {
    return MovieDetailUiState(
      cast: cast.map((e) => e.toUiState()).toList(),
      title: title,
      year: year,
      genres: genres,
      likeCount: likeCount.toString(),
      summary: summary,
      trailerYTCode: trailerYTCode,
      backgroundImage: backgroundImage,
      screenshotImagesUrl: screenshotImagesUrl,
      runtime: runtime.toString(),
    );
  }
}

extension CastEntityMapper on CastModel {
  CastUiState toUiState() {
    return CastUiState(name: name, character: character, imageUrl: imageUrl);
  }
}
