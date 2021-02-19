import 'dart:async';

import 'package:custom_clock/clock_dial_painter.dart';
import 'package:flutter/material.dart';

import 'bell_leg_painter.dart';
import 'hour_hand_painter.dart';
import 'minute_hand_painter.dart';
import 'seconds_hand_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Clock",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Clock"),
        ),
        body: Center(child: ClockFrame()),
      ),
    );
  }
}

class ClockFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: CustomPaint(
              painter: const BellAndLegPainter(),
              child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(offset: Offset(0.0, 5.0), blurRadius: 5.0)
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: new Container(
                            width: 15.0,
                            height: 15.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0.0, 5.0), blurRadius: 5.0)
                              ],
                            ),
                          ),
                        ),
                        const CustomPaint(
                          foregroundPainter: const ClockDialPainter(),
                        ),
                        // clock hands
                        ClockHands()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClockHands extends StatefulWidget {
  @override
  _ClockHandsState createState() => _ClockHandsState();
}

class _ClockHandsState extends State<ClockHands> {
  Timer _timer;
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();
    _timer = new Timer.periodic(const Duration(seconds: 1), setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: HourHandPainter(
            hours: dateTime.hour,
            minutes: dateTime.minute,
          ),
        ),
        CustomPaint(
          painter: MinuteHandPainter(
            seconds: dateTime.second,
            minutes: dateTime.minute,
          ),
        ),
        CustomPaint(
          painter: SecondHandPainter(
            seconds: dateTime.second,
          ),
        )
      ],
    );
  }
}
