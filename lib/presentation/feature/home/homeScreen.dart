import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resource/routes_manager.dart';

import '../../../config/path_argument.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../../domain/usecase/get_latest_movies_use_case.dart';
import 'availableMoviesCarousel.dart';
import 'available_movies_cubit/available_movies_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvailableMoviesCubit(
        getLatestMoviesUseCase: getIt.get<GetLatestMoviesUseCase>(),
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
                  movies: state.movies,
                  onMovieClicked: (movieUiState) => {
                    Navigator.pushNamed(
                      context,
                      RoutesManger.movieDetailScreen,
                      arguments: {PathArguments.movieId: movieUiState.id},
                    ),
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
