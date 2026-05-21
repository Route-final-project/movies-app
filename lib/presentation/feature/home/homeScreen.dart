import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../../domain/usecase/get_latest_movies_use_case.dart';
import '../../../generated/assets.dart';
import 'available_movies_cubit/available_movies_cubit.dart';
import 'movieCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageUrl = "";
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvailableMoviesCubit(
        getLatestMoviesUseCase: getIt.get<GetLatestMoviesUseCase>(),
      )..getAvailableMovies(),
      child: Column(
        children: [
          BlocConsumer<AvailableMoviesCubit, AvailableMoviesState>(
            listener: (context, state){
              if(state.internetAvailable != true){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No internet connection"))
                );
              }
              if(state.errorMessage.isNotEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage))
                );
              }
            },
            builder: (context, state) {
                  if (state.isLoading){
                    return const Center(child: CircularProgressIndicator(color: ColorsManager.gold,));
                  }else if (state.movies.isEmpty){
                    return const Center(child: Text("No available movies"));
                  }else {
                    imageUrl = state.movies[currentIndex].imageUrl;
                    print("==> movies ${state.movies}");
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
                              colors: [
                                Color(0xCC121312),
                                Color(0x99121312),
                                Color(0xFF121312),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 600.h,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  ImageAssets.availableNowImage,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CarouselSlider(
                                items: state.movies
                                    .map((e) => MovieCard(movie: e, onTap: (_) {}))
                                    .toList(),
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  height: 350.h,
                                  viewportFraction: 0.5,
                                  onPageChanged: (index, reason) {
                                    print("==> index $index");
                                    print(state.movies[index].imageUrl);
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
            },
          ),
        ],
      ),
    );
  }
}
