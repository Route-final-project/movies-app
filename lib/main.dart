import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/resource/routes_manager.dart';
import 'package:movies/dependency_injection/di.dart';
import 'package:movies/firebase_options.dart';
import 'package:movies/presentation/feature/auth/login_screen.dart';
import 'package:movies/presentation/feature/onboarding/onboarding_screen.dart';
import 'package:movies/presentation/mainAppScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/resource/app_preferences_keys.dart';
import 'config/theme/theme_manager.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final preferences = await SharedPreferences.getInstance();
  configureDependencies();
  runApp(
    MoviesApp(
      hasSeenOnboarding:
          preferences.getBool(AppPreferencesKeys.hasSeenOnboarding) ?? false,
    ),
  );
  FlutterNativeSplash.remove();
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({required this.hasSeenOnboarding, super.key});

  final bool hasSeenOnboarding;

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
          initialRoute: _getStartScreenRoute(),
          routes: RoutesManger.routes,
        );
      },
    );
  }

  String _getStartScreenRoute() {
    if (!hasSeenOnboarding) {
      return RoutesManger.onboarding;
    }
    if (FirebaseAuth.instance.currentUser != null) {
      return RoutesManger.mainAppScreenRoute;
    }
    return RoutesManger.loginScreen;
  }
}
