import 'package:flutter/material.dart';

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
