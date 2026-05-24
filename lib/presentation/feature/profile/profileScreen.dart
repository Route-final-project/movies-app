import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resource/colors_manager.dart';
import '../../../dependency_injection/di.dart';
import '../../common_component/primaryAppButton.dart';
import '../../common_component/secondaryAppButton.dart';
import '../auth/login_screen.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'update_profile_screen.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_movie_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.didSignOut) {
          context.read<ProfileCubit>().consumeSignOutState();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
          return;
        }
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(
            child: CircularProgressIndicator(color: ColorsManager.gold),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return Center(
            child: TextButton(
              onPressed: context.read<ProfileCubit>().loadProfile,
              child: const Text('Retry'),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 26.h, 24.w, 12.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ProfileAvatar(avatarId: profile.avatarId, size: 94.r),
                          SizedBox(height: 7.h),
                          SizedBox(
                            width: 116.w,
                            child: Text(
                              profile.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: _ProfileCount(
                          count: profile.wishlistMovies.length,
                          label: 'Wish List',
                        ),
                      ),
                      Expanded(
                        child: _ProfileCount(
                          count: profile.historyMovies.length,
                          label: 'History',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 17.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 49.h,
                          child: PrimaryAppButton(
                            text: 'Edit Profile',
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const UpdateProfileScreen(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          height: 49.h,
                          child: state.isSigningOut
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorsManager.gold,
                                  ),
                                )
                              : SecondaryAppButton(
                                  text: 'Exit',
                                  suffixIcon: const Icon(
                                    Icons.logout,
                                    size: 19,
                                  ),
                                  onPressed: context
                                      .read<ProfileCubit>()
                                      .signOut,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: ColorsManager.grey.withValues(alpha: 0.56),
              child: TabBar(
                controller: _tabController,
                labelColor: ColorsManager.white,
                unselectedLabelColor: ColorsManager.white,
                indicatorColor: ColorsManager.gold,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                tabs: const [
                  _ProfileTab(
                    icon: Icons.format_list_bulleted,
                    label: 'Wish List',
                  ),
                  _ProfileTab(icon: Icons.folder, label: 'History'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 76.h),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ProfileMovieList(movies: profile.wishlistMovies),
                    ProfileMovieList(movies: profile.historyMovies),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileCount extends StatelessWidget {
  const _ProfileCount({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontSize: 24.sp),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 63.h,
      child: MediaQuery.withNoTextScaling(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ColorsManager.gold, size: 22.r),
            SizedBox(height: 2.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
