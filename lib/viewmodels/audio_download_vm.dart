// dart file located in lib\viewmodels

import 'dart:async';
import 'dart:io';

import 'package:chatgpt_audio_learn/services/json_data_service.dart';
import 'package:flutter/material.dart';

// importing youtube_explode_dart as yt enables to name the app Model
// playlist class as Playlist so it does not conflict with
// youtube_explode_dart Playlist class name.
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import 'package:audioplayers/audioplayers.dart';

import '../constants_old.dart';
import '../models/audio.dart';
import '../models/playlist.dart';
import '../utils/dir_util.dart';

class AudioDownloadVM extends ChangeNotifier {
  List<Playlist> _listOfPlaylist = [];
  List<Playlist> get listOfPlaylist => _listOfPlaylist;

  late yt.YoutubeExplode _youtubeExplode;
  // setter used by test only !
  set youtubeExplode(yt.YoutubeExplode youtubeExplode) =>
      _youtubeExplode = youtubeExplode;

  late String _playlistHomePath;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  double _downloadProgress = 0.0;
  double get downloadProgress => _downloadProgress;

  int _lastSecondDownloadSpeed = 0;
  int get lastSecondDownloadSpeed => _lastSecondDownloadSpeed;

  late Audio _currentDownloadingAudio;
  Audio get currentDownloadingAudio => _currentDownloadingAudio;

  bool _isHighQuality = false;
  bool get isHighQuality => _isHighQuality;

  /// Passing a testPlayListTitle has the effect that the windows
  /// test directory is used as playlist root directory. Otherwise,
  /// the windows or smartphone audio root directory is used and
  /// the value of the kUniquePlaylistTitle constant is used to
  /// load the playlist json file.
  AudioDownloadVM({String? testPlayListTitle}) {
    _playlistHomePath =
        DirUtil.getPlaylistDownloadHomePath(isTest: testPlayListTitle != null);
    // Should load all the playlists, not only the audio_learn or to_delete
    // playlist !
    _loadTemporaryUniquePlaylist(testPlayListTitle: testPlayListTitle);
  }

  void _loadTemporaryUniquePlaylist({String? testPlayListTitle}) async {
    String playListTitle = testPlayListTitle ?? kUniquePlaylistTitle;
    String jsonPathFileName =
        '$_playlistHomePath${Platform.pathSeparator}$playListTitle${Platform.pathSeparator}$playListTitle.json';
    dynamic currentPlaylist = JsonDataService.loadFromFile(
        jsonPathFileName: jsonPathFileName, type: Playlist);
    if (currentPlaylist != null) {
      // is null if json file not exist
      _listOfPlaylist.add(currentPlaylist);
    } else {
      _listOfPlaylist = [];
    }

    notifyListeners();
  }

  /// Currently not used.
  void addNewPlaylist(Playlist playlist) async {
    _listOfPlaylist.add(playlist);
    JsonDataService.saveListToFile(
        jsonPathFileName: _playlistHomePath, data: _listOfPlaylist);

    notifyListeners();
  }

  /// Downloads the audio of the videos referenced in the passed
  /// playlist.
  Future<void> downloadPlaylistAudios({
    required String playlistUrl,
  }) async {
    _youtubeExplode = yt.YoutubeExplode();

    // get Youtube playlist
    Playlist currentPlaylist;
    String? playlistId;
    yt.Playlist youtubePlaylist;

    playlistId = yt.PlaylistId.parsePlaylistId(playlistUrl);
    youtubePlaylist = await _youtubeExplode.playlists.get(playlistId);

    int existingPlaylistIndex =
        _listOfPlaylist.indexWhere((element) => element.url == playlistUrl);

    if (existingPlaylistIndex == -1) {
      // playlist was never downloaded or was deleted and recreated, which
      // associates it to a new url

      currentPlaylist = await _createPlaylist(
        playlistUrl: playlistUrl,
        youtubePlaylist: youtubePlaylist,
      );

      // checking if current playlist was deleted and recreated
      existingPlaylistIndex = _listOfPlaylist
          .indexWhere((element) => element.title == currentPlaylist.title);

      if (existingPlaylistIndex != -1) {
        // current playlist was deleted and recreated since it is referenced
        // in the _listOfPlaylist and has the same title than the recreated
        // polaylist
        Playlist existingPlaylist = _listOfPlaylist[existingPlaylistIndex];
        currentPlaylist.downloadedAudioLst =
            existingPlaylist.downloadedAudioLst;
        currentPlaylist.playableAudioLst = existingPlaylist.playableAudioLst;
        _listOfPlaylist[existingPlaylistIndex] = currentPlaylist;
      }
    } else {
      // playlist was already downloaded and so is stored in
      // a playlist json file
      currentPlaylist = _listOfPlaylist[existingPlaylistIndex];
    }

    // get already downloaded audio file names
    String playlistDownloadFilePathName =
        currentPlaylist.getPlaylistDownloadFilePathName();

    final List<String> downloadedAudioValidVideoTitleLst =
        await _getPlaylistDownloadedAudioValidVideoTitleLst(
            currentPlaylist: currentPlaylist);

    await for (yt.Video youtubeVideo
        in _youtubeExplode.playlists.getVideos(playlistId)) {
      final Duration? audioDuration = youtubeVideo.duration;
      DateTime? audioUploadDate =
          (await _youtubeExplode.videos.get(youtubeVideo.id.value)).uploadDate;

      audioUploadDate ??= DateTime(00, 1, 1);

      final Audio audio = Audio(
        enclosingPlaylist: currentPlaylist,
        originalVideoTitle: youtubeVideo.title,
        videoUrl: youtubeVideo.url,
        audioDownloadDateTime: DateTime.now(),
        videoUploadDate: audioUploadDate,
        audioDuration: audioDuration!,
      );

      audio.audioPlayer = AudioPlayer();

      final bool alreadyDownloaded = downloadedAudioValidVideoTitleLst.any(
          (validVideoTitle) => validVideoTitle.contains(audio.validVideoTitle));

      if (alreadyDownloaded) {
        // print('${audio.audioFileName} already downloaded');

        // avoids that the last downloaded audio download
        // informations remain displayed until all videos referenced
        // in the playlist have been handled.
        if (_isDownloading) {
          _setIsDownloading(isDownloading: false);
        }

        continue;
      }

      Stopwatch stopwatch = Stopwatch()..start();

      if (!_isDownloading) {
        _setIsDownloading(isDownloading: true);
      }

      // Download the audio file
      await _downloadAudioFile(
        youtubeVideoId: youtubeVideo.id,
        audio: audio,
      );

      stopwatch.stop();

      audio.downloadDuration = stopwatch.elapsed;

      currentPlaylist.addDownloadedAudio(audio);
      currentPlaylist.insertAtStartPlayableAudio(audio);

      JsonDataService.saveToFile(
        model: currentPlaylist,
        path: playlistDownloadFilePathName,
      );

      notifyListeners();
    }

    _setIsDownloading(isDownloading: false);

    _youtubeExplode.close();

    notifyListeners();
  }

