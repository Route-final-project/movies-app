import 'package:flutter/cupertino.dart';
import 'package:movies/presentation/feature/auth/forget_password_screen.dart';
import 'package:movies/presentation/feature/auth/login_screen.dart';
import 'package:movies/presentation/feature/auth/register_screen.dart';
import 'package:movies/presentation/feature/home/homeScreen.dart';

abstract class RoutesManger {
  static const String homeScreen = '/homeScreen';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String forgetPasswordScreen = '/forgetPasswordScreen';

  static Map<String, WidgetBuilder> routes = {
    homeScreen: (_) => HomeScreen(),
    loginScreen: (_) => const LoginScreen(),
    registerScreen: (_) => const RegisterScreen(),
    forgetPasswordScreen: (_) => const ForgetPasswordScreen(),
  };
}