import 'package:flutter/material.dart';
import 'dart:math';

class SecondHandPainter extends CustomPainter {
  int seconds;
  SecondHandPainter({this.seconds});

  Paint secondHandPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  Paint secondHandPointsPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * this.seconds / 60);

    Path path1 = new Path();
    Path path2 = new Path();
    path1.moveTo(0.0, -radius);
    path1.lineTo(0.0, radius / 4);

    path2.addOval(
        Rect.fromCircle(radius: 7.0, center: new Offset(0.0, -radius)));
    path2.addOval(Rect.fromCircle(radius: 5.0, center: new Offset(0.0, 0.0)));

    canvas.drawPath(path1, secondHandPaint);
    canvas.drawPath(path2, secondHandPointsPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SecondHandPainter oldDelegate) {
    return this.seconds != oldDelegate.seconds;
  }
}
