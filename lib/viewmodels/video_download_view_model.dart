// dart file located in lib\viewmodels

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/download_playlist.dart';
import '../models/downloaded_video.dart';
import '../utils/dir_util.dart';

class VideoDownloadViewModel extends ChangeNotifier {
  final List<DownloadedVideo> _downloadedVideoLst = [];
  List<DownloadedVideo> get downloadedVideoLst => _downloadedVideoLst;

  final YoutubeExplode _yt = YoutubeExplode();

  Future<void> downloadPlaylistVideos(
      DownloadPlaylist playlistToDownload) async {
    playlistToDownload.id =
        PlaylistId.parsePlaylistId(playlistToDownload.url) ?? '';
    final Playlist youtubePlaylist =
        await _yt.playlists.get(playlistToDownload.id);
    playlistToDownload.title = youtubePlaylist.title;
    String playlistDownloadHomePath =
        await DirUtil.getPlaylistDownloadHomePath();

    // works on S20, fails om emulator !
    playlistToDownload.downloadPath =
        '$playlistDownloadHomePath${Platform.pathSeparator}${playlistToDownload.title}';
    await DirUtil.createDirIfNotExist(pathStr: playlistToDownload.downloadPath);

    // does not solve the problem on emulator !
    // playlistToDownload.downloadPath =
    //     '${playlistDownloadHomePath}${Platform.pathSeparator}${playlistToDownload.title}';

    await for (Video video in _yt.playlists.getVideos(playlistToDownload.id)) {
      final bool alreadyDownloaded = _downloadedVideoLst
          .any((downloadedVideo) => downloadedVideo.id == video.id.toString());

      if (alreadyDownloaded) {
        continue;
      }

      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(video.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      String validAudioFileName =
          _replaceUnauthorizedDirOrFileNameChars(video.title);

      final String downloadVideoFilePathName =
          '${playlistToDownload.downloadPath}${Platform.pathSeparator}$validAudioFileName.mp3';

      // Download the DownloadedVideo file
      await _downloadAudioFile(
          video, audioStreamInfo, downloadVideoFilePathName);

      final downloadedVideo = DownloadedVideo(
        id: video.id.toString(),
        title: video.title,
        audioFilePath: downloadVideoFilePathName,
        audioDuration: video.duration,
        downloadDate: DateTime.now(),
      );

      playlistToDownload.addDownloadedVideo(downloadedVideo);

      notifyListeners();
    }
  }

  Future<void> _downloadAudioFile(
    Video video,
    AudioStreamInfo audioStreamInfo,
    String audioFilePathName,
  ) async {
    final IOSink audioFile = File(audioFilePathName).openWrite();
    final Stream<List<int>> stream =
        _yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(audioFile);
  }

  String _replaceUnauthorizedDirOrFileNameChars(String rawFileName) {
    // Replace '|' by ' if '|' is located at end of file name
    if (rawFileName.endsWith('|')) {
      rawFileName = rawFileName.substring(0, rawFileName.length - 1);
    }

    // Replace '||' by '_' since YoutubeDL replaces '||' by '_'
    rawFileName = rawFileName.replaceAll('||', '|');

    // Replace '//' by '_' since YoutubeDL replaces '//' by '_'
    rawFileName = rawFileName.replaceAll('//', '/');

    final charToReplace = {
      '\\': '',
      '/': '_', // since YoutubeDL replaces '/' by '_'
      ':': ' -', // since YoutubeDL replaces ':' by ' -'
      '*': ' ',
      // '.': '', point is not illegal in file name
      '?': '',
      '"': "'", // since YoutubeDL replaces " by '
      '<': '',
      '>': '',
      '|': '_', // since YoutubeDL replaces '|' by '_'
      // "'": '_', apostrophe is not illegal in file name
    };

    // Replace all multiple characters in a string based on translation table created by dictionary
    String validFileName = rawFileName;
    charToReplace.forEach((key, value) {
      validFileName = validFileName.replaceAll(key, value);
    });

    // Since YoutubeDL replaces '?' by ' ', determining if a video whose title
    // ends with '?' has already been downloaded using
    // replaceUnauthorizedDirOrFileNameChars(videoTitle) + '.mp3' can be executed
    // if validFileName.trim() is NOT done.
    return validFileName.trim();
  }
}
