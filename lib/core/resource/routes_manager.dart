import 'package:flutter/cupertino.dart';
import 'package:movies/presentation/feature/home/homeScreen.dart';

abstract class RoutesManger{
  static const String homeScreen = '/homeScreen';

  static Map<String, WidgetBuilder> routes = {
    homeScreen : (_)=> HomeScreen(),
  };
}