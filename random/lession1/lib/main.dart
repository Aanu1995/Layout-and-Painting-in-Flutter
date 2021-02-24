import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  double degree = 0;
  double radius = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  radius = constraints.maxWidth / 2;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(painter: MyPainter1(degree: degree)),
                      GestureDetector(
                        onPanUpdate: _onPanUpdate,
                        child: CustomPaint(
                          painter: MyPainter(degree: degree),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(50.0),
                        child: AbsorbPointer(
                          child: CustomPaint(
                            painter: MyPainter2(degree: degree),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onPanUpdate(DragUpdateDetails drag) {
    /// Pan location on the wheel
    bool onTop = drag.localPosition.dy <= radius;
    bool onLeftSide = drag.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = drag.delta.dy <= 0.0;
    bool panLeft = drag.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absolute change on axis
    double yChange = drag.delta.dy.abs();
    double xChange = drag.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

// Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;
    // double _value = degree + rotationalChange; // correct value to use

    // use to slow down 5 times when pan
    double _value = degree + (rotationalChange / 5);
    print(degree);
    setState(() {
      // convert to degree of rotation
      degree = _value % 360;
    });
  }
}

class MyPainter1 extends CustomPainter {
  final double degree;
  MyPainter1({this.degree});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();
    canvas.translate(radius, radius);

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;

    // The two green lines
    canvas.drawCircle(Offset(0, 0), radius, paint);
    canvas.drawCircle(Offset(0, 0), radius - 50, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyPainter extends CustomPainter {
  final double degree;
  MyPainter({this.degree});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(radius, radius);
    final angle = (degree * 2 * pi) / 360;

    canvas.rotate(-pi / 2);

    Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green;
    canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: radius), 0,
        angle, true, paint2);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyPainter2 extends CustomPainter {
  final double degree;
  MyPainter2({this.degree});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(radius, radius);

    Paint paint3 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    canvas.drawCircle(Offset(0, 0), radius - 2, paint3);

    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    final style = TextStyle(
      fontSize: 40.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    );

    final degreeToPercent = (degree * 100) / 360;
    textPainter.text =
        TextSpan(text: "${degreeToPercent.toStringAsFixed(0)}%", style: style);
    textPainter.layout();

    textPainter.paint(canvas,
        Offset(-(textPainter.width / 2.0), -(textPainter.height / 2.0)));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
