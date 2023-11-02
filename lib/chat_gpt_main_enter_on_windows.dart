import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MyDialog(),
                ).then((value) {
                  print(value);
                });
              },
              child: Text('Show Dialog'),
            ),
          ),
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Dispose the focus node when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (event) {
          print('handling event');
          if (event is RawKeyEvent &&
              event.physicalKey == PhysicalKeyboardKey.enter) {
            Navigator.pop(context, 'Default Action from clicking on Enter');
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
