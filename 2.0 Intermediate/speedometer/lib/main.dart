import 'package:flutter/material.dart';

import 'speed_indicator_painter.dart';
import 'speedometer_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedometer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: Text("Speedometer")),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Speedometer(),
        ),
      ),
    );
  }
}

class Speedometer extends StatelessWidget {
  final speed = 75.0; // current speed in percentage
  final highestSpeed = 90.0; // highest speed from speed record

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: SpeedIndicatorPainter(speed: speed)),
              Container(
                margin: EdgeInsets.all(constraints.maxWidth * 0.037),
                child: CustomPaint(
                  painter: SpeedometerPainter(
                    speed: speed,
                    highestSpeed: highestSpeed,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
