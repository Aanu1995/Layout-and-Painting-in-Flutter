import 'package:flutter/material.dart';
import 'dart:math';

class HourHandPainter extends CustomPainter {
  int hours;
  int minutes;
  HourHandPainter({this.hours, this.minutes});

  Paint paint1 = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.save();

    canvas.translate(radius, radius);

    //checks if hour is greater than 12 before calculating rotation
    canvas.rotate(this.hours >= 12
        ? 2 * pi * ((this.hours - 12) / 12 + (this.minutes / 720))
        : 2 * pi * ((this.hours / 12) + (this.minutes / 720)));

    Path path = new Path();

    //heart shape head for the hour hand
    path.moveTo(0.0, -radius + 15.0);
    path.quadraticBezierTo(-3.5, -radius + 25.0, -15.0, -radius * 0.75);
    path.quadraticBezierTo(
        -20.0, -radius + radius / 3, -7.5, -radius + radius / 3);
    path.lineTo(0.0, -radius + radius / 4);
    path.lineTo(7.5, -radius + radius / 3);
    path.quadraticBezierTo(20.0, -radius + radius / 3, 15.0, -radius * 0.75);
    path.quadraticBezierTo(3.5, -radius + 25.0, 0.0, -radius + 15.0);

    //hour hand stem
    path.moveTo(-1.0, -radius * 0.75);
    path.lineTo(-5.0, -radius * 0.5);
    path.lineTo(-2.0, 0.0);
    path.lineTo(2.0, 0.0);
    path.lineTo(5.0, -radius * 0.5);
    path.lineTo(1.0, -radius * 0.75);
    path.close();

    canvas.drawPath(path, paint1);
    canvas.drawShadow(path, Colors.black, 2.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
