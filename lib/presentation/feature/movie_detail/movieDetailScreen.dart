import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/resource/colors_manager.dart';
import 'package:movies/domain/usecase/get_movie_details_by_id_user_case.dart';
import 'package:movies/domain/usecase/get_similar_movies_use_case.dart';
import 'package:movies/presentation/common_component/secondaryAppButton.dart';
import 'package:movies/presentation/feature/movie_detail/movie_detail_cubit.dart';
import 'package:movies/presentation/feature/movie_detail/widgets/castMemberCard.dart';
import 'package:movies/presentation/feature/movie_detail/widgets/customChip.dart';
import 'package:movies/presentation/feature/movie_detail/widgets/titleSection.dart';

import '../../../config/path_argument.dart';
import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/routes_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../../domain/usecase/add_movie_to_wishlist_use_case.dart';
import '../../../domain/usecase/get_wishlist_use_case.dart';
import '../../../domain/usecase/remove_movie_from_wishlist_use_case.dart';
import '../home/movieCard.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({required this.movieId, super.key});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailCubit(
        getMovieDetailsByIdUserCase: getIt<GetMovieDetailsByIdUserCase>(),
        getSimilarMoviesUseCase: getIt<GetSimilarMoviesUseCase>(),
        addMovieToWishlistUseCase: getIt<AddMovieToWishlistUseCase>(),
        getWishlistUseCase: getIt<GetWishlistUseCase>(),
        removeMovieFromWishlistUseCase: getIt<RemoveMovieFromWishlistUseCase>(),
        movieId: movieId,
      ),
      child: BlocListener<MovieDetailCubit, MovieUiState>(
        listener: (context, state) {
          if (state.trailerErrorMessage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.trailerErrorMessage)));
          }
        },
        child: BlocBuilder<MovieDetailCubit, MovieUiState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (state.errorMessage.isNotEmpty) {
              Scaffold(body: Center(child: Text(state.errorMessage)));
            }
            return Scaffold(
              extendBodyBehindAppBar: true,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 500.h,
                    pinned: true,
                    collapsedHeight: 70.h,
                    backgroundColor: ColorsManager.black,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    actionsPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    actions: [
                      BlocBuilder<MovieDetailCubit, MovieUiState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              await BlocProvider.of<MovieDetailCubit>(
                                context,
                              ).toggleFavorite();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: SvgPicture.asset(
                                colorFilter: ColorFilter.mode(
                                  state.isFavorite
                                      ? ColorsManager.gold
                                      : ColorsManager.white,
                                  BlendMode.srcIn,
                                ),
                                IconAssets.bookMarkIcon,
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: state.imageUrl,
                            placeholder: (context, url) => Center(
                              child: const CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0x33121312), Color(0xFF121312)],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                IconAssets.playIcon,
                                width: 97.w,
                                height: 97.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18.0,
                        right: 16.0,
                        left: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10.h),
                          Visibility(
                            visible: state.details?.title.isNotEmpty ?? false,
                            child: Text(
                              state.details?.title ?? "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            state.details?.year ?? "",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: Color(0xFFADADAD)),
                          ),
                          SizedBox(height: 10.h),
                          SecondaryAppButton(
                            text: "Watch",
                            onPressed: () {
                              BlocProvider.of<MovieDetailCubit>(
                                context,
                              ).openYtTrailer();
                            },
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomChip(
                                value: state.details?.likeCount ?? "",
                                svgIconAsset: IconAssets.likeCountIcon,
                              ),
                              CustomChip(
                                value: state.details?.runtime ?? "",
                                svgIconAsset: IconAssets.watchCountIcon,
                              ),
                              CustomChip(
                                value: state.rating,
                                svgIconAsset: IconAssets.starCountIcon,
                              ),
                            ],
                          ),
                          Visibility(
                            visible:
                                state.details?.screenshotImagesUrl.isNotEmpty ??
                                false,
                            child: TitleSection(title: "Screen Shots"),
                          ),
                          ...state.details?.screenshotImagesUrl.map((imageUrl) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList() ??
                              [],
                          Visibility(
                            visible: state.similarMovies.isNotEmpty,
                            child: TitleSection(title: "Similar"),
                          ),
                          BlocBuilder<MovieDetailCubit, MovieUiState>(
                            builder: (context, state) {
                              if (state.isSimilarMoviesLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state.errorMessage.isNotEmpty) {
                                return Text(state.errorMessage);
                              }
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.similarMovies.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 16.w,
                                      mainAxisSpacing: 16.h,
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2,
                                    ),
                                itemBuilder: (context, index) {
                                  var currentMovie = state.similarMovies[index];
                                  return MovieCard(
                                    onTap: (_) {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesManger.movieDetailScreen,
                                        arguments: {
                                          PathArguments.movieId:
                                              currentMovie.id,
                                        },
                                      );
                                    },
                                    movie: currentMovie,
                                  );
                                },
                              );
                            },
                          ),
                          Visibility(
                              visible: state.details?.summary.isNotEmpty ?? false,
                              child: TitleSection(title: "Summary")),
                          Text(
                            state.details?.summary ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Visibility(
                              visible: state.details?.cast.isNotEmpty ?? false,
                              child: TitleSection(title: "Cast")),
                          ...state.details?.cast.map((cast) {
                                return CastMemberCard(cast: cast);
                              }) ??
                              [],
                          Visibility(
                              visible: state.details?.genres.isNotEmpty ?? false,
                              child: TitleSection(title: "Genres")),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 2.7,
                                  mainAxisSpacing: 16.h,
                                  crossAxisSpacing: 16.w,
                                ),
                            itemCount: state.details?.genres.length ?? 0,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                                ),
                                child: Text(
                                  state.details?.genres[index] ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
