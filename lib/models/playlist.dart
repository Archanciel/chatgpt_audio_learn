import 'dart:io';

import 'audio.dart';

/// This class
class Playlist {
  String id = '';
  String title = '';
  String url;
  String downloadPath = '';

  // Contains audio videos currently referrenced in the Youtube
  // playlist.
  final List<Audio> _youtubePlaylistAudioLst = [];
  List<Audio> get youtubePlaylistAudioLst => _youtubePlaylistAudioLst;

  // Contains the audios once referenced in the Youtube playlist
  // which were downloaded.
  List<Audio> downloadedAudioLst = [];

  // Contains the downloaded audios currently available on the
  // device.
  List<Audio> playableAudioLst = [];

  Playlist({
    required this.url,
  });

  /// This constructor requires all instance variables
  Playlist.json({
    required this.id,
    required this.title,
    required this.url,
    required this.downloadPath,
  });
  // Factory constructor: creates an instance of Playlist from a JSON object
  factory Playlist.fromJson(Map<String, dynamic> json) {
    Playlist playlist = Playlist.json(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      downloadPath: json['downloadPath'],
    );

    // Deserialize the Audio instances in the downloadedAudioLst and playableAudioLst
    if (json['downloadedAudioLst'] != null) {
      for (var audioJson in json['downloadedAudioLst']) {
        Audio audio = Audio.fromJson(audioJson);
        playlist.addDownloadedAudio(audio);
      }
    }

    if (json['playableAudioLst'] != null) {
      for (var audioJson in json['playableAudioLst']) {
        Audio audio = Audio.fromJson(audioJson);
        playlist.insertAtStartPlayableAudio(audio);
      }
    }

    return playlist;
  }

  // Method: converts an instance of Playlist to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'downloadPath': downloadPath,
      'downloadedAudioLst':
          downloadedAudioLst.map((audio) => audio.toJson()).toList(),
      'playableAudioLst':
          playableAudioLst.map((audio) => audio.toJson()).toList(),
    };
  }

  void addDownloadedAudio(Audio downloadedAudio) {
    downloadedAudio.enclosingPlaylist = this;
    downloadedAudioLst.add(downloadedAudio);
  }

  void removeDownloadedAudio(Audio downloadedAudio) {
    if (downloadedAudio.enclosingPlaylist == this) {
      downloadedAudio.enclosingPlaylist = null;
    }
    downloadedAudioLst.remove(downloadedAudio);
  }

  void insertAtStartPlayableAudio(Audio playableAudio) {
    playableAudio.enclosingPlaylist = this;
    playableAudioLst.insert(0, playableAudio);
  }

  void removePlayableAudio(Audio playableAudio) {
    playableAudioLst.remove(playableAudio);
  }

  @override
  String toString() {
    return title;
  }

  String getPlaylistDownloadFilePathName() {
    return '$downloadPath${Platform.pathSeparator}$title.json';
  }

  void sortDownloadedAudioLst({
    required AudioSortCriterion audioSortCriteriomn,
    required bool isSortAscending,
  }) {
    _sortAudioLst(
      lstToSort: downloadedAudioLst,
      audioSortCriteriomn: audioSortCriteriomn,
      isSortAscending: isSortAscending,
    );
  }

  void sortPlayableAudioLst({
    required AudioSortCriterion audioSortCriteriomn,
    required bool isSortAscending,
  }) {
    _sortAudioLst(
      lstToSort: playableAudioLst,
      audioSortCriteriomn: audioSortCriteriomn,
      isSortAscending: isSortAscending,
    );
  }

  void _sortAudioLst({
    required List<Audio> lstToSort,
    required AudioSortCriterion audioSortCriteriomn,
    required bool isSortAscending,
  }) {
    lstToSort.sort((a, b) {
      dynamic aValue;
      dynamic bValue;

      switch (audioSortCriteriomn) {
        case AudioSortCriterion.validVideoTitle:
          aValue = a.validVideoTitle;
          bValue = b.validVideoTitle;
          break;
        case AudioSortCriterion.audioDownloadDateTime:
          aValue = a.audioDownloadDateTime;
          bValue = b.audioDownloadDateTime;
          break;
        default:
          break;
      }

      int compareResult = aValue.compareTo(bValue);

      return isSortAscending ? compareResult : -compareResult;
    });
  }
}
