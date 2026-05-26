import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/presentation/feature/movie_detail/movie_entity_extesion.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../domain/entity/movie_entity.dart';
import '../movie_detail/movie_detail_cubit.dart';
import '../../common_component/moviePosterImage.dart';
import 'movieCard.dart';

class AvailableMoviesCarousel extends StatefulWidget {
  const AvailableMoviesCarousel({
    required this.movies,
    required this.onMovieClicked,
    super.key,
  });

  final List<MovieUiState> movies;
  final Function(MovieUiState) onMovieClicked;

  @override
  State<AvailableMoviesCarousel> createState() =>
      _AvailableMoviesCarouselState();
}

class _AvailableMoviesCarouselState extends State<AvailableMoviesCarousel> {
  int currentIndex = 0;
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    imageUrl = widget.movies[currentIndex].imageUrl;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 600.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          height: 600.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xCC121312), Color(0x99121312), Color(0xFF121312)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SizedBox(
          height: 600.h,
          child: Column(
            children: [
              Expanded(child: Image.asset(ImageAssets.availableNowImage)),
              SizedBox(height: 20.h),
              CarouselSlider(
                items: widget.movies
                    .map(
                      (e) => MovieCard(
                        movie: e,
                        onTap: (_) {
                          widget.onMovieClicked(e);
                        },
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 350.h,
                  viewportFraction: 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Image.asset(
                  ImageAssets.watchNowImage,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AvailableMoviesCarouselShimmer extends StatelessWidget {
  const AvailableMoviesCarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey.shade900,
          highlightColor: Colors.grey.shade700,
          child: Container(height: 600, color: Colors.black),
        ),

        SizedBox(
          height: 600,
          child: Column(
            children: [
              const Spacer(),

              // Fake carousel
              SizedBox(
                height: 350,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (_, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
