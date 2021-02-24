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
                  return GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    child: CustomPaint(
                      painter: MyPainter(degree: degree),
                    ),
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

class MyPainter extends CustomPainter {
  final double degree;
  MyPainter({this.degree});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(radius, radius);

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.transparent;
    canvas.drawCircle(Offset(0, 0), radius, paint);

    final angles = [30, 60, 90, 30, 40, 20, 90];
    final colors = [
      Colors.blue,
      Colors.yellow,
      Colors.red,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
      Colors.black
    ];

    canvas.rotate((degree * 2 * pi) / 360);

    for (int index = 0; index < angles.length; index++) {
      final angle = (angles[index] * 2 * pi) / 360;

      Paint paint1 = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[index];

      canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: radius), 0,
          angle, true, paint1);
      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
