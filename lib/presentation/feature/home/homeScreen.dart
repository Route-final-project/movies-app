import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import 'availableMoviesCarousel.dart';
import 'available_movies_cubit/available_movies_cubit.dart';
import 'homeCategorySection.dart';
import 'home_category_cubit/home_category_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.refreshToken = 0, super.key});

  final int refreshToken;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AvailableMoviesCubit _availableMoviesCubit;
  late final HomeCategoryCubit _homeCategoryCubit;

  @override
  void initState() {
    super.initState();
    _availableMoviesCubit = getIt<AvailableMoviesCubit>()..getAvailableMovies();
    _homeCategoryCubit = getIt<HomeCategoryCubit>()..loadNextCategory();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _homeCategoryCubit.loadNextCategory();
    }
  }

  @override
  void dispose() {
    _availableMoviesCubit.close();
    _homeCategoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvailableMoviesCubit(
        getLatestMoviesUseCase: getIt.get<GetLatestMoviesUseCase>(),
        addMovieToHistoryUseCase: getIt.get<AddMovieToHistoryUseCase>(),
      )..getAvailableMovies(),
      child: Column(
        children: [
          BlocConsumer<AvailableMoviesCubit, AvailableMoviesState>(
            listener: (context, state) {
              if (state.internetAvailable != true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No internet connection")),
                );
              }
              if (state.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return SizedBox(
                  height: 600.h,
                  child: Center(
                    child: CircularProgressIndicator(color: ColorsManager.gold),
                  ),
                );
              } else if (state.movies.isEmpty) {
                return const Center(child: Text("No available movies"));
              } else {
                return AvailableMoviesCarousel(
                  movies: state.movies.map((e) => e.toUiState()).toList(),
                  onMovieClicked: (movieUiState) async {
                    await context.read<AvailableMoviesCubit>().recordMovieInHistory(
                      movieUiState,
                    );
                    Navigator.pushNamed(
                      context,
                      RoutesManger.movieDetailScreen,
                      arguments: {PathArguments.movieId: movieUiState.id},
                    );
                  },
                );
              }
            },
          ),
        ],
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _availableMoviesCubit),
        BlocProvider.value(value: _homeCategoryCubit),
      ],
      child: Material(
        color: ColorsManager.black,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BlocConsumer<AvailableMoviesCubit, AvailableMoviesState>(
                listener: (context, state) {
                  if (state.internetAvailable != true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No internet connection")),
                    );
                  }
                  if (state.errorMessage.isNotEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    // return AvailableMoviesCarouselShimmer();
                    return SizedBox(
                      height: 600.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.gold,
                        ),
                      ),
                    );
                  } else if (state.movies.isEmpty) {
                    return SizedBox(
                      height: 600.h,
                      child: const Center(child: Text("No available movies")),
                    );
                  } else {
                    return AvailableMoviesCarousel(
                      movies: state.movies,
                      onMovieClicked: (movie) => context
                          .read<AvailableMoviesCubit>()
                          .recordMovieInHistory(movie),
                      onWishlistClicked: (movie) => context
                          .read<AvailableMoviesCubit>()
                          .addMovieToWishlist(movie),
                    );
                  }
                },
              ),
            ),
            const SliverToBoxAdapter(child: HomeCategorySection()),
          ],
        ),
      ),
    );
  }
}
