import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:contents_editor/contents_editor.dart';

void main() {
  testWidgets('testing brush', (tester) async {
    await tester.pumpWidget(MyWidget());
  });
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ContentsEditor(child: Placeholder()),
      ),
    );
  }
}
