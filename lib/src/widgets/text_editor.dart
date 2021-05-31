import 'package:contents_editor/src/widgets/color_slider.dart';
import 'package:contents_editor/src/widgets/overlay_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

class TextEditor extends StatefulWidget {
  const TextEditor();

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _fieldKey = GlobalKey();

  TextStyle _style = TextStyle(color: Colors.white);
  TextAlign _align = TextAlign.center;
  BoxDecoration _decoration = BoxDecoration();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height - bottomInset;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                IconButton(
                  icon: Icon(
                    Icons.done,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final widget = _convertToWidget();
                    Navigator.pop(context, widget);
                  },
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                constraints: BoxConstraints(maxHeight: 300),
                decoration: _decoration,
                padding: const EdgeInsets.all(10.0),
                child: AutoSizeTextField(
                  textFieldKey: _fieldKey,
                  controller: _controller,
                  fullwidth: false,
                  autofocus: true,
                  minFontSize: 0,
                  maxLines: null,
                  style: _style.copyWith(fontSize: 40),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0.0),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  //expands: true,
                  textAlign: _align,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _stylePicker(),
            ColorPicker(
              onChangeColor: (color) => setState(
                () {
                  _style = _style.copyWith(color: color);
                  _decoration =
                      _decoration.copyWith(border: Border.all(color: color));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stylePicker() {
    return Container(
      height: 60,
      color: Colors.white.withOpacity(0.3),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, index) => [
          InkWell(
            onTap: () {
              setState(() {
                _decoration = BoxDecoration();
              });
            },
            child: Container(
              height: 40,
              width: 60,
              alignment: Alignment.center,
              child: Text(
                'Text',
                style: _style,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _decoration = _decoration.copyWith(
                  border: Border.all(
                    width: 2,
                    color: _style.color ?? Colors.white,
                  ),
                );
              });
            },
            child: Container(
              height: 40,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _style.color ?? Colors.white,
                  width: 2,
                ),
              ),
              child: Text(
                'Box',
                style: _style,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _decoration = _decoration.copyWith(color: Colors.white);
              });
            },
            child: Container(
              height: 40,
              width: 60,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                'Fill',
                style: _style,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _decoration = _decoration.copyWith(
                  color: Colors.black.withOpacity(0.7),
                );
              });
            },
            child: Container(
              height: 40,
              width: 60,
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.7),
              child: Text(
                'Caption',
                style: _style,
              ),
            ),
          ),
        ].elementAt(index),
      ),
    );
  }

  Widget? _convertToWidget() {
    if (_controller.text.isNotEmpty) {
      final field = _fieldKey.currentWidget as TextField;
      final renderBox =
          _fieldKey.currentContext?.findRenderObject() as RenderBox;
      print(field.style);
      final style = field.style ?? _style;
      final size = renderBox.size;

      return OverlayTextWidget(
        size: size,
        decoration: _decoration,
        text: _controller.text,
        align: _align,
        style: style,
      );
    }
  }
}
