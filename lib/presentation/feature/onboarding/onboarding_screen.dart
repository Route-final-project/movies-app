import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      image: 'assets/images/Movies_Posters.png',
      title: 'Find Your Next\nFavorite Movie Here',
      description:
          'Get access to a huge library of movies\nto suit all tastes. You will surely like it.',
      primaryButtonText: 'Explore Now',
      cardTopRadius: 0,
      showBack: false,
    ),
    _OnboardingPageData(
      image: 'assets/images/avengers.jpg',
      tintColor: Color(0x99004B5A),
      title: 'Discover Movies',
      description:
          'Explore a vast collection of movies in all\nqualities and genres. Find your next\nfavorite film with ease.',
    ),
    _OnboardingPageData(
      image: 'assets/images/Oppenheimer.jpg',
      tintColor: Color(0x66A82410),
      title: 'Explore All Genres',
      description:
          'Discover movies from every genre, in all\navailable qualities. Find something new\nand exciting to watch every day.',
    ),
    _OnboardingPageData(
      image: 'assets/images/bad_boys.jpg',
      tintColor: Color(0x9951219C),
      title: 'Create Watchlists',
      description:
          'Save movies to your watchlist to keep\ntrack of what you want to watch next.\nEnjoy films in various qualities and\ngenres.',
    ),
    _OnboardingPageData(
      image: 'assets/images/doctor_strange.jpg',
      tintColor: Color(0x887F0E22),
      title: 'Rate, Review, and Learn',
      description:
          'Share your thoughts on the movies\nyou\'ve watched. Dive deep into film\ndetails and help others discover great\nmovies with your reviews.',
    ),
    _OnboardingPageData(
      image: 'assets/images/1917.jpg',
      tintColor: Color(0x88202528),
      title: 'Start Watching Now',
      description: '',
      primaryButtonText: 'Finish',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_pageIndex == _pages.length - 1) return;

    _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.black,
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _pageIndex = index),
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _OnboardingPage(
            data: _pages[index],
            onNext: _goNext,
            onBack: _goBack,
          );
        },
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  final _OnboardingPageData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final unit = size.width / 430;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(data.image, fit: BoxFit.cover, alignment: Alignment.center),
        if (data.tintColor != null) ColoredBox(color: data.tintColor!),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0x22000000), Color(0xAA000000)],
              stops: [0.35, 0.66, 1],
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                37 * unit,
                21 * unit,
                37 * unit,
                34 * unit,
              ),
              decoration: BoxDecoration(
                color: _AppColors.black,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(data.cardTopRadius * unit),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24 * unit,
                      height: 1.18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (data.description.isNotEmpty) ...[
                    SizedBox(height: 15 * unit),
                    Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 14 * unit,
                        height: 1.25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  SizedBox(height: 21 * unit),
                  _OnboardingButton(
                    text: data.primaryButtonText,
                    onPressed: onNext,
                    filled: true,
                    unit: unit,
                  ),
                  if (data.showBack) ...[
                    SizedBox(height: 12 * unit),
                    _OnboardingButton(
                      text: 'Back',
                      onPressed: onBack,
                      filled: false,
                      unit: unit,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton({
    required this.text,
    required this.onPressed,
    required this.filled,
    required this.unit,
  });

  final String text;
  final VoidCallback onPressed;
  final bool filled;
  final double unit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55 * unit,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? _AppColors.gold : _AppColors.black,
          foregroundColor: filled ? _AppColors.black : _AppColors.gold,
          side: const BorderSide(color: _AppColors.gold, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15 * unit),
          ),
          textStyle: TextStyle(
            fontSize: 16 * unit,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
    this.primaryButtonText = 'Next',
    this.tintColor,
    this.cardTopRadius = 24,
    this.showBack = true,
  });

  final String image;
  final String title;
  final String description;
  final String primaryButtonText;
  final Color? tintColor;
  final double cardTopRadius;
  final bool showBack;
}

abstract class _AppColors {
  static const Color black = Color(0xFF121312);
  static const Color gold = Color(0xFFF6BD00);
}
