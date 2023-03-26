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
        playlist.addPlayableAudio(audio);
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

  void addPlayableAudio(Audio playableAudio) {
    playableAudio.enclosingPlaylist = this;
    playableAudioLst.add(playableAudio);
  }

  void removePlayableAudio(Audio playableAudio) {
    playableAudioLst.remove(playableAudio);
  }

  @override
  String toString() {
    return title;
  }
}
