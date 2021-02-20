import 'package:flutter/material.dart';
import 'dart:math';

class SpeedIndicatorPainter extends CustomPainter {
  double speed;
  SpeedIndicatorPainter({this.speed});

  @override
  void paint(Canvas canvas, Size size) {
    final calibratedSpeed = (53 / 100) * speed;

    final radius = size.width / 2.0;
    final angle = (2 * pi * (3 / 4)) / 53;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(-pi * (3 / 4));

    final width = ((size.width * (3 / 4)) / 25);

    for (int i = 0; i < 53; i++) {
      paint.color = Color.lerp(Colors.yellow, Colors.red, (i / 53));

      if (i > calibratedSpeed.toInt()) {
        paint.style = PaintingStyle.stroke;
        paint.color = Colors.white54;
      }

      canvas.drawRect(Rect.fromLTWH(0.0, -radius, width, width), paint);
      canvas.rotate(angle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
