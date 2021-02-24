import 'package:flutter/material.dart';
import 'dart:math';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: ScaleWheel())),
    );
  }
}

class ScaleWheel extends StatefulWidget {
  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<ScaleWheel>
    with SingleTickerProviderStateMixin {
  double wheelSize;
  final double longNeedleHeight = 40;
  final double shortNeedleHeight = 25;
  final double conversionRate = 2.20462;
  double degree = 0;
  double radius;
  AnimationController ctrl;
  String unit = " Kg";
  int unitIndex = 0;

  @override
  void initState() {
    super.initState();
    wheelSize = 500;
    radius = wheelSize / 2;
    ctrl = AnimationController.unbounded(vsync: this);
    degree = 0;
    ctrl.value = degree;
  }

  double degreeToRadians(double degrees) => degrees * (pi / 180);

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double roundToBase(double number, int base) {
    double reminder = number % base;
    double result = number;
    if (reminder < (base / 2)) {
      result = number - reminder;
    } else {
      result = number + (base - reminder);
    }

    return result;
  }

  _panUpdateHandler(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absolute change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;

    double _value = degree + (rotationalChange / 5);

    setState(() {
      degree = _value > 0 ? _value : 0;
      ctrl.value = degree;
    });
  }

  _panEndHandler(DragEndDetails d) {
    ctrl
        .animateTo(roundToBase(degree.roundToDouble(), 10),
            duration: Duration(milliseconds: 551), curve: Curves.easeOutBack)
        .whenComplete(() {
      setState(() {
        degree = roundToBase(degree.roundToDouble(), 10);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WheelCircle wheelCircle = WheelCircle(
        wheelSize: wheelSize,
        longNeedleHeight: longNeedleHeight,
        shortNeedleHeight: shortNeedleHeight,
        context: context);

    SizedBox wheelContainer = SizedBox(
      width: wheelSize,
      height: wheelSize,
      child: Container(
          color: Colors.transparent,
          // If scale doesnt respond to pan, change transparent to red an check.
          child: Center(child: CustomPaint(painter: wheelCircle))),
    );

    GestureDetector draggableWheel = GestureDetector(
      onPanUpdate: _panUpdateHandler,
      onPanEnd: _panEndHandler,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: ctrl,
            builder: (ctx, w) {
              return Transform.rotate(
                angle: degreeToRadians(ctrl.value),
                child: wheelContainer,
              );
            },
          ),
          Container(
            width: wheelSize,
            height: wheelSize / 2,
            margin: const EdgeInsets.only(top: 30),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: this.longNeedleHeight + 10),
                child: Image(
                  image: NetworkImage(
                      'https://d20nqim3b55fln.cloudfront.net/images/ic_needle_light.png'),
                ),
              ),
            ),
          ),
          Container(
            width: wheelSize,
            height: wheelSize,
            child: CustomPaint(
              painter: WheelDecoration(context),
            ),
          ),
        ],
      ),
    );

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text((degree / 20).toStringAsFixed(2),
                    style: TextStyle(fontSize: 40, fontFamily: 'Roboto')),
                Text(unit)
              ],
            ),
          ),
          draggableWheel
        ],
      ),
    );
  }
}

class WheelCircle extends CustomPainter {
  double wheelSize;
  double longNeedleHeight;
  double shortNeedleHeight;
  double radius;
  BuildContext context;

  WheelCircle(
      {this.wheelSize,
      this.longNeedleHeight,
      this.shortNeedleHeight,
      @required this.context}) {
    radius = wheelSize / 2;
  }

  double degreeToRadians(double degrees) => degrees * (pi / 180);

  double radianToDegrees(double radians) => radians * (180 / pi);

  @override
  void paint(Canvas canvas, Size size) {
    // final wheelBorder = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2.0
    //   ..color = Theme.of(context).textTheme.bodyText2.color;

    final shortNeedle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white;

    final longNeedle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white;

    // canvas.drawCircle(Offset(0, 0), wheelSize / 2, wheelBorder);
    // canvas.drawLine(Offset(0, -50), Offset(0, 0),
    //     wheelBorder); // <- this line is drawn just to help debug the angle. Comment this in prod.

    for (double i = 0; i <= 360; i++) {
      if (i % 20 != 0 && i % 10 == 0) {
        canvas.drawLine(
            Offset(radius * cos(degreeToRadians(i)),
                radius * sin(degreeToRadians(i))),
            Offset((radius - longNeedleHeight) * cos(degreeToRadians(i)),
                (radius - longNeedleHeight) * sin(degreeToRadians(i))),
            longNeedle);
      } else {
        if (i % 5 == 0) {
          canvas.drawLine(
              Offset(radius * cos(degreeToRadians(i)),
                  radius * sin(degreeToRadians(i))),
              Offset((radius - shortNeedleHeight) * cos(degreeToRadians(i)),
                  (radius - shortNeedleHeight) * sin(degreeToRadians(i))),
              shortNeedle);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WheelDecoration extends CustomPainter {
  BuildContext context;
  final indicator = Paint()
    ..color = Color(0xFF007CFA)
    ..strokeWidth = 2;

  Color gradientPatchColor;

  WheelDecoration(this.context) {
    gradientPatchColor = Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width * .5, -10), 5, indicator);
    canvas.drawLine(
        Offset(size.width * .5, -10), Offset(size.width * .5, 40), indicator);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
