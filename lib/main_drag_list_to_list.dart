import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SourceTargetListsVM(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SourceTargetListsVM sourceTargetListsVMListenFalse =
        Provider.of<SourceTargetListsVM>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorderable Lists'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showReorderDialog(
            context,
            sourceTargetListsVMListenFalse,
          ),
          child: const Text('Open Lists Dialog'),
        ),
      ),
    );
  }

  void _showReorderDialog(
    BuildContext context,
    SourceTargetListsVM sourceTargetListsVMListenFalse,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reorder Items'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: _buildDraggableList(
                    sourceTargetListsVMListenFalse,
                    true,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildDragTargetList(
                    sourceTargetListsVMListenFalse,
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
    SourceTargetListsVM sourceTargetListsVM,
    bool isListOne,
  ) {
    return ListView.builder(
      itemCount: sourceTargetListsVM.sourceList.length,
      itemBuilder: (context, index) {
        return Draggable<String>(
          // enables dragging list items
          data: sourceTargetListsVM.sourceList[index],
          feedback: Material(
            elevation: 4.0,
            child: Container(
              width: 100,
              height: 56,
              color: Colors.blue,
              child: Center(
                child: Text(
                  sourceTargetListsVM.sourceList[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(),
          onDragCompleted: () {},
          child: ListTile(
            title: Text(sourceTargetListsVM.sourceList[index]),
          ),
        );
      },
    );
  }

  Widget _buildDragTargetList(
    SourceTargetListsVM sourceTargetListsVMListenFalse,
    bool isListOne,
  ) {
    return Consumer<SourceTargetListsVM>(
      builder: (context, sourceTargetListsVMConsumer, child) {
        return DragTarget<String>(
          // enables receiving dragged list items
          onWillAccept: (data) => true,
          onAccept: (data) {
            if (!sourceTargetListsVMListenFalse.targetList.contains(data)) {
              sourceTargetListsVMListenFalse.addToTargetList(data);
            }
          },
          builder: (context, candidateData, rejectedData) {
            return ListView.builder(
              itemCount: sourceTargetListsVMListenFalse.targetList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sourceTargetListsVMListenFalse.targetList[index]),
                  trailing: IconButton(
                    onPressed: () {
                      sourceTargetListsVMConsumer.removeFromTargetListAt(index);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class SourceTargetListsVM extends ChangeNotifier {
  final List<String> _sourceList;
  List<String> get sourceList => _sourceList;

  final List<String> _targetList;
  List<String> get targetList => _targetList;

  SourceTargetListsVM()
      : _sourceList = [
          'Item 1',
          'Item 2',
          'Item 3',
        ],
        _targetList = [
          'Item A',
          'Item B',
          'Item C',
        ];

  void addToTargetList(String item) {
    _targetList.add(item);

    notifyListeners();
  }

  void removeFromTargetListAt(int index) {
    _targetList.removeAt(index);

    notifyListeners();
  }
}
