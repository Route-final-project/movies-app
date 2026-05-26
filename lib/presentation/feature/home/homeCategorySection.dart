import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/colors_manager.dart';
import '../browse/browseScreen.dart';
import 'home_category_cubit/home_category_cubit.dart';
import 'movieCard.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCategoryCubit, HomeCategoryState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage.isNotEmpty &&
          current.movies.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
      },
      builder: (context, state) {
        if (state.isLoading) {
          return SizedBox(
            height: 190.h,
            child: const Center(
              child: CircularProgressIndicator(color: ColorsManager.gold),
            ),
          );
        }

        if (state.errorMessage.isNotEmpty && state.movies.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }

        if (state.movies.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            child: Text(
              'No movies found',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(top: 18.h, bottom: 130.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorsManager.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                BrowseScreen(initialGenre: state.category),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          'See More →',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: ColorsManager.gold,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 150.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: state.movies.length,
                  separatorBuilder: (_, _) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return MovieCard(
                      movie: movie,
                      width: 102.w,
                      height: 150.h,
                      borderRadius: 12.r,
                      fit: BoxFit.contain,
                      badgeLeft: 8.w,
                      badgeTop: 8.h,
                      badgePadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      ratingIconSize: 14.r,
                      ratingTextStyle: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(
                            color: ColorsManager.white,
                            fontSize: 12.sp,
                          ),
                      onTap: (_) {
                        context.read<HomeCategoryCubit>().recordMovieInHistory(
                          movie,
                        );
                        // TODO: Navigate to movie details when a details route exists.
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
