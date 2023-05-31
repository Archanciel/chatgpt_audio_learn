import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MessageVM(),
      child: const MyApp(),
    ),
  );
}

class MessageVM extends ChangeNotifier {
  bool _shouldDisplayMessage = false;
  String _message = '';

  bool get shouldDisplayMessage => _shouldDisplayMessage;
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemple de Tooltip avec Provider'),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info),
                          ElevatedButton(
                            onPressed: () {
                              tooltipNotifier
                                  .displayMessage('Message depuis le Provider');
                            },
                            child: const Text('Afficher le Tooltip'),
                          ),
                        ],
                      ),
                    ),
                    if (tooltipNotifier.shouldDisplayMessage)
                      Positioned(
                        top: 120,
                        left: 100,
                        child: MessageWidget(
                          message: tooltipNotifier.message,
                          hideMessageMethod: tooltipNotifier.hideMessage,
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

class MessageWidget extends StatelessWidget {
  final String _message;
  final void Function() _hideMessageMethod;

  const MessageWidget({
    Key? key,
    required String message,
    required void Function() hideMessageMethod,
  })  : _hideMessageMethod = hideMessageMethod,
        _message = message,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox( // solves the "Exception has occurred. FlutterError 
                  // (BoxConstraints forces an infinite width and infinite 
                  // height". Defines the size of the GestureDetector, i.e.
                  // the region on which typing closes the message.
          width: 400,
          height: 200,
          child: GestureDetector(
            onTap: _hideMessageMethod,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_message),
            ),
          ],
        ),
      ],
    );
  }
}
