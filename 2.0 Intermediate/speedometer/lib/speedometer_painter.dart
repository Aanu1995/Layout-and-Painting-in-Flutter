import 'package:flutter/material.dart';
import 'dart:math';

class SpeedometerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw outside circle
    drawOutsideCircle(canvas, size);

    // draw inner circle
    drawInnerCircle(canvas, size);

    // draw Markers
    drawMarkers(canvas, size);

    drawNeedleHolder(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawOutsideCircle(Canvas canvas, Size size) {
    final outsideCirclePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2, outsideCirclePaint);
  }

  void drawInnerCircle(Canvas canvas, Size size) {
    final innerCirclePaint = Paint()
      ..color = Colors.red.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
        size.center(Offset.zero), size.width / 4, innerCirclePaint);
  }

  void drawMarkers(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final bigTickerLength = 20.0;
    final smallTickerLength = 10.0;
    final angle = (2 * pi * (3 / 4)) / 70;

    final paint = Paint()
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..color = Colors.red;

    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    final style = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );

    canvas.save();
    canvas.translate(radius, radius);
    canvas.rotate(-pi * (3 / 4));

    for (int i = 0; i <= 70; i++) {
      double tickerLength = i % 10 == 0 ? bigTickerLength : smallTickerLength;
      paint.strokeWidth = i % 10 == 0 ? 4.0 : 2.0;

      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius + tickerLength), paint);

      if (i % 10 == 0) {
        canvas.save();
        canvas.translate(0.0, -radius + 40);
        textPainter.text = TextSpan(text: "$i", style: style);

        canvas.rotate(pi * (3 / 4));
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

  void drawNeedleHolder(Canvas canvas, Size size) {
    RadialGradient gradient = RadialGradient(
      colors: [Colors.orange, Colors.red, Colors.red, Colors.black],
      radius: 1.2,
      stops: [0.0, 0.7, 0.9, 1.0],
    );

    final paint = Paint()
      ..color = Colors.blueGrey
      ..shader = gradient.createShader(Rect.fromCenter(
          center: size.center(Offset.zero),
          width: size.width / 20,
          height: size.width / 20));

    canvas.drawCircle(size.center(Offset.zero), size.width / 15, paint);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 1.50);

    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    final style = TextStyle(
      fontSize: 30.0,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );

    textPainter.text = TextSpan(text: "47", style: style);
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(-(textPainter.width / 2), -(textPainter.height / 2.0)));

    canvas.restore();
  }
}
