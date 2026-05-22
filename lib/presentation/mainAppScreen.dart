import 'package:flutter/material.dart';
import 'package:movies/presentation/feature/home/homeScreen.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: HomeScreen()));
  }
}
