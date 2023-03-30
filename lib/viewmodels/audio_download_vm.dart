// dart file located in lib\viewmodels

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

  yt.YoutubeExplode _youtubeExplode = yt.YoutubeExplode();

  // setter used by test only !
  set youtubeExplode(yt.YoutubeExplode youtubeExplode) =>
      _youtubeExplode = youtubeExplode;

  String _playlistHomePath = DirUtil.getPlaylistDownloadHomePath();

  AudioDownloadVM() {
    // should load list of playlist !
    loadPlaylist();
  }

  void loadPlaylist() async {
    String jsonPathFileName =
        '$_playlistHomePath${Platform.pathSeparator}$kUniquePlaylistTitle${Platform.pathSeparator}$kUniquePlaylistTitle.json';
    dynamic currentPlaylist = JsonDataService.loadFromFile(
        jsonPathFileName: jsonPathFileName, type: Playlist);
    if (currentPlaylist != null) {
      // is null if json file not exist
      _listOfPlaylist.add(currentPlaylist);
      notifyListeners();
    }
  }

  void addListItem(Playlist listItem) async {
    _listOfPlaylist.add(listItem);
    JsonDataService.saveListToFile(
        jsonPathFileName: _playlistHomePath, data: _listOfPlaylist);

    notifyListeners();
  }

  Future<void> downloadPlaylistAudios({
    required Playlist playlistToDownload,
  }) async {
    // get Youtube playlist

    await downloadPlaylistAudio(
      playlistToDownload,
      _downloadAudioFileYoutube,
    );
  }

  Future<void> downloadPlaylistAudio(
    Playlist playlistToDownload,
    Future<void> Function(
      yt.Video youtubeVideo,
      yt.AudioStreamInfo audioStreamInfo,
      Audio audio,
    )
        downloadAudioFileFunction,
  ) async {
    Playlist savedPlaylist;
    String? playlistId;
    yt.Playlist youtubePlaylist;

    if (_listOfPlaylist.isNotEmpty) {
      savedPlaylist = _listOfPlaylist.firstWhere(
        (element) => element.url == playlistToDownload.url,
      );

      // playlist was already downloaded and  is stored in
      // a playlist json file

      playlistId = yt.PlaylistId.parsePlaylistId(savedPlaylist.url);
      youtubePlaylist = await _youtubeExplode.playlists.get(playlistId);
    } else {
      // playlist was never downloaded

      savedPlaylist = playlistToDownload;
      _listOfPlaylist.add(savedPlaylist);
      playlistId = yt.PlaylistId.parsePlaylistId(savedPlaylist.url);
      youtubePlaylist = await _youtubeExplode.playlists.get(playlistId);

      // define playlist audio download dir

      final String audioDownloadPath = DirUtil.getPlaylistDownloadHomePath();
      final String playlistTitle = youtubePlaylist.title;
      savedPlaylist.title = playlistTitle;
      final String playlistDownloadPath =
          '$audioDownloadPath${Platform.pathSeparator}$playlistTitle';

      // ensure playlist audio download dir exists
      await DirUtil.createDirIfNotExist(pathStr: playlistDownloadPath);

      savedPlaylist.downloadPath = playlistDownloadPath;
    }

    // get already downloaded audio file names
    String playlistDownloadFilePathName =
        savedPlaylist.getPlaylistDownloadFilePathName();

    final List<String> downloadedAudioValidVideoTitleLst =
        await getPlaylistDownloadedAudioValidVideoTitleLst(
            playlistPathFileName: playlistDownloadFilePathName,
            uiPlaylist: savedPlaylist);

    // get Youtube playlist

    await for (yt.Video youtubeVideo
        in _youtubeExplode.playlists.getVideos(playlistId)) {
      final yt.StreamManifest streamManifest = await _youtubeExplode
          .videos.streamsClient
          .getManifest(youtubeVideo.id);
      final yt.AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final Duration? audioDuration = youtubeVideo.duration;
      DateTime? audioUploadDate =
          (await _youtubeExplode.videos.get(youtubeVideo.id.value)).uploadDate;

      audioUploadDate ??= DateTime(00, 1, 1);

      final Audio audio = Audio(
        enclosingPlaylist: savedPlaylist,
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
        print('${audio.audioFileName} already downloaded');
        continue;
      }

      Stopwatch stopwatch = Stopwatch()..start();

      // Download the audio file
      await _downloadAudioFileYoutube(
        youtubeVideo,
        audioStreamInfo,
        audio,
      );

      stopwatch.stop();

      audio.downloadDuration = stopwatch.elapsed;

      _listOfPlaylist[0].addDownloadedAudio(audio);
      _listOfPlaylist[0].addPlayableAudio(audio);

      notifyListeners();
    }

    JsonDataService.saveToFile(
      model: savedPlaylist,
      path: playlistDownloadFilePathName,
    );

    notifyListeners();
  }

  /// this method must be refactored
  Future<List<String>> getPlaylistDownloadedAudioValidVideoTitleLst({
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

  Future<void> _downloadAudioFileYoutube(
    yt.Video youtubeVideo,
    yt.AudioStreamInfo audioStreamInfo,
    Audio audio,
  ) async {
    var file = File(audio.filePathName);
    final IOSink audioFile = file.openWrite();
    final Stream<List<int>> stream =
        _youtubeExplode.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(audioFile);

    audio.audioFileSize = await file.length();
  }
}
