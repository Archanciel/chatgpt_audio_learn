import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MyDialog(),
              );
            },
            child: Text('Show Dialog'),
          ),
        ),
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyEvent && event.physicalKey == PhysicalKeyboardKey.enter) {
            Navigator.pop(context, 'Default Action');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This is a dialog'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Default Action');
              },
              child: Text('Default Action'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
