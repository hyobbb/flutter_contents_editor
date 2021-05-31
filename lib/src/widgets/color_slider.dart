import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final ValueChanged<Color>? onChangeColor;

  const ColorPicker({this.onChangeColor});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 128, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 128),
    Color.fromARGB(255, 0, 0, 0),
  ];

  double _width = 0.0;

  @override
  initState() {
    super.initState();
  }

  _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > _width) {
      position = _width;
    }
    if (position < 0) {
      position = 0;
    }
    if (widget.onChangeColor != null) {
      widget.onChangeColor!(_calculateSelectedColor(position));
    }
  }

  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray = (position / _width * (_colors.length - 1));
    int index = positionInColorArray.truncate();
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      return _colors[index];
    } else {
      //calculate new color
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
                  (_colors[index + 1].red - _colors[index].red) * remainder)
              .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
                  (_colors[index + 1].green - _colors[index].green) * remainder)
              .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
                  (_colors[index + 1].blue - _colors[index].blue) * remainder)
              .round();
      return Color.fromARGB(255, redValue, greenValue, blueValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: LayoutBuilder(builder: (_, constraints) {
        _width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (DragStartDetails details) {
            _colorChangeHandler(details.localPosition.dx);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            _colorChangeHandler(details.localPosition.dx);
          },
          onTapDown: (TapDownDetails details) {
            _colorChangeHandler(details.localPosition.dx);
          },
          //This outside padding makes it much easier to grab the   slider because the gesture detector has
          // the extra padding to recognize gestures inside of
          child: Container(
            width: constraints.maxWidth,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              gradient: LinearGradient(colors: _colors),
            ),
          ),
        );
      }),
    );
  }
}