  void setAudioQuality({required bool isHighQuality}) {
    _isHighQuality = isHighQuality;

    notifyListeners();
  }

  Future<Playlist> _createPlaylist({
    required String playlistUrl,
    required yt.Playlist youtubePlaylist,
  }) async {
    Playlist playlist = Playlist(url: playlistUrl);
    _listOfPlaylist.add(playlist);

    playlist.id = youtubePlaylist.id.toString();

    final String playlistTitle = youtubePlaylist.title;
    playlist.title = playlistTitle;
    final String playlistDownloadPath =
        '$_playlistHomePath${Platform.pathSeparator}$playlistTitle';

    // ensure playlist audio download dir exists
    await DirUtil.createDirIfNotExist(pathStr: playlistDownloadPath);

    playlist.downloadPath = playlistDownloadPath;

    return playlist;
  }

  /// Returns an empty list if the passed playlist was created or
  /// recreated.
  Future<List<String>> _getPlaylistDownloadedAudioValidVideoTitleLst({
    required Playlist currentPlaylist,
  }) async {
    List<Audio> playlistDownloadedAudioLst = currentPlaylist.downloadedAudioLst;
    List<String> validAudioVideoTitleLst = [];

    for (Audio downloadedAudio in playlistDownloadedAudioLst) {
      validAudioVideoTitleLst.add(downloadedAudio.validVideoTitle);
    }

    return validAudioVideoTitleLst;
  }

  Future<void> _downloadAudioFile({
    required yt.VideoId youtubeVideoId,
    required Audio audio,
  }) async {
    _currentDownloadingAudio = audio;
    final yt.StreamManifest streamManifest =
        await _youtubeExplode.videos.streamsClient.getManifest(youtubeVideoId);

    final yt.AudioOnlyStreamInfo audioStreamInfo;

    if (_isHighQuality) {
      audioStreamInfo = streamManifest.audioOnly.withHighestBitrate();
    } else {
      audioStreamInfo = streamManifest.audioOnly.first;
    }

    final int audioFileSize = audioStreamInfo.size.totalBytes;
    audio.audioFileSize = audioFileSize;

    await _youtubeDownloadAudioFile(audio, audioStreamInfo, audioFileSize);
  }

  Future<void> _youtubeDownloadAudioFile(Audio audio, yt.AudioOnlyStreamInfo audioStreamInfo, int audioFileSize) async {
    final File file = File(audio.filePathName);
    final IOSink audioFileSink = file.openWrite();
    final Stream<List<int>> audioStream =
        _youtubeExplode.videos.streamsClient.get(audioStreamInfo);
    int totalBytesDownloaded = 0;
    int previousSecondBytesDownloaded = 0;
    
    Duration updateInterval = const Duration(seconds: 1);
    DateTime lastUpdate = DateTime.now();
    Timer timer = Timer.periodic(updateInterval, (timer) {
      if (DateTime.now().difference(lastUpdate) >= updateInterval) {
        _updateDownloadProgress(totalBytesDownloaded / audioFileSize,
            totalBytesDownloaded - previousSecondBytesDownloaded);
        previousSecondBytesDownloaded = totalBytesDownloaded;
        lastUpdate = DateTime.now();
      }
    });
    
    await for (var byteChunk in audioStream) {
      totalBytesDownloaded += byteChunk.length;
    
      // Vérifiez si le délai a été dépassé avant de mettre à jour la
      // progression
      if (DateTime.now().difference(lastUpdate) >= updateInterval) {
        _updateDownloadProgress(totalBytesDownloaded / audioFileSize,
            totalBytesDownloaded - previousSecondBytesDownloaded);
        previousSecondBytesDownloaded = totalBytesDownloaded;
        lastUpdate = DateTime.now();
      }
    
      audioFileSink.add(byteChunk);
    }
    
    // Assurez-vous de mettre à jour la progression une dernière fois
    // à 100% avant de terminer
    _updateDownloadProgress(1.0, 0);
    
    // Annulez le Timer pour éviter les appels inutiles
    timer.cancel();
    
    await audioFileSink.flush();
    await audioFileSink.close();
  }

  void _updateDownloadProgress(double progress, int lastSecondDownloadSpeed) {
    _downloadProgress = progress;
    _lastSecondDownloadSpeed = lastSecondDownloadSpeed;

    notifyListeners();
  }

  void _setIsDownloading({required bool isDownloading}) {
    _isDownloading = isDownloading;

    notifyListeners();
  }
}
