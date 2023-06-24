import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

import '../models/playlist.dart';

/// List view model used in ExpandableListView
class ExpandablePlaylistListVM extends ChangeNotifier {
  bool _isListExpanded = false;
  bool _isButton1Enabled = false;
  bool _isButton2Enabled = false;
  bool _isButton3Enabled = false;

  bool get isListExpanded => _isListExpanded;
  bool get isButton1Enabled => _isButton1Enabled;
  bool get isButton2Enabled => _isButton2Enabled;
  bool get isButton3Enabled => _isButton3Enabled;

  bool _isPlaylistSelected = false;

  bool get isPlaylistSelected => _isPlaylistSelected;
  set isPlaylistSelected(bool value) => _isPlaylistSelected = value;

  final List<Playlist> items = [
    Playlist(url: 'Item 1'),
    Playlist(url: 'Item 2'),
    Playlist(url: 'Item 3'),
    Playlist(url: 'Item 4'),
    Playlist(url: 'Item 5'),
    Playlist(url: 'Item 6'),
    Playlist(url: 'Item 7'),
  ];

  Future<void> addItemUsingYoutube(String url) async {
    String? playlistId;
    playlistId = yt.PlaylistId.parsePlaylistId(url);
    String playlistTitle = await obtainPlaylistTitle(playlistId);

    Playlist playlist = Playlist(url: url);
    playlist.title = playlistTitle;
    items.add(playlist);

    notifyListeners();
  }

  Future<String> obtainPlaylistTitle(String? playlistId) async {
    yt.YoutubeExplode youtubeExplode = yt.YoutubeExplode();

    String playlistTitle = '';

    try {
      yt.Playlist youtubePlaylist =
          await youtubeExplode.playlists.get(playlistId);
      playlistTitle = youtubePlaylist.title;
    } catch (e) {
      // empty playlistTitle will be returned
      print('Error: $e');
    }

    return playlistTitle;
  }

  void toggleList() {
    _isListExpanded = !_isListExpanded;

    if (!_isListExpanded) {
      _disableButtons();
    } else {
      if (isPlaylistSelected) {
        _enableButtons();
      } else {
        _disableButtons();
      }
    }

    notifyListeners();
  }

  void selectItem(BuildContext context, int index) {
    bool isOneItemSelected = doSelectItem(index);

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
      deleteItem(selectedIndex);
      _disableButtons();

      notifyListeners();
    }
  }

  void moveSelectedItemUp() {
    int selectedIndex = _getSelectedIndex();
    if (selectedIndex != -1) {
      moveItemUp(selectedIndex);
      notifyListeners();
    }
  }

  void moveSelectedItemDown() {
    int selectedIndex = _getSelectedIndex();
    if (selectedIndex != -1) {
      moveItemDown(selectedIndex);
      notifyListeners();
    }
  }

  int _getSelectedIndex() {
    for (int i = 0; i < items.length; i++) {
      if (items[i].isSelected) {
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

  bool doSelectItem(int index) {
    for (int i = 0; i < items.length; i++) {
      if (i == index) {
        items[i].isSelected = !items[i].isSelected;
      } else {
        items[i].isSelected = false;
      }
    }

    _isPlaylistSelected = items[index].isSelected;

    return _isPlaylistSelected;
  }

  void deleteItem(int index) {
    items.removeAt(index);
    _isPlaylistSelected = false;
  }

  void moveItemUp(int index) {
    if (index == 0) {
      Playlist item = items.removeAt(index);
      items.add(item);
    } else {
      Playlist item = items.removeAt(index);
      items.insert(index - 1, item);
    }
    notifyListeners();
  }

  void moveItemDown(int index) {
    if (index == items.length - 1) {
      Playlist item = items.removeAt(index);
      items.insert(0, item);
    } else {
      Playlist item = items.removeAt(index);
      items.insert(index + 1, item);
    }
    notifyListeners();
  }
}
