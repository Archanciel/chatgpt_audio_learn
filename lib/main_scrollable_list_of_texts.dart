import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListTile Scroll To Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyListWidget(),
    );
  }
}

class MyListWidget extends StatefulWidget {
  @override
  _MyListWidgetState createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey myKey = GlobalKey();
  int targetIndex = 57; // Replace with the index of the target item.
  Random random = Random();
  final double itemHeight =
      75.0; // Estimate or calculate the height of your ListTile

  @override
  void initState() {
    super.initState();
    // Schedule a post-frame callback to scroll to the item
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToItem());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToItem() {
    final double offset = targetIndex * itemHeight;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    } else {
      // The scroll controller isn't attached to any scroll views.
      // Schedule a callback to try again after the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToItem());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scroll To ListTile Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            key: index == targetIndex ? myKey : null,
            title: buildTitle(index),
            tileColor: index == targetIndex ? Colors.blue : null,
            onTap: () {
              // Your onTap logic here
            },
          );
        },
      ),
    );
  }

  Text buildTitle(int index) {
    int randomNumber = random.nextInt(6) + 1; // Random number between 1 and 6
    String title = List.generate(randomNumber, (_) => 'Title').join('\n');

    return Text('$title $index');
  }
}
