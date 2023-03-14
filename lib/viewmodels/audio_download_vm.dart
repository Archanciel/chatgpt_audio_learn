// dart file located in lib\viewmodels

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:audioplayers/audioplayers.dart';

import '../constants.dart';
import '../models/audio.dart';
import '../models/download_playlist.dart';
import '../utils/dir_util.dart';

class AudioDownloadVM extends ChangeNotifier {
  YoutubeExplode _yt = YoutubeExplode();

  // setter used by test only !
  set yt(YoutubeExplode yt) => _yt = yt;

  final Directory _audioDownloadDir = Directory('/storage/emulated/0/Download');

  @override
  final List<Audio> audioLst = [];

  @override
  Future<void> downloadPlaylistAudios({
    required DownloadPlaylist playlistToDownload,
    required AudioDownloadViewModelType audioDownloadViewModelType,
  }) async {
    // get Youtube playlist

    switch (audioDownloadViewModelType) {
      case AudioDownloadViewModelType.youtube:
        {
          await downloadPlaylistAudio(
            playlistToDownload,
            _downloadAudioFileYoutube,
          );
          break;
        }
      case AudioDownloadViewModelType.justAudio:
        {
          await downloadPlaylistAudioWithJustAudio(playlistToDownload);
          break;
        }
    }
  }

  Future<void> downloadPlaylistAudio(
    DownloadPlaylist playlistToDownload,
    Future<void> Function(
      Video youtubeVideo,
      AudioStreamInfo audioStreamInfo,
      Audio audio,
    )
        downloadAudioFileFunction,
  ) async {
    // get Youtube playlist

    final String? playlistId =
        PlaylistId.parsePlaylistId(playlistToDownload.url);
    final Playlist youtubePlaylist = await _yt.playlists.get(playlistId);

    // define playlist audio download dir

    final String audioDownloadPath =
        await DirUtil.getPlaylistDownloadHomePath();
    final String playlistTitle = youtubePlaylist.title;
    playlistToDownload.title = playlistTitle;
    final String playlistDownloadPath =
        '$audioDownloadPath${Platform.pathSeparator}$playlistTitle';

    // ensure playlist audio download dir exists
    await DirUtil.createDirIfNotExist(pathStr: playlistDownloadPath);

    playlistToDownload.downloadPath = playlistDownloadPath;

    // get already downloaded audio file names
    final List<String> downloadedAudioFileNameLst =
        getDownloadedAudioNameLst(pathStr: playlistDownloadPath);

    await for (Video youtubeVideo in _yt.playlists.getVideos(playlistId)) {
      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(youtubeVideo.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final Duration? audioDuration = youtubeVideo.duration;
      DateTime? audioUploadDate = youtubeVideo.uploadDate;

      audioUploadDate ??= DateTime(00, 1, 1);

      final Audio audio = Audio(
        enclosingPlaylist: playlistToDownload,
        originalVideoTitle: youtubeVideo.title,
        videoUrl: youtubeVideo.url,
        audioDownloadDate: DateTime.now(),
        videoUploadDate: audioUploadDate,
        audioDuration: audioDuration!,
        audioPlayer: AudioPlayer(),
      );

      final bool alreadyDownloaded = downloadedAudioFileNameLst
          .any((fileName) => fileName.contains(audio.validVideoTitle));

      if (alreadyDownloaded) {
        print('${audio.fileName} already downloaded');
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

      audioLst.add(audio);

      notifyListeners();
    }
  }

  Future<void> downloadPlaylistAudioWithJustAudio(
    DownloadPlaylist playlistToDownload,
  ) async {
    // to code ...
  }

  List<String> getDownloadedAudioNameLst({
    required String pathStr,
  }) {
    Directory directory = Directory(pathStr);
    List<FileSystemEntity> files = directory.listSync();

    List<String> fileNames = [];

    for (FileSystemEntity file in files) {
      if (file is File) {
        fileNames.add(file.path.split('/').last);
      }
    }

    return fileNames;
  }

  Future<void> _downloadAudioFileYoutube(
    Video youtubeVideo,
    AudioStreamInfo audioStreamInfo,
    Audio audio,
  ) async {
    var file = File(audio.filePathName);
    final IOSink audioFile = file.openWrite();
    final Stream<List<int>> stream =
        _yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(audioFile);

    audio.audioFileSize = await file.length();
  }
}
