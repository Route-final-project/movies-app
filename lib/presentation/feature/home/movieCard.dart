import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resource/colors_manager.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/presentation/feature/movie_detail/movie_detail_cubit.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final bool compact;
  final MovieUiState movie;
  final void Function(int id) onTap;

  @override
  Widget build(BuildContext context) {
    if (compact) {
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
                      movie.rating,
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

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(movie.id),
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
