import 'package:contents_editor/src/widgets/brush_canvas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BrushController {
  bool enableDraw = false;
  Color strokeColor = Colors.white;
  double strokeWidth = 1.0;

  //first frame must be empty one
  List<BrushFrame> _frames = [BrushFrame()];
  int _frameIndex = 0;

  BrushFrame get currentFrame => _frames[_frameIndex];

  List<BrushFrame> get drawingFrames => _frames.sublist(0, _frameIndex + 1);

  void startFrame(Offset offset) {
    _frames = _frames.sublist(0, _frameIndex + 1);
    _frames.add(
      BrushFrame(
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
      ),
    );
    _frameIndex++;
    currentFrame.offsets.add(offset);
  }

  void drawFrame(Offset offset) {
    currentFrame.offsets.add(offset);
  }

  void endFrame() {
    currentFrame.offsets.add(null);
  }

  void refresh() {
    _frames.clear();
    _frameIndex = 0;
    _frames.add(BrushFrame());
  }

  void eraseFrame() {
    if (_frameIndex != 0) {
      _frameIndex--;
    }
  }

  void recoverFrame() {
    if (_frameIndex < _frames.length - 1) {
      _frameIndex++;
    }
  }
}
