import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flexible Example')),
        body: Column(
          children: [
            Flexible(
              flex: 1, // Takes up 1 part of the available space
              child: Container(
                color: Colors.red,
                child: Center(child: Text('Flex 1')),
              ),
            ),
            Flexible(
              flex: 2, // Takes up 2 parts of the available space
              child: Container(
                color: Colors.green,
                child: Center(child: Text('Flex 2')),
              ),
            ),
            Flexible(
              flex: 3, // Takes up 3 parts of the available space
              child: Container(
                color: Colors.blue,
                child: Center(child: Text('Flex 3')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
