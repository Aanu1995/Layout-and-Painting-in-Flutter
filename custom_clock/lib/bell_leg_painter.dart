import 'package:flutter/material.dart';
import 'dart:math';

class BellAndLegPainter extends CustomPainter {
  const BellAndLegPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;

    canvas.save();

    canvas.translate(radius, radius);

    final legPaint = Paint()
      ..color = const Color(0xFF555555)
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(-80, -radius - 10);
    path.lineTo(-70, -radius - 50);
    path.lineTo(70, -radius - 50);
    path.lineTo(80, -radius - 10);

    canvas.drawPath(path, legPaint);

    canvas.rotate(pi / 6);
    customDrawPath(radius, canvas);

    canvas.rotate(-pi / 3);
    customDrawPath(radius, canvas);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void customDrawPath(double radius, Canvas canvas) {
    final legPaint = Paint()
      ..color = const Color(0xFF555555)
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bellPaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0.0, -radius - 50);
    path.lineTo(0.0, radius + 20);
    path.addOval(
        Rect.fromCircle(center: Offset(0.0, -radius - 50), radius: 3.0));

    Path path2 = new Path();
    path2.moveTo(-55.0, -radius - 5);
    path2.lineTo(55.0, -radius - 5);
    path2.quadraticBezierTo(0.0, -radius - 75, -55.0, -radius - 10);

    canvas.drawPath(path, legPaint);
    canvas.drawPath(path2, bellPaint);
  }
}
