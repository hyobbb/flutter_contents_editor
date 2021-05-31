import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class BrushSlider extends StatefulWidget {
  final Color brushColor;
  final ValueChanged<double> onChangeEnd;

  BrushSlider(this.brushColor, {required this.onChangeEnd});

  @override
  _BrushSliderState createState() => _BrushSliderState();
}

class _BrushSliderState extends State<BrushSlider> {
  double sliderValue = 2.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: Colors.grey,
          inactiveTrackColor: Colors.white,
          trackShape: RectangularSliderTrackShape(),
          activeTickMarkColor: Colors.white,
          inactiveTickMarkColor: Colors.white,
          thumbShape: _SliderThumbShape(widget.brushColor),
          overlayColor: widget.brushColor.withOpacity(0.2),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
          thumbColor: Colors.white,
        ),
        child: Slider(
          value: sliderValue,
          min: 0.5,
          max: 10.0,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
            });
          },
          onChangeEnd: widget.onChangeEnd,
        ),
      ),
    );
  }
}

class _SliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const _SliderThumbShape(
    this.sliderColor, {
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius = 10.0,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  final Color sliderColor;

  final double enabledThumbRadius;

  final double disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius;

  final double elevation;

  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);
    final Path path = Path()
      ..addArc(
          Rect.fromCenter(
              center: center, width: 2 * radius, height: 2 * radius),
          0,
          pi * 2);
    canvas.drawShadow(path, Colors.black, evaluatedElevation, true);

    canvas.drawCircle(
      center,
      radius + 2,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = sliderColor,
    );
  }
}
