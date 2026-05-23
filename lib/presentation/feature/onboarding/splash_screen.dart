import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _black = Color(0xFF121312);
  static const _gold = Color(0xFFF6BD00);
  static const _routeLogo = 'assets/images/route_logo.png';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final unit = constraints.maxWidth / 430;
            final height = constraints.maxHeight;

            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: height * 0.33,
                  child: CustomPaint(
                    size: Size.square(92 * unit),
                    painter: const _RoutePlayPainter(),
                  ),
                ),
                Positioned(
                  top: height * 0.675,
                  child: Column(
                    children: [
                      Image.asset(
                        _routeLogo,
                        width: 88 * unit,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 8 * unit),
                      Text(
                        'Supervised by Mohamed Nabil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12 * unit,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RoutePlayPainter extends CustomPainter {
  const _RoutePlayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = _SplashScreenState._gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025;

    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.5),
      size.width * 0.42,
      circlePaint,
    );

    final playPath = Path()
      ..moveTo(size.width * 0.16, size.height * 0.22)
      ..lineTo(size.width * 0.16, size.height * 0.78)
      ..lineTo(size.width * 0.64, size.height * 0.50)
      ..close();

    final fillPaint = Paint()
      ..color = _SplashScreenState._black
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = _SplashScreenState._gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(playPath, fillPaint);
    canvas.drawPath(playPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
