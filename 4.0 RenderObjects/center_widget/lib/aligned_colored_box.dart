import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AlignedColoredBox extends SingleChildRenderObjectWidget {
  final Color color;
  final Alignment alignment;
  AlignedColoredBox({Key key, this.color, this.alignment, Widget child})
      : super(key: key, child: child);

  @override
  RenderAlignedColoredBox createRenderObject(BuildContext context) {
    return RenderAlignedColoredBox(alignment: alignment, color: color);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderAlignedColoredBox renderObject) {
    renderObject
      ..alignment = alignment
      ..color = color;
  }
}

class RenderAlignedColoredBox extends RenderProxyBox {
  RenderAlignedColoredBox({Alignment alignment, Color color, RenderBox child})
      : assert(alignment != null),
        assert(color != null),
        _alignment = alignment,
        _color = color,
        super(child);

  Color _color;
  Color get color => _color;

  set color(Color value) {
    assert(value != null);
    if (color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Alignment _alignment;
  Alignment get alignment => _alignment;

  set alignment(Alignment value) {
    assert(value != null);
    if (alignment == value) return;
    _alignment = value;
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoxParentData) child.parentData = BoxParentData();
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    if (child != null) {
      child.layout(constraints.loosen(), parentUsesSize: true);
      final childParentData = child.parentData as BoxParentData;

      childParentData.offset =
          alignment.alongOffset(size - child.size as Offset);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(offset & size, Paint()..color = color);
    if (child != null) {
      final childParentData = child.parentData as BoxParentData;
      context.paintChild(child, childParentData.offset + offset);
    }
  }
}
