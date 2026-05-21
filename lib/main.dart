import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/dependency_injection/di.dart';
import 'package:movies/presentation/mainAppScreen.dart';

import 'config/theme/theme_manager.dart';

void main() {
  configureDependencies();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Movies App',
          debugShowCheckedModeBanner: false,
          theme: ThemeManager.appTheme,
          home: const MainAppScreen(),
        );
      },
    );
  }
}
