import 'dart:ui';
import 'package:contents_editor/src/widgets/brush_slider.dart';
import 'package:contents_editor/src/widgets/color_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/controllers.dart';

class BrushCanvas extends StatefulWidget {
  final BrushController controller;
  final VoidCallback onDone;

  BrushCanvas(this.controller, {required this.onDone});

  @override
  _BrushCanvasState createState() => _BrushCanvasState();
}

class _BrushCanvasState extends State<BrushCanvas> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: IgnorePointer(
        ignoring: !widget.controller.enableDraw,
        child: Stack(
          children: [
            GestureDetector(
              onPanDown: _startFrame,
              onPanUpdate: _drawingFrame,
              onPanEnd: _finishFrame,
              child: _buildFrameStack(),
            ),
            if (widget.controller.enableDraw)
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.controller.drawingFrames.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        icon: Icon(
                          Icons.done,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          widget.controller.enableDraw = false;
                          widget.onDone();
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ColorPicker(
                    onChangeColor: (color) => setState(() {
                      widget.controller.strokeColor = color;
                    }),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.replay),
                          onPressed: () => setState(
                            () => widget.controller.eraseFrame(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      BrushSlider(
                        widget.controller.strokeColor,
                        onChangeEnd: (width) =>
                            widget.controller.strokeWidth = width,
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.refresh),
                          onPressed: () => setState(
                            () => widget.controller.recoverFrame(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25)
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameStack() {
    return Stack(
      children: widget.controller.drawingFrames
          .map(
            (frame) => ClipRect(
              child: CustomPaint(
                painter: RecordingPainter(frame),
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  _startFrame(DragDownDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      widget.controller.startFrame(offset);
    });
  }

  _drawingFrame(DragUpdateDetails details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      widget.controller.drawFrame(offset);
    });
  }

  _finishFrame(DragEndDetails details) {
    setState(() {
      widget.controller.endFrame();
    });
  }
}

class RecordingPainter extends CustomPainter {
  final BrushFrame _frame;

  RecordingPainter(this._frame) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final offsets = _frame.offsets;
    final paint = Paint()
      ..color = _frame.strokeColor
      ..strokeWidth = _frame.strokeWidth;

    for (var i = 0; i < offsets.length; i++) {
      if (shouldDrawLine(i)) {
        canvas.drawLine(offsets[i]!, offsets[i + 1]!, paint);
      } else if (shouldDrawPoint(i)) {
        canvas.drawPoints(PointMode.points, [offsets[i]!], paint);
      }
    }
  }

  bool shouldDrawPoint(int i) =>
      _frame.offsets[i] != null &&
      _frame.offsets.length > i + 1 &&
      _frame.offsets[i + 1] == null;

  bool shouldDrawLine(int i) =>
      _frame.offsets[i] != null &&
      _frame.offsets.length > i + 1 &&
      _frame.offsets[i + 1] != null;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class BrushFrame {
  List<Offset?> offsets;
  Color strokeColor;
  double strokeWidth;

  BrushFrame({this.strokeColor = Colors.white, this.strokeWidth = 1.0})
      : offsets = [];
}
