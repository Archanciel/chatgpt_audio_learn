import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _listOne = ['Item 1', 'Item 2', 'Item 3'];
  List<String> _listTwo = ['Item A', 'Item B', 'Item C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reorderable Lists'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showReorderDialog(context),
          child: Text('Open Lists Dialog'),
        ),
      ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reorder Items'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: _buildReorderableList(_listOne, _listTwo, true),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _buildReorderableList(_listTwo, _listOne, false),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReorderableList(List<String> list, List<String> oppositeList, bool isListOne) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index]),
          leading: Icon(Icons.reorder),
          trailing: Draggable<String>(
            data: list[index],
            child: Icon(Icons.drag_handle),
            feedback: Material(
              child: Container(
                width: 100,
                height: 56,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    list[index],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(),
            onDragCompleted: () {},
          ),
          onTap: () {},
        );
      },
    );
  }
}
