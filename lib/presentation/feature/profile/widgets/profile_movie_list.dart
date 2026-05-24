import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resource/colors_manager.dart';
import '../../../../domain/entity/movie_entity.dart';

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
      itemBuilder: (context, index) => _ProfileMovieCard(movie: movies[index]),
    );
  }
}

class _ProfileMovieCard extends StatelessWidget {
  const _ProfileMovieCard({required this.movie});

  final MovieEntity movie;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11.r),
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: movie.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => const Center(
                child: CircularProgressIndicator(color: ColorsManager.gold),
              ),
              errorWidget: (_, _, _) => const ColoredBox(
                color: ColorsManager.grey,
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          Positioned(
            left: 5.w,
            top: 5.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: ColorsManager.grey.withValues(alpha: .8),
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.star, color: ColorsManager.gold, size: 12.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProfileMovies extends StatelessWidget {
  const _EmptyProfileMovies();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.movie_filter_outlined,
        color: ColorsManager.gold,
        size: 86.r,
      ),
    );
  }
}
