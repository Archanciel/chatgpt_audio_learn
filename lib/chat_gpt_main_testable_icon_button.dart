import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isEnabled = true;

  void _toggleEnabled(int i) {
    setState(() {
      _isEnabled = !_isEnabled;
    });
  }

  void _otherMethod(int i) {
    i++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Icon Buttons"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              key: const Key('toggleButton'),
              icon: const Icon(Icons.thumb_up),
              onPressed: _isEnabled ? () => _toggleEnabled(1) : null,
            ),
            IconButton(
              key: const Key('toggleButton_more_code'),
              icon: const Icon(Icons.thumb_up),
              onPressed: _isEnabled
                  ? () {
                      int i = 1;
                      _otherMethod(i);
                      setState(() {
                        _isEnabled = !_isEnabled;
                      });
                    }
                  : null,
            ),
            IconButton(
              key: const Key('notTestableToggleButton'),
              icon: const Icon(Icons.thumb_down),
              onPressed: () {
                _isEnabled ? _toggleEnabled(1) : null;
              },
            ),
            IconButton(
              key: const Key('enableButton'),
              icon: const Icon(Icons.reset_tv),
              onPressed: () => _toggleEnabled(1),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dialog'),
                  content: Column(
                    children: [
                      IconButton(
                        key: const Key('dialogButton'),
                        icon: const Icon(Icons.add),
                        onPressed: _isEnabled ? () {} : null,
                      ),
                      TextButton(
                        key: const Key('closeButton'),
                        onPressed: (() => Navigator.of(context).pop()),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
              child: const Text('Show Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
