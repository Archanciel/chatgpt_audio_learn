// dart file located in lib\viewmodels

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/audio.dart';
import '../models/download_playlist.dart';
import '../utils/dir_util.dart';

class AudioDownloadViewModel extends ChangeNotifier {
  final List<Audio> _audioLst = [];
  List<Audio> get audioLst => _audioLst;

  final YoutubeExplode _yt = YoutubeExplode();

  final Directory _audioDownloadDir = Directory('/storage/emulated/0/Download');

  Future<void> downloadPlaylistAudios(
      DownloadPlaylist playlistToDownload) async {
    // get Youtube playlist

    final String? playlistId =
        PlaylistId.parsePlaylistId(playlistToDownload.url);
    final Playlist youtubePlaylist = await _yt.playlists.get(playlistId);

    // determine playlist audio download dir

    final String audioDownloadPath =
        await DirUtil.getPlaylistDownloadHomePath();
    final String playlistTitle = youtubePlaylist.title;
    playlistToDownload.title = playlistTitle;
    final String playlistDownloadPath =
        '$audioDownloadPath${Platform.pathSeparator}$playlistTitle';

    // ensure playlist audio download dir exists
    await DirUtil.createDirIfNotExist(pathStr: playlistDownloadPath);

    // get already downloaded audio file names
    final List<String> downloadedAudioFileNameLst =
        getDownloadedAudioNameLst(pathStr: playlistDownloadPath);

    await for (Video video in _yt.playlists.getVideos(playlistId)) {
      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(video.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final String audioTitle = video.title;
      String validAudioFileName =
          _replaceUnauthorizedDirOrFileNameChars(video.title);
      final String audioFilePathName =
          '$playlistDownloadPath/${validAudioFileName}.mp3';

      final bool alreadyDownloaded = downloadedAudioFileNameLst
          .any((fileName) => fileName.contains(validAudioFileName));

      if (alreadyDownloaded) {
        print('$audioTitle already downloaded');
        final Audio audio = Audio(
          title: audioTitle,
          filePath: audioFilePathName,
          audioPlayer: AudioPlayer(),
        );

        _audioLst.add(audio);
        notifyListeners();
        continue;
      }

      final Duration? audioDuration = video.duration;

      final Audio audio = Audio(
        title: audioTitle,
        duration: audioDuration!,
        filePath: audioFilePathName,
        audioPlayer: AudioPlayer(),
      );

      _audioLst.add(audio);

      // Download the audio file
      await _downloadAudioFile(video, audioStreamInfo, audioFilePathName);
      // Do something with the downloaded file

      notifyListeners();
    }
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

  Future<void> _downloadAudioFile(
    Video video,
    AudioStreamInfo audioStreamInfo,
    String filePath,
  ) async {
    final IOSink output = File(filePath).openWrite();
    final Stream<List<int>> stream =
        _yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(output);
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
