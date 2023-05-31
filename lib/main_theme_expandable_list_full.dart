import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListVM()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'MVVM Example',
            theme: themeProvider.isDarkMode
                ? ThemeData.dark()
                : ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                    icon: Icon(themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode),
                  ),
                ],
              ),
              body: const ExpandableListView(),
            ),
          );
        },
      ),
    );
  }
}

class ExpandableListView extends StatefulWidget {
  const ExpandableListView({super.key});

  @override
  State<ExpandableListView> createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                key: const Key('toggle_button'),
                onPressed: () {
                  Provider.of<ListVM>(context, listen: false).toggleList();
                },
                child: const Text('Toggle List'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                key: const Key('delete_button'),
                onPressed: Provider.of<ListVM>(context).isButton1Enabled
                    ? () {
                        Provider.of<ListVM>(context, listen: false)
                            .deleteSelectedItem(context);
                      }
                    : null,
                child: const Text('Delete'),
              ),
            ),
            Expanded(
              child: IconButton(
                key: const Key('move_up_button'),
                onPressed: Provider.of<ListVM>(context).isButton2Enabled
                    ? () {
                        Provider.of<ListVM>(context, listen: false)
                            .moveSelectedItemUp();
                      }
                    : null,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 50,
                ),
                tooltip: 'Move item up',
              ),
            ),
            Expanded(
              child: IconButton(
                key: const Key('move_down_button'),
                onPressed: Provider.of<ListVM>(context).isButton3Enabled
                    ? () {
                        Provider.of<ListVM>(context, listen: false)
                            .moveSelectedItemDown();
                      }
                    : null,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                ),
                tooltip: 'Move item down',
              ),
            ),
          ],
        ),
        Consumer<ListVM>(
          builder: (context, listViewModel, child) {
            if (listViewModel.isListExpanded) {
              return Expanded(
                child: ListView.builder(
                  itemCount: listViewModel.items.length,
                  itemBuilder: (context, index) {
                    ListItem item = listViewModel.items[index];
                    return ListTile(
                      title: Text(item.name),
                      trailing: Checkbox(
                        value: item.isSelected,
                        onChanged: (value) {
                          listViewModel.selectItem(context, index);
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

/// List view model used in ExpandableListView
class ListVM extends ChangeNotifier {
  bool _isListExpanded = false;
  bool _isButton1Enabled = false;
  bool _isButton2Enabled = false;
  bool _isButton3Enabled = false;

  bool get isListExpanded => _isListExpanded;
  bool get isButton1Enabled => _isButton1Enabled;
  bool get isButton2Enabled => _isButton2Enabled;
  bool get isButton3Enabled => _isButton3Enabled;

  final ListModel _model = ListModel();
  List<ListItem> get items => _model.items;

  void toggleList() {
    _isListExpanded = !_isListExpanded;

    if (!_isListExpanded) {
      _disableButtons();
    } else {
      if (_model.isListItemSelected) {
        _enableButtons();
      } else {
        _disableButtons();
      }
    }

    notifyListeners();
  }

  void selectItem(BuildContext context, int index) {
    bool isOneItemSelected = _model.selectItem(index);

    if (!isOneItemSelected) {
      _disableButtons();
    } else {
      _enableButtons();
    }

    notifyListeners();
  }

  void deleteSelectedItem(BuildContext context) {
    int selectedIndex = _getSelectedIndex();

    if (selectedIndex != -1) {
      _model.deleteItem(selectedIndex);
      _disableButtons();

      notifyListeners();
    }
  }

  void moveSelectedItemUp() {
    int selectedIndex = _getSelectedIndex();
    if (selectedIndex != -1) {
      _model.moveItemUp(selectedIndex);
      notifyListeners();
    }
  }

  void moveSelectedItemDown() {
    int selectedIndex = _getSelectedIndex();
    if (selectedIndex != -1) {
      _model.moveItemDown(selectedIndex);
      notifyListeners();
    }
  }

  int _getSelectedIndex() {
    for (int i = 0; i < _model.items.length; i++) {
      if (_model.items[i].isSelected) {
        return i;
      }
    }
    return -1;
  }

  void _enableButtons() {
    _isButton1Enabled = true;
    _isButton2Enabled = true;
    _isButton3Enabled = true;
  }

  void _disableButtons() {
    _isButton1Enabled = false;
    _isButton2Enabled = false;
    _isButton3Enabled = false;
  }
}

class ListItem {
  String name;
  bool isSelected;

  ListItem({required this.name, required this.isSelected});
}

class ListModel extends ChangeNotifier {
  bool _isListItemSelected = false;

  bool get isListItemSelected => _isListItemSelected;
  set isListItemSelected(bool value) => _isListItemSelected = value;

  final List<ListItem> _items = [
    ListItem(name: 'Item 1', isSelected: false),
    ListItem(name: 'Item 2', isSelected: false),
    ListItem(name: 'Item 3', isSelected: false),
    ListItem(name: 'Item 4', isSelected: false),
    ListItem(name: 'Item 5', isSelected: false),
    ListItem(name: 'Item 6', isSelected: false),
    ListItem(name: 'Item 7', isSelected: false),
    ListItem(name: 'Item 8', isSelected: false),
    ListItem(name: 'Item 9', isSelected: false),
    ListItem(name: 'Item 10', isSelected: false),
  ];

  List<ListItem> get items => _items;

  bool selectItem(int index) {
    for (int i = 0; i < _items.length; i++) {
      if (i == index) {
        _items[i].isSelected = !_items[i].isSelected;
      } else {
        _items[i].isSelected = false;
      }
    }

    _isListItemSelected = _items[index].isSelected;

    return _isListItemSelected;
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    _isListItemSelected = false;
  }

  void moveItemUp(int index) {
    if (index == 0) {
      ListItem item = _items.removeAt(index);
      _items.add(item);
    } else {
      ListItem item = _items.removeAt(index);
      _items.insert(index - 1, item);
    }
    notifyListeners();
  }

  void moveItemDown(int index) {
    if (index == _items.length - 1) {
      ListItem item = _items.removeAt(index);
      _items.insert(0, item);
    } else {
      ListItem item = _items.removeAt(index);
      _items.insert(index + 1, item);
    }
    notifyListeners();
  }
}
