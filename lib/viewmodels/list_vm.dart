import 'package:flutter/material.dart';

import '../models/list_model.dart';

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
