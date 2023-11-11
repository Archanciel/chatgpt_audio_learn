import 'package:flutter/material.dart';

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
    final context = myKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    int targetIndex = 17; // Replace with the index of the target item.

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
            title: Text('Item $index'),
            tileColor: index == targetIndex ? Colors.blue : null,
            onTap: () {
              // Your onTap logic here
            },
          );
        },
      ),
    );
  }
}
