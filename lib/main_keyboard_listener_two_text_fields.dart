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
          child: const Text('Show Conditional TextField Dialog'),
          onPressed: () => showConditionalDialog(context, true),
        ),
      ),
    );
  }
}

class ConditionalTextFieldDialog extends StatefulWidget {
  final bool focusOnFirstField;

  ConditionalTextFieldDialog({required this.focusOnFirstField});

  @override
  _ConditionalTextFieldDialogState createState() =>
      _ConditionalTextFieldDialogState();
}

class _ConditionalTextFieldDialogState
    extends State<ConditionalTextFieldDialog> {
  final FocusNode _dialogFocusNode = FocusNode();
  final FocusNode _firstTextFieldFocusNode = FocusNode();
  final FocusNode _secondTextFieldFocusNode = FocusNode();

  final TextEditingController _firstTextFieldController =
      TextEditingController();
  final TextEditingController _secondTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure the correct text field gets focus based on the passed condition
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _dialogFocusNode.requestFocus();
    // });
  }

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
  void dispose() {
    _firstTextFieldController.dispose();
    _secondTextFieldController.dispose();
    _firstTextFieldFocusNode.dispose();
    _secondTextFieldFocusNode.dispose();
    _dialogFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode conditionalTextFieldFocusNode;

    if (widget.focusOnFirstField) {
      conditionalTextFieldFocusNode = _firstTextFieldFocusNode;
    } else {
      conditionalTextFieldFocusNode =_secondTextFieldFocusNode;
    }

    FocusScope.of(context).requestFocus(
      conditionalTextFieldFocusNode,
    );

    return KeyboardListener(
      focusNode: _dialogFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: AlertDialog(
        title: Text('Conditional TextField Dialog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _firstTextFieldController,
              focusNode: _firstTextFieldFocusNode,
              decoration: InputDecoration(labelText: 'First Text Field'),
            ),
            TextField(
              controller: _secondTextFieldController,
              focusNode: _secondTextFieldFocusNode,
              decoration: InputDecoration(labelText: 'Second Text Field'),
            ),
          ],
        ),
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

// Usage example, passing the condition:
void showConditionalDialog(BuildContext context, bool focusOnFirstField) {
  showDialog(
    context: context,
    builder: (context) =>
        ConditionalTextFieldDialog(focusOnFirstField: focusOnFirstField),
  );
}
