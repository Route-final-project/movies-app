import 'package:flutter/cupertino.dart';
import 'package:movies/config/path_argument.dart';
import 'package:movies/domain/entity/movie_entity.dart';
import 'package:movies/presentation/feature/auth/forget_password_screen.dart';
import 'package:movies/presentation/feature/auth/login_screen.dart';
import 'package:movies/presentation/feature/auth/register_screen.dart';
import 'package:movies/presentation/feature/home/homeScreen.dart';
import 'package:movies/presentation/mainAppScreen.dart';

import '../../presentation/feature/movie_detail/movieDetailScreen.dart';
import '../../presentation/feature/onboarding/onboarding_screen.dart';

abstract class RoutesManger {
  static const String homeScreen = '/homeScreen';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String movieDetailScreen = '/movieDetailScreen';
  static const String mainAppScreenRoute = "/mainAppScreenRoute";
  static const String onboarding = "/onboarding";

  static Map<String, WidgetBuilder> routes = {
    onboarding: (_) => const OnboardingScreen(),
    homeScreen: (_) => HomeScreen(),
    loginScreen: (_) => const LoginScreen(),
    registerScreen: (_) => const RegisterScreen(),
    forgetPasswordScreen: (_) => const ForgetPasswordScreen(),
    mainAppScreenRoute : (_) => const MainAppScreen(),
    movieDetailScreen: (context) {
      Map<String, dynamic> argument = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return MovieDetailScreen(movieId: argument[PathArguments.movieId]);
    }
  };
}