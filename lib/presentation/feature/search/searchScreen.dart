import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/resource/colors_manager.dart';
import 'package:movies/dependency_injection/di.dart';
import 'package:movies/presentation/common_component/appTextField.dart';
import 'package:movies/presentation/feature/search/search_cubit.dart';

import '../../../core/resource/assets_manager.dart';
import '../../../domain/usecase/add_movie_to_history_use_case.dart';
import '../../../domain/usecase/add_movie_to_wishlist_use_case.dart';
import '../../../domain/usecase/search_movies_use_case.dart';
import '../home/movieCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(
      (timeStamp) => textFieldFocus.requestFocus(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textFieldFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        searchMoviesUseCase: getIt<SearchMoviesUseCase>(),
        addMovieToHistoryUseCase: getIt<AddMovieToHistoryUseCase>(),
        addMovieToWishlistUseCase: getIt<AddMovieToWishlistUseCase>(),
      ),
      child: Column(
        children: [
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
                child: AppTextField(
                  focusNode: textFieldFocus,
                  controller: BlocProvider.of<SearchCubit>(context).controller,
                  prefixIcon: SvgPicture.asset(
                    IconAssets.searchIcon,
                    colorFilter: ColorFilter.mode(
                      ColorsManager.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  hintText: "Search",
                  validator: (_) => null,
                  onChanged: (value) {},
                  onTap: () {},
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.query.isEmpty && state.movies.isEmpty) {
                  return Center(
                    child: Image.asset(
                      ImageAssets.emptySearchImage,
                      width: 124.w,
                      height: 124.h,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.movies.isEmpty && state.query.isNotEmpty) {
                  return Center(child: Text("No results"));
                }
                if (state.errorMessage.isNotEmpty) {
                  return Center(child: Text(state.errorMessage));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    controller: BlocProvider.of<SearchCubit>(
                      context,
                    ).scrollController,
                    itemBuilder: (context, index) {
                      if (index >= state.movies.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return MovieCard(
                        movie: state.movies[index],
                        onTap: (int id) => context
                            .read<SearchCubit>()
                            .recordMovieInHistory(state.movies[index]),
                        onWishlistTap: () => context
                            .read<SearchCubit>()
                            .addMovieToWishlist(state.movies[index]),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: BlocProvider.of<SearchCubit>(context).isLoading
                        ? state.movies.length + 2
                        : state.movies.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
