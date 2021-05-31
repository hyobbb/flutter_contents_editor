import 'package:contents_editor/src/controllers/controllers.dart';
import 'package:contents_editor/src/widgets/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'widgets/brush_canvas.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:contents_editor/src/widgets/brush_canvas.dart';
import 'package:flutter/rendering.dart';

class ContentsEditor extends StatefulWidget {
  final Widget child;

  ContentsEditor({required this.child});

  @override
  _ContentsEditorState createState() => _ContentsEditorState();
}

class _ContentsEditorState extends State<ContentsEditor> {
  final BrushController _brushController = BrushController();
  final GlobalKey key = GlobalKey();
  bool _isEditing = false;
  List<Widget> overlays = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _buildOverlays(),
        _buttonBar(),
      ],
    );
  }

  Widget _buildOverlays() {
    return RepaintBoundary(
      key: key,
      child: Stack(
        children: [
          ...overlays,
          BrushCanvas(
            _brushController,
            onDone: _toggle,
          ),
        ],
      ),
    );
  }

  Widget _buttonBar() {
    if (!_isEditing) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.brush,
              color: Colors.amber,
            ),
            onPressed: () {
              _brushController.enableDraw = true;
              _toggle();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.text_fields,
              color: Colors.amber,
            ),
            onPressed: () async {
              _toggle();
              final textWidget = await showDialog(
                context: context,
                builder: (_) => const TextEditor(),
              );

              if (textWidget != null) {
                overlays.add(textWidget);
              }

              _toggle();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.sticky_note_2,
              color: Colors.amber,
            ),
            onPressed: () {
              //fetch sticker selection
            },
          ),
          IconButton(
            icon: Icon(
              Icons.download_rounded,
              color: Colors.amber,
            ),
            onPressed: () async {
              //download
              final file = await capturePng();
              if (file != null) {
                Share.shareFiles([file.path]);
              }
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _toggle() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<File?> capturePng() async {
    final context = key.currentContext;
    if (context != null) {
      RenderRepaintBoundary boundary =
          context.findRenderObject() as RenderRepaintBoundary;
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        var currentImage = img.decodeImage(pngBytes);
        if (currentImage != null) {
          var resizedImage =
              img.copyResize(currentImage, width: 720, height: 1280);
          final dir = await getTemporaryDirectory();
          await dir.create(recursive: true);
          final tempFile = File(path.join(dir.path, 'contents.png'));
          await tempFile.writeAsBytes(img.encodePng(resizedImage));
          return tempFile;
        }
      }
    }
    return null;
  }
}
