import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resource/colors_manager.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/presentation/common_component/moviePosterImage.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    this.onTap,
    this.compact = false,
    this.width,
    this.height,
    this.borderRadius,
    this.badgeLeft,
    this.badgeTop,
    this.badgePadding,
    this.ratingIconSize,
    this.ratingTextStyle,
    this.fit,
    super.key,
  });

  final MovieEntity movie;
  final void Function(int id)? onTap;
  final bool compact;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? badgeLeft;
  final double? badgeTop;
  final EdgeInsetsGeometry? badgePadding;
  final double? ratingIconSize;
  final TextStyle? ratingTextStyle;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(11.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: MoviePosterImage(
                imageUrl: movie.imageUrl,
                fit: BoxFit.cover,
                placeholder: const Center(
                  child: CircularProgressIndicator(color: ColorsManager.gold),
                ),
                errorWidget: const ColoredBox(
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

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(movie.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            MoviePosterImage(
              height: height ?? 350.h,
              width: width ?? 235.w,
              imageUrl: movie.imageUrl,
              placeholder: const Center(child: CircularProgressIndicator()),
              errorWidget: const Icon(Icons.error),
              fit: fit ?? BoxFit.cover,
            ),

            Positioned(
              left: badgeLeft ?? 11.w,
              top: badgeTop ?? 11.h,
              child: Container(
                padding:
                    badgePadding ??
                    EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: ColorsManager.grey.withAlpha(180),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Text(
                        movie.rating.toStringAsFixed(1),
                        style:
                            ratingTextStyle ??
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorsManager.white,
                            ),
                      ),
                    ),

                    SizedBox(width: 2.w),
                    Icon(
                      Icons.star,
                      color: ColorsManager.gold,
                      size: ratingIconSize ?? 18.r,
                    ),
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
