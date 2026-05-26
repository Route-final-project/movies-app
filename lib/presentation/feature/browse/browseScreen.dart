import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../../config/movie_genres.dart';
import '../home/movieCard.dart';
import 'browse_cubit.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({this.initialGenre, super.key});

  final String? initialGenre;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BrowseCubit>(param1: initialGenre),
      child: const _BrowseView(),
    );
  }
}

class _BrowseView extends StatelessWidget {
  const _BrowseView();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.black,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrowseHeader(),
            SizedBox(height: 12.h),
            const _GenreChips(),
            SizedBox(height: 14.h),
            const Expanded(child: _MoviesGrid()),
          ],
        ),
      ),
    );
  }
}

class _BrowseHeader extends StatelessWidget {
  const _BrowseHeader();

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Row(
      children: [
        if (canPop) ...[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: ColorsManager.gold,
            iconSize: 22.r,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.r, 32.r)),
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          'Browse',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorsManager.white.withValues(alpha: .45),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _GenreChips extends StatelessWidget {
  const _GenreChips();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: BlocBuilder<BrowseCubit, BrowseState>(
        buildWhen: (previous, current) =>
            previous.selectedGenre != current.selectedGenre,
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MovieGenres.all.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final genre = MovieGenres.all[index];
              final isSelected = genre == state.selectedGenre;

              return _GenreChip(
                title: genre,
                isSelected: isSelected,
                onTap: () {
                  if (!isSelected) {
                    context.read<BrowseCubit>().fetchGenre(genre);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorsManager.gold, width: 2),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? ColorsManager.black : ColorsManager.gold,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  const _MoviesGrid();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrowseCubit, BrowseState>(
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
          return const Center(
            child: CircularProgressIndicator(color: ColorsManager.gold),
          );
        }

        if (state.errorMessage.isNotEmpty && state.movies.isEmpty) {
          return Center(
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state.movies.isEmpty) {
          return Center(
            child: Text(
              'No movies found',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return GridView.builder(
          controller: context.read<BrowseCubit>().scrollController,
          padding: EdgeInsets.only(bottom: 96.h),
          itemCount: state.movies.length + (state.isLoadingMore ? 2 : 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: .69,
          ),
          itemBuilder: (context, index) {
            if (index >= state.movies.length) {
              return const Center(
                child: CircularProgressIndicator(color: ColorsManager.gold),
              );
            }

            final movie = state.movies[index];
            return MovieCard(
              movie: movie,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 10.r,
              badgeLeft: 6.w,
              badgeTop: 8.h,
              badgePadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              ratingIconSize: 14.r,
              ratingTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorsManager.white,
                fontWeight: FontWeight.w400,
              ),
              onTap: (_) {
                context.read<BrowseCubit>().recordMovieInHistory(movie);
                // TODO: Navigate to movie details when a details route exists.
              },
            );
          },
        );
      },
    );
  }
}
