class MovieEntity {
  final int id;
  final double rating;
  final String imageUrl;
  final MovieDetailModel? movieDetail;

  MovieEntity({
    required this.id,
    required this.rating,
    required this.imageUrl,
    this.movieDetail,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "MovieEntity(id: $id, rating: $rating, imageUrl: $imageUrl, movieDetail: $movieDetail)";
  }
}

class MovieDetailModel {
  final List<CastModel> cast;
  final String title;
  final String year;
  final List<String> genres;
  final int likeCount;
  final String summary;
  final String trailerYTCode;
  final String backgroundImage;
  final List<String> screenshotImagesUrl;
  final int runtime;

  MovieDetailModel({
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
}

class CastModel {
  String name;
  String character;
  String imageUrl;

  CastModel({
    required this.name,
    required this.character,
    required this.imageUrl,
  });
}
