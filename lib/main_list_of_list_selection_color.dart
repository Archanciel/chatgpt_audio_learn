// generated by ChatGPT-4: Flutter app with master/sublist.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapOfListProvider with ChangeNotifier {
  Map<String, List<String>> mapOfList = {
    'key1': ['key1-value1', 'key1-value2'],
    'key2': ['key2-value1', 'key2-value2', 'key2-value3', 'key2-value4'],
    'key3': ['key3-value1', 'key3-value2', 'key3-value3'],
    'key4': ['key4-value1', 'key4-value2'],
    'key5': ['key5-value1', 'key5-value2', 'key5-value3', 'key5-value4'],
  };

  Map<String, Color> selectedKeys = {};
  String selectedSublistItem = '';

  void toggleKey(String key, Color color) {
    if (selectedKeys.containsKey(key)) {
      selectedKeys.remove(key);
    } else {
      selectedKeys[key] = color;
    }
    notifyListeners();
  }

  List<String> getMasterListSelectedValues() {
    List<String> values = [];
    selectedKeys.forEach((key, _) {
      values.addAll(mapOfList[key]!);
    });
    values.sort(); // Sort the values before returning them

    return values;
  }

  void setSelectedSublistItem(String value) {
    selectedSublistItem = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Map of List Display')),
        body: const Column(
          children: [
            Expanded(child: MasterList()),
            Expanded(child: SubList()),
          ],
        ),
      ),
    );
  }
}

class MasterList extends StatelessWidget {
  const MasterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapOfListProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          key: const Key('master-list'),
          itemCount: provider.mapOfList.length,
          itemBuilder: (context, index) {
            final key = provider.mapOfList.keys.elementAt(index);
            final color = Colors.primaries[index % Colors.primaries.length];
            final selected = provider.selectedKeys.containsKey(key);
            return Container(
              color: selected ? color.withOpacity(0.3) : null,
              child: ListTile(
                title: Text(
                  key,
                  style: TextStyle(color: color),
                ),
                onTap: () => provider.toggleKey(key, color),
              ),
            );
          },
        );
      },
    );
  }
}

class SubList extends StatelessWidget {
  const SubList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapOfListProvider>(
      builder: (context, provider, _) {
        final selectedValues = provider.getMasterListSelectedValues();
        return ListView.builder(
          key: const Key('sub-list'),
          itemCount: selectedValues.length,
          itemBuilder: (context, index) {
            final value = selectedValues[index];
            final key = provider.mapOfList.entries
                .firstWhere((entry) => entry.value.contains(value))
                .key;
            final color = provider.selectedKeys[key];
            final selected = provider.selectedSublistItem == value;
            return Container(
              color: selected ? color!.withOpacity(0.3) : null,
              child: ListTile(
                title: Text(
                  value,
                  style: TextStyle(color: color),
                ),
                onTap: () {
                  if (selected) {
                    provider.setSelectedSublistItem('');
                    return;
                  }
                  provider.setSelectedSublistItem(value);
                },
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MapOfListProvider(),
      child: const MyApp(),
    ),
  );
}