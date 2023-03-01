// dart file located in lib

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Audio Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpandableListView(),
    );
  }
}

class ExpandableListView extends StatefulWidget {
  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool _isExpanded = false;

  final List<String> _listItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Audio Downloader'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Expandable List View',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                label: const Text(''),
                icon: _isExpanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
              ),
            ],
          ),
          _isExpanded
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_listItems[index]),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
