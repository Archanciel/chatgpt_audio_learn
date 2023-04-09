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

import '../constants.dart';
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

  AudioDownloadVM({bool isTest = false}) {
    _playlistHomePath = DirUtil.getPlaylistDownloadHomePath(isTest: isTest);
    // Should load all the playlists, not only the audio_learn or to_delete
    // playlist !
    _loadTemporaryUniquePlaylist();
  }

  void _loadTemporaryUniquePlaylist() async {
    String jsonPathFileName =
        '$_playlistHomePath${Platform.pathSeparator}$kUniquePlaylistTitle${Platform.pathSeparator}$kUniquePlaylistTitle.json';
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
    required Playlist playlistToDownload,
  }) async {
    _youtubeExplode = yt.YoutubeExplode();

    // get Youtube playlist
    Playlist currentPlaylist;
    String? playlistId;
    yt.Playlist youtubePlaylist;

    if (_listOfPlaylist.isNotEmpty) {
      int savedPlaylistIndex;
      Playlist savedPlaylist;

      savedPlaylistIndex = _listOfPlaylist
          .indexWhere((element) => element.url == playlistToDownload.url);

      if (savedPlaylistIndex == -1) {
        // playlist was never downloaded or was deleted and recreated
        playlistId = yt.PlaylistId.parsePlaylistId(playlistToDownload.url);
        youtubePlaylist = await _youtubeExplode.playlists.get(playlistId);

        currentPlaylist = await _obtainPlaylist(
          playlistToDownload: playlistToDownload,
          youtubePlaylist: youtubePlaylist,
        );

        // checking if current playlist was deleted and recreated
        savedPlaylistIndex = _listOfPlaylist
            .indexWhere((element) => element.title == currentPlaylist.title);

        if (savedPlaylistIndex != -1) {
          // current playlist was deleted and recreated since it has the
          // same title
          savedPlaylist = _listOfPlaylist[savedPlaylistIndex];
          currentPlaylist.downloadedAudioLst = savedPlaylist.downloadedAudioLst;
          currentPlaylist.playableAudioLst = savedPlaylist.playableAudioLst;
          _listOfPlaylist[savedPlaylistIndex] = currentPlaylist;
        }
      } else {
        // playlist was already downloaded and so is stored in
        // a playlist json file
        currentPlaylist = _listOfPlaylist[savedPlaylistIndex];
        playlistId = yt.PlaylistId.parsePlaylistId(currentPlaylist.url);
        youtubePlaylist = await _youtubeExplode.playlists.get(playlistId);
      }
    } else {
      // situation in which the app downloads playlists for the first
      // time
      playlistId = yt.PlaylistId.parsePlaylistId(playlistToDownload.url);
      youtubePlaylist = await _youtubeExplode.playlists.get(playlistId);

      currentPlaylist = await _obtainPlaylist(
        playlistToDownload: playlistToDownload,
        youtubePlaylist: youtubePlaylist,
      );
    }

    // get already downloaded audio file names
    String playlistDownloadFilePathName =
        currentPlaylist.getPlaylistDownloadFilePathName();

    final List<String> downloadedAudioValidVideoTitleLst =
        await _getPlaylistDownloadedAudioValidVideoTitleLst(
            playlistPathFileName: playlistDownloadFilePathName,
            uiPlaylist: currentPlaylist);

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

  Future<Playlist> _obtainPlaylist({
    required Playlist playlistToDownload,
    required yt.Playlist youtubePlaylist,
  }) async {
    Playlist savedPlaylist = playlistToDownload;
    _listOfPlaylist.add(savedPlaylist);

    savedPlaylist.id = youtubePlaylist.id.toString();

    final String playlistTitle = youtubePlaylist.title;
    savedPlaylist.title = playlistTitle;
    final String playlistDownloadPath =
        '$_playlistHomePath${Platform.pathSeparator}$playlistTitle';

    // ensure playlist audio download dir exists
    await DirUtil.createDirIfNotExist(pathStr: playlistDownloadPath);

    savedPlaylist.downloadPath = playlistDownloadPath;

    return savedPlaylist;
  }

  /// this method must be refactored
  Future<List<String>> _getPlaylistDownloadedAudioValidVideoTitleLst({
    required String playlistPathFileName,
    required Playlist uiPlaylist,
  }) async {
    bool jsonFileExists = await File(playlistPathFileName).exists();
    List<String> validAudioVideoTitleLst = [];

    if (jsonFileExists) {
      Playlist playlist = JsonDataService.loadFromFile(
          jsonPathFileName: playlistPathFileName, type: Playlist);
      List<Audio> playlistDownloadedAudioLst = playlist.downloadedAudioLst;

      for (Audio downloadedAudio in playlistDownloadedAudioLst) {
        validAudioVideoTitleLst.add(downloadedAudio.validVideoTitle);
      }

      uiPlaylist.downloadedAudioLst = playlist.downloadedAudioLst;
      uiPlaylist.playableAudioLst = playlist.playableAudioLst;
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

      // Vérifiez si le délai a été dépassé avant de mettre à jour la progression
      if (DateTime.now().difference(lastUpdate) >= updateInterval) {
        _updateDownloadProgress(totalBytesDownloaded / audioFileSize,
            totalBytesDownloaded - previousSecondBytesDownloaded);
        previousSecondBytesDownloaded = totalBytesDownloaded;
        lastUpdate = DateTime.now();
      }

      audioFileSink.add(byteChunk);
    }

    // Assurez-vous de mettre à jour la progression une dernière fois à 100% avant de terminer
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
