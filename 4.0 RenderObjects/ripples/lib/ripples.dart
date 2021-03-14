import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class Ripples extends StatefulWidget {
  Ripples({Key key}) : super(key: key);

  @override
  _RipplesState createState() => _RipplesState();
}

class _RipplesState extends State<Ripples> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return RippleRender(vsync: this);
  }
}

class RippleRender extends LeafRenderObjectWidget {
  final TickerProvider vsync;
  RippleRender({@required this.vsync});

  @override
  RippleRenderBox createRenderObject(BuildContext context) {
    return RippleRenderBox(vsync: vsync);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RippleRenderBox renderObject) {
    renderObject..vsync = vsync;
  }
}

class RippleRenderBox extends RenderBox {
  RippleRenderBox({@required TickerProvider vsync}) : _vsync = vsync {
    colorSpectrum = [for (int i = 0; i < 360; i++) getColor(i.toDouble())];
  }

  List<Color> colorSpectrum = [];
  AnimationController controller;

  TickerProvider _vsync;

  set vsync(TickerProvider vsync) {
    assert(vsync != null);
    if (vsync == _vsync) {
      return;
    }
    _vsync = vsync;
    controller.resync(_vsync);
  }

  Color getColor(double value) {
    return HSLColor.fromAHSL(1.0, value, 1.0, 0.5).toColor();
  }

  Color color;
  int colorIndex = 0;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    controller = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 2000),
    )
      ..repeat()
      ..addListener(markNeedsPaint);
  }

  @override
  void detach() {
    controller.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    final defaultSize = constraints.biggest; // get size from parent constraints
    if (defaultSize.width < defaultSize.height) {
      size = Size(defaultSize.width, defaultSize.width);
    } else {
      size = Size(defaultSize.height, defaultSize.height);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    final rect = Offset.zero & size;

    for (int wave = 3; wave >= 0; wave--) {
      if (wave == 3) {
        if (colorIndex == 360) {
          colorIndex = 0;
        }
        color = colorSpectrum[colorIndex];
        colorIndex += 1;
      }
      circle(canvas, rect, wave + controller.value);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    final area = math.pow(rect.width / 2, 2);
    final radius = math.sqrt(area * value / 4);

    final opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final _color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, Paint()..color = _color);
  }
}
