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
        title: const Text('Reorderable Lists'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showReorderDialog(context),
          child: const Text('Open Lists Dialog'),
        ),
      ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reorder Items'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: _buildDraggableList(
                    _listOne,
                    _listTwo,
                    true,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildDragTargetList(
                    _listTwo,
                    _listOne,
                    false,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableList(
    List<String> list,
    List<String> oppositeList,
    bool isListOne,
  ) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Draggable<String>(
          // enables dragging list items
          data: list[index],
          feedback: Material(
            elevation: 4.0,
            child: Container(
              width: 100,
              height: 56,
              color: Colors.blue,
              child: Center(
                child: Text(
                  list[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(),
          onDragCompleted: () {},
          child: ListTile(
            title: Text(list[index]),
          ),
        );
      },
    );
  }

  Widget _buildDragTargetList(
    List<String> list,
    List<String> oppositeList,
    bool isListOne,
  ) {
    return DragTarget<String>(
      // enables receiving dragged list items
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() {
          if (!list.contains(data)) {
            list.add(data);
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index]),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    list.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            );
          },
        );
      },
    );
  }
}
