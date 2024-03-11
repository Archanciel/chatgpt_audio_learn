import 'package:json_annotation/json_annotation.dart';
import 'dart:io';

import 'audio_json.dart';

part 'playlist_json.g.dart';

@JsonSerializable()
class PlaylistJson {
  String id = '';
  String title = '';
  String url;
  String downloadPath = '';
  bool isSelected;

  // Contains audio videos currently referrenced in the Youtube
  // playlist.
  final List<AudioJson> _youtubePlaylistAudioLst = [];
  List<AudioJson> get youtubePlaylistAudioLst => _youtubePlaylistAudioLst;

  // Contains the audios once referenced in the Youtube playlist
  // which were downloaded.
  List<AudioJson> downloadedAudioLst = [];

  // Contains the downloaded audios currently available on the
  // device.
  List<AudioJson> playableAudioLst = [];

  PlaylistJson({
    required this.url,
    this.isSelected = false,
  });

  // Factory pour la désérialisation
  factory PlaylistJson.fromJson(Map<String, dynamic> json) => _$PlaylistJsonFromJson(json);

  // Méthode pour la sérialisation
  Map<String, dynamic> toJson() => _$PlaylistJsonToJson(this);

  void addDownloadedAudio(AudioJson downloadedAudio) {
    downloadedAudio.enclosingPlaylist = this;
    downloadedAudioLst.add(downloadedAudio);
  }

  void removeDownloadedAudio(AudioJson downloadedAudio) {
    if (downloadedAudio.enclosingPlaylist == this) {
      downloadedAudio.enclosingPlaylist = null;
    }
    downloadedAudioLst.remove(downloadedAudio);
  }

  /// Used when uploading the Playlist json file. Since the
  /// json file contains the playable audio list in the right
  /// order, using add and not insert maintains the right order !
  void addPlayableAudio(AudioJson playableAudio) {
    playableAudio.enclosingPlaylist = this;
    playableAudioLst.add(playableAudio);
  }

  /// Used by DownloadAudioVM to add newly downloaded audio
  /// at the head of the playable list.
  void insertAtStartPlayableAudio(AudioJson playableAudio) {
    playableAudio.enclosingPlaylist = this;
    playableAudioLst.insert(0, playableAudio);
  }

  void removePlayableAudio(AudioJson playableAudio) {
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
    required List<AudioJson> lstToSort,
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
