import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resource/colors_manager.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/presentation/feature/movie_detail/movie_detail_cubit.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, required this.onTap, super.key});

  final MovieUiState movie;
  final void Function(int id) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(movie.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            CachedNetworkImage(
              scale: 1.0,
              height: 350.h,
              width: 235.w,
              imageUrl: movie.imageUrl,
              placeholder: (context, url) =>
                  Center(child: const CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsManager.grey.withAlpha(180),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        movie.rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorsManager.white,
                        ),
                      ),
                    ),

                    Icon(Icons.star, color: ColorsManager.gold, size: 18.r),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
