import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MessageVM(),
      child: MyApp(),
    ),
  );
}

class MessageVM extends ChangeNotifier {
  bool _shouldDisplayMessage = false;
  String _message = '';

  bool get shouldShowTooltip => _shouldDisplayMessage;
  String get message => _message;

  void displayMessage(String message) {
    _shouldDisplayMessage = true;
    _message = message;

    notifyListeners();
  }

  void hideMessage() {
    _shouldDisplayMessage = false;
    _message = '';

    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemple de Tooltip avec Provider'),
        ),
        body: Consumer<MessageVM>(
          builder: (context, tooltipNotifier, child) {
            return Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          tooltipNotifier
                              .displayMessage('Message depuis le Provider');
                        },
                        child: Text('Afficher le Tooltip'),
                      ),
                    ),
                    if (tooltipNotifier.shouldShowTooltip)
                      Positioned(
                        top: 100,
                        left: 100,
                        child: MessageIncluderWidget(
                          message: tooltipNotifier.message,
                          hideMessageMethod: tooltipNotifier.hideMessage,
                          child: Icon(Icons.info),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MessageIncluderWidget extends StatelessWidget {
  final String _message;
  final Widget _child;
  final void Function() _hideMessageMethod;

  const MessageIncluderWidget({
    Key? key,
    required String message,
    required Widget child,
    required void Function() hideMessageMethod,
  })  : _hideMessageMethod = hideMessageMethod,
        _child = child,
        _message = message,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 200,
          height: 100,
          child: GestureDetector(
            onTap: _hideMessageMethod,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_message),
            ),
            _child,
          ],
        ),
      ],
    );
  }
}
