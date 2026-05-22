import 'dart:math';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFFFFC107);
    final w = size.width;
    final h = size.height;

    final cx = w * 0.54;
    final cy = h * 0.50;
    final outerR = w * 0.44;
    final innerR = w * 0.34;

    final barLeft = w * 0.03;
    final barRight = cx - innerR; // tangent to inner circle
    final capR = (barRight - barLeft) / 2;

    // Where bar right edge meets outer circle (top & bottom)
    final jDy = sqrt(outerR * outerR - (cx - barRight) * (cx - barRight));
    final jTop = cy - jDy;
    final jBot = cy + jDy;

    canvas.saveLayer(Rect.fromLTWH(0, 0, w, h), Paint());

    // ── Draw D-ring shape as compound path with evenOdd ──
    final path = Path()..fillType = PathFillType.evenOdd;

    // Outer D boundary (one continuous closed loop):
    path.moveTo(barRight, jTop);

    // 1) Bar top cap: semicircle going UP from right→left
    path.arcToPoint(
      Offset(barLeft, jTop),
      radius: Radius.circular(capR),
      clockwise: false,
      largeArc: false,
    );

    // 2) Left side of bar going DOWN
    path.lineTo(barLeft, jBot);

    // 3) Bar bottom cap: semicircle going DOWN from left→right
    path.arcToPoint(
      Offset(barRight, jBot),
      radius: Radius.circular(capR),
      clockwise: true,
      largeArc: false,
    );

    // 4) Outer circle arc: clockwise from bottom junction → right → top junction
    path.arcToPoint(
      Offset(barRight, jTop),
      radius: Radius.circular(outerR),
      clockwise: true,
      largeArc: true,
    );

    path.close();

    // Inner circle punches out the ring hollow (evenOdd creates the donut)
    path.addOval(Rect.fromCenter(
      center: Offset(cx, cy),
      width: innerR * 2,
      height: innerR * 2,
    ));

    canvas.drawPath(path, Paint()..color = color);

    // ── Cut play-button triangle with BlendMode.clear ──
    final playX = barLeft + (barRight - barLeft) * 0.52;
    final tipX = cx + outerR * 0.42;
    final pTop = cy - outerR * 0.60;
    final pBot = cy + outerR * 0.60;

    canvas.drawPath(
      Path()
        ..moveTo(playX, pTop)
        ..lineTo(tipX, cy)
        ..lineTo(playX, pBot)
        ..close(),
      Paint()
        ..blendMode = BlendMode.clear
        ..color = Colors.transparent,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
