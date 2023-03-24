// dart file located in lib\viewmodels

import 'dart:io';

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
  yt.YoutubeExplode _youtubeExplode = yt.YoutubeExplode();

  // setter used by test only !
  set youtubeExplode(yt.YoutubeExplode youtubeExplode) =>
      _youtubeExplode = youtubeExplode;

  final Directory _audioDownloadDir = Directory('/storage/emulated/0/Download');

  @override
  Future<void> downloadPlaylistAudios({
    required Playlist playlistToDownload,
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
    Playlist playlistToDownload,
    Future<void> Function(
      yt.Video youtubeVideo,
      yt.AudioStreamInfo audioStreamInfo,
      Audio audio,
    )
        downloadAudioFileFunction,
  ) async {
    // get Youtube playlist

    final String? playlistId =
        yt.PlaylistId.parsePlaylistId(playlistToDownload.url);
    final yt.Playlist youtubePlaylist =
        await _youtubeExplode.playlists.get(playlistId);

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

      yt.Video vid = await _youtubeExplode.videos.get('oxXpB9pSETo');
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
      playlistToDownload.addDownloadedAudio(audio);

      notifyListeners();
    }
  }

  Future<void> downloadPlaylistAudioWithJustAudio(
    Playlist playlistToDownload,
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
