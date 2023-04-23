import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _showTopSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
        top: MediaQuery.of(context).padding.top + 8,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _showTopSnackBar(
                  context, 'This is a SnackBar message at the top');
            },
            child: const Text('Show SnackBar'),
          ),
          ElevatedButton(
            onPressed: () {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                message: 'This is a Flushbar message at the top',
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.blue,
                margin: const EdgeInsets.all(15),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ).show(context);
            },
            child: const Text('Show Top Snackbar'),
          ),
        ],
      ),
    );
  }
}
