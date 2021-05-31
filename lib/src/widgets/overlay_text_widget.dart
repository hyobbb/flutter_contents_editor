import 'package:flutter/material.dart';

class OverlayTextWidget extends StatelessWidget {
  final Size size;
  final BoxDecoration decoration;
  final String text;
  final TextStyle style;
  final TextAlign align;

  const OverlayTextWidget({
    required this.size,
    required this.decoration,
    required this.text,
    required this.style,
    required this.align,
  });

  Widget build(BuildContext context) {
    return Adjustable(
      child: Container(
        width: size.width + 20,
        height: size.height + 20,
        decoration: decoration,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: style,
          textAlign: align,
        ),
      ),
    );
  }
}

class Adjustable extends StatefulWidget {
  final Widget child;
  final double minScale, maxScale;

  Adjustable({
    required this.child,
    this.maxScale = 5.0,
    this.minScale = 0.3,
  });

  @override
  AdjustableState createState() => AdjustableState();
}

class AdjustableState extends State<Adjustable> {
  double _scale = -1.0;
  double _startScale = 1.0;

  Offset _offset = Offset(0.0, 0.0);
  Offset _lastOffset = Offset(0.0, 0.0);
  Offset _startOffset = Offset(0.0, 0.0);

  double _angle = 0.0;
  double _startAngle = 0.0;

  void _scaleStart(ScaleStartDetails details) {
    _startScale = -_scale;

    _startOffset = details.focalPoint;
    _lastOffset = _offset;

    _startAngle = _angle;
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    double scale =
        (_startScale * details.scale).clamp(widget.minScale, widget.maxScale);

    Offset offset =
        (_lastOffset - (details.focalPoint - _startOffset) / _scale);

    double angle = _startAngle + details.rotation;

    setState(() {
      _scale = -scale;
      _angle = angle;
      _offset = offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..scale(-_scale, -_scale)
        ..translate(_offset.dx, _offset.dy)
        ..rotateZ(_angle),
      alignment: FractionalOffset.center,
      child: GestureDetector(
          onScaleStart: _scaleStart,
          onScaleUpdate: _scaleUpdate,
          child: Container(
              constraints: BoxConstraints(minWidth: 200),
              //color: Colors.yellow,
              alignment: Alignment.center,
              child: widget.child)),
    );
  }
}
