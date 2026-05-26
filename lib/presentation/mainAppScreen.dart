import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/presentation/feature/home/homeScreen.dart';

import '../core/resource/colors_manager.dart';
import 'feature/browse/browseScreen.dart';
import 'feature/profile/profileScreen.dart';
import 'feature/search/searchScreen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  Key _profileKey = UniqueKey();
  late final Widget _homeScreen = const HomeScreen();
  late final Widget _searchScreen = const SearchScreen();
  late final Widget _browseScreen = const BrowseScreen();

  List<Widget> get _screens => [
    _homeScreen,
    _searchScreen,
    _browseScreen,
    ProfileScreen(key: _profileKey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBottomNavigationBar(
          currentIndex: _currentIndex,
          onDestinationSelected: (index) {
            FocusScope.of(context).unfocus();
            setState(() {
              if (index == 3) {
                _profileKey = UniqueKey();
              }
              _currentIndex = index;
            });
          },
        ),
      ),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
    );
  }
}

@immutable
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final Function(int) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    List<NavigationDestination> items = [
      NavigationDestination(
        icon: SvgPicture.asset(
          "assets/icons/home_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
        ),
        selectedIcon: SvgPicture.asset(
          "assets/icons/home_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.gold, BlendMode.srcIn),
        ),
        label: "home",
      ),
      NavigationDestination(
        icon: SvgPicture.asset(
          "assets/icons/search_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
        ),
        selectedIcon: SvgPicture.asset(
          "assets/icons/search_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.gold, BlendMode.srcIn),
        ),
        label: "search",
      ),
      NavigationDestination(
        icon: SvgPicture.asset(
          "assets/icons/browse_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
        ),
        selectedIcon: SvgPicture.asset(
          "assets/icons/browse_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.gold, BlendMode.srcIn),
        ),
        label: "browse",
      ),

      NavigationDestination(
        icon: SvgPicture.asset(
          "assets/icons/profile_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),
        ),
        selectedIcon: SvgPicture.asset(
          "assets/icons/profile_icon.svg",
          colorFilter: ColorFilter.mode(ColorsManager.gold, BlendMode.srcIn),
        ),
        label: "profile",
      ),
    ];

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.transparent),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          onDestinationSelected(index);
        },
        height: 61.h,
        destinations: items,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}
