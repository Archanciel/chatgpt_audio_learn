import 'audio.dart';

/// This class
class Playlist {
  String id = '';
  String title = '';
  String url;
  String downloadPath = '';

  // Contains audio videos currently referrenced in the Youtube
  // playlist.
  final List<Audio> _playlistAudioLst = [];

  // Contains the audios once referenced in the Youtube playlist
  // which were downloaded.
  final List<Audio> _downloadedAudioLst = [];

  // Contains the downloaded audios currently available on the
  // device.
  final List<Audio> _playableAudioLst = [];
  List<Audio> get playableAudios => _playableAudioLst;

  Playlist({
    required this.url,
  });

  void addDownloadedAudio(Audio downloadedAudio) {
    downloadedAudio.enclosingPlaylist = this;
    _downloadedAudioLst.add(downloadedAudio);
  }

  void removeDownloadedAudio(Audio downloadedAudio) {
    if (downloadedAudio.enclosingPlaylist == this) {
      downloadedAudio.enclosingPlaylist = null;
    }
    _downloadedAudioLst.remove(downloadedAudio);
  }

  void addPlayableAudio(Audio playableAudio) {
    playableAudio.enclosingPlaylist = this;
    _playableAudioLst.add(playableAudio);
  }

  void removePlayableAudio(Audio playableAudio) {
    _playableAudioLst.remove(playableAudio);
  }

  @override
  String toString() {
    return '$title';
  }
}
