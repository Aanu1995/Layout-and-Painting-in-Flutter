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
      home: Speedometer(),
    );
  }
}

class Speedometer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Speedometer"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: SpeedIndicatorPainter(),
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: CustomPaint(
                      painter: SpeedometerPainter(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
