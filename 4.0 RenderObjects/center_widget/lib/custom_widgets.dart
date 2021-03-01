import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// class CustomCenter extends SingleChildRenderObjectWidget {
//   const CustomCenter({Key key, Widget child}) : super(key: key, child: child);

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderPositionedBox(alignment: Alignment.center);
//   }
// }

class CustomCenter extends CustomAlign {
  const CustomCenter(
      {Key key, Widget child, double widthFactor, double heightFactor})
      : super(
          key: key,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: child,
        );
}

class CustomAlign extends SingleChildRenderObjectWidget {
  final AlignmentGeometry alignment;
  final double widthFactor;
  final double heightFactor;
  const CustomAlign({
    Key key,
    this.alignment = Alignment.center,
    this.heightFactor,
    this.widthFactor,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPositionedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderPositionedBox renderObject) {
    renderObject
      ..heightFactor = heightFactor
      ..widthFactor = widthFactor
      ..alignment = alignment
      ..textDirection = Directionality.of(context);
  }
}

class CustomPadding extends SingleChildRenderObjectWidget {
  final EdgeInsets padding;
  const CustomPadding({Key key, this.padding = EdgeInsets.zero, Widget child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPadding(
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderPadding renderObject) {
    renderObject
      ..padding = padding
      ..textDirection = Directionality.of(context);
  }
}
