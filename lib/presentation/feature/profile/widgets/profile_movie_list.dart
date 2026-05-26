import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resource/assets_manager.dart';
import '../../../../domain/entity/movie_entity.dart';
import '../../home/movieCard.dart';

class ProfileMovieList extends StatelessWidget {
  const ProfileMovieList({required this.movies, super.key});

  final List<MovieEntity> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const _EmptyProfileMovies();

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 12.h),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: .60,
      ),
      itemBuilder: (context, index) =>
          MovieCard(movie: movies[index], compact: true),
    );
  }
}

class _EmptyProfileMovies extends StatelessWidget {
  const _EmptyProfileMovies();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImageAssets.emptySearchImage,
        width: 124.w,
        height: 124.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
