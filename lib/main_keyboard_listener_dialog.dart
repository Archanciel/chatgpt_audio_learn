import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeyboardListener Dialog',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KeyboardListener Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show KeyboardListener Dialog'),
          onPressed: () => showConfirmationDialog(context),
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatefulWidget {
  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  final FocusNode _dialogFocusNode = FocusNode();

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _closeDialog();
      }
    }
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    // Required so that clicking on Enter closes the dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _dialogFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _dialogFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: AlertDialog(
        title: Text('Warning or Confirmation'),
        content: Text(
            'Please confirm the information shown. Press Enter to continue.'),
        actions: [
          TextButton(
            onPressed: _closeDialog,
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Usage example:
void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ConfirmationDialog(),
  );
}
