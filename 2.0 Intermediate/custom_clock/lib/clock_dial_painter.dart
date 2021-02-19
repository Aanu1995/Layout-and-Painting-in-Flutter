import 'package:flutter/material.dart';
import 'dart:math';

class ClockDialPainter extends CustomPainter {
  const ClockDialPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final hourTickMarkLength = 10.0;
    final minuteTickMarkLength = 5.0;

    final hourTickMarkWidth = 3.0;
    final minuteTickMarkWidth = 1.5;

    final tickPaint = Paint()..color = Colors.blueGrey;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textStyle = const TextStyle(
      color: Colors.black,
      fontFamily: 'Times New Roman',
      fontSize: 16.0,
    );

    var tickMarkLength;
    final angle = 2 * pi / 60;
    final radius = size.width / 2;

    canvas.save();

    canvas.translate(radius, radius);

    for (int i = 0; i < 60; i++) {
      tickMarkLength = i % 5 == 0 ? hourTickMarkLength : minuteTickMarkLength;
      tickPaint.strokeWidth =
          i % 5 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;

      canvas.drawLine(Offset(0.0, -radius),
          Offset(0.0, -radius + tickMarkLength), tickPaint);

      if (i % 5 == 0) {
        canvas.save();
        canvas.translate(0.0, -radius + 22.0);
        textPainter.text = new TextSpan(
          text: '${i == 0 ? 12 : i ~/ 5}',
          style: textStyle,
        );

        //helps make the text painted vertically
        canvas.rotate(-angle * i);

        textPainter.layout();

        textPainter.paint(canvas,
            Offset(-(textPainter.width / 2), -(textPainter.height / 2)));

        canvas.restore();
      }

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
