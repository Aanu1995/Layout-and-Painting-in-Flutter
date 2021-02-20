import 'package:flutter/material.dart';
import 'dart:math';

class SpeedometerPainter extends CustomPainter {
  double speed;
  double highestSpeed;

  SpeedometerPainter({this.speed, this.highestSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    // convert current speed in percentage to show the corresponding speed
    // based on the speedometer calibration
    // draw outside circle
    final calibratedSpeed = (7 / 10) * speed;
    final calibratedSpeedRecord = (7 / 10) * highestSpeed;

    drawOutsideCircle(canvas, size);

    // draw inner circle
    drawInnerCircle(canvas, size);

    // draw Markers
    drawMarkers(canvas, size);

    // draw the needle holder;
    drawNeedleHolder(canvas, size, calibratedSpeed);

    drawNeedle(canvas, size, calibratedSpeed);

    drawGhostNeedle(canvas, size, calibratedSpeedRecord);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawOutsideCircle(Canvas canvas, Size size) {
    final radius = size.width / 2.0;

    final outsideCirclePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = size.width * 0.01
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), radius, outsideCirclePaint);
  }

  void drawInnerCircle(Canvas canvas, Size size) {
    final radius = size.width / 4.0;

    final innerCirclePaint = Paint()
      ..color = Colors.red.withOpacity(0.4)
      ..strokeWidth = size.width * 0.005
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), radius, innerCirclePaint);
  }

  void drawMarkers(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final bigNeedleLength = size.width * 0.055;
    final smallNeedleLength = size.width * 0.025;
    // since the needle does not cover the entire circle, the total angle cover
    // is 270 degress. each needle angle difference from the next one is
    // 270 / 70 degree. Please note that angle should be in radian and therefore
    // 270 is converted to randian
    final angle = ((3 / 2) * pi) / 70;

    final paint = Paint()
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..color = Colors.red;

    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    final style = TextStyle(
      fontSize: size.width * 0.05,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );

    canvas.save();
    // translate to center to start painting using the center point as origin
    canvas.translate(radius, radius);
    // rotate the canvas to start at the correct angle which is 135 degree
    // anticlockwise. The negative sign means we are rotating anticlockwise since
    // rotation is clockwise.
    canvas.rotate(-pi * (3 / 4));

    // draw the 70 needles

    for (int i = 0; i <= 70; i++) {
      double tickerLength = i % 10 == 0 ? bigNeedleLength : smallNeedleLength;
      paint.strokeWidth =
          i % 10 == 0 ? size.width * 0.0115 : size.width * 0.0055;

      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius + tickerLength), paint);

      if (i % 10 == 0) {
        canvas.save();

        canvas.translate(0.0, -radius * 0.78);
        textPainter.text = TextSpan(text: "$i", style: style);

        // required to make the text vertical by first taking it to 0 degree
        // that is doing the opposite of all the canvas we have rotated
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

  void drawNeedleHolder(Canvas canvas, Size size, double speed) {
    RadialGradient gradient = RadialGradient(
      colors: [Colors.orange, Colors.red, Colors.red, Colors.black],
      radius: 1.2,
      stops: [0.0, 0.7, 0.9, 1.0],
    );

    final radius = size.width / 20;
    final paint = Paint()
      ..color = Colors.blueGrey
      ..shader = gradient.createShader(Rect.fromCenter(
          center: size.center(Offset.zero), width: radius, height: radius));

    canvas.drawCircle(size.center(Offset.zero), size.width / 15, paint);

    canvas.save();
    // Translate the canvas position to center (size.width / 2) in X direction
    // and to (size.height  * (2/3)) in Y direction
    canvas.translate(size.width / 2, size.height / 1.50);

    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    final style = TextStyle(
      fontSize: size.width * 0.08,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );

    textPainter.text =
        TextSpan(text: "${speed.toStringAsFixed(0)}", style: style);
    textPainter.layout();

    // The essence of specifying the value below is to center the text
    final offset =
        Offset(-(textPainter.width / 2.0), -(textPainter.height / 2.0));
    textPainter.paint(canvas, offset);

    canvas.restore();
  }

  void drawNeedle(Canvas canvas, Size size, double speed) {
    canvas.save();

    final angle = ((3 / 2) * pi) / 70;
    final radius = size.width / 2;
    final speedPaint = Paint()..color = Colors.red;

    canvas.translate(radius, radius);
    canvas.rotate(-pi * (3 / 4));

    Path path = Path();

    path.moveTo(0.0, -radius + 10);
    path.lineTo(-size.width * 0.0145, -radius * 0.125);
    path.quadraticBezierTo(
        0.0, -radius * 0.14, size.width * 0.0145, -radius * 0.125);
    path.close();

    canvas.rotate(angle * speed.toInt());
    canvas.drawPath(path, speedPaint);

    canvas.restore();
  }

  void drawGhostNeedle(Canvas canvas, Size size, double speed) {
    canvas.save();

    final angle = ((3 / 2) * pi) / 70;
    final radius = size.width / 2;
    final speedPaint = Paint()..color = Colors.grey;

    canvas.translate(radius, radius);
    canvas.rotate(-pi * (3 / 4));

    Path path = Path();
    path.moveTo(0.0, -radius + 10);
    print(size.width * 0.0088);
    path.lineTo(-size.width * 0.0088, -radius * 0.125);
    path.quadraticBezierTo(
        0.0, -radius * 0.135, size.width * 0.0088, -radius * 0.125);
    path.close();

    canvas.rotate(angle * speed.toInt());
    canvas.drawPath(path, speedPaint);

    canvas.restore();
  }
}
