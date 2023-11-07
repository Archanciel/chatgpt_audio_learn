import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                  builder: (context) => const MyDialog(),
                ).then((value) {
                  print(value);
                });
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({super.key});

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
          if (event.physicalKey == PhysicalKeyboardKey.enter) {
            Navigator.pop(context, 'Default Action from clicking on Enter');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This is a dialog'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Default Action');
              },
              child: const Text('Default Action'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
