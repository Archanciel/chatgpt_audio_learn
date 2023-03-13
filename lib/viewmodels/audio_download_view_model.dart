// dart file located in lib\viewmodels

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:audioplayers/audioplayers.dart';

import '../constants.dart';
import '../models/audio.dart';
import '../models/download_playlist.dart';
import '../utils/dir_util.dart';

class AudioDownloadViewModel extends ChangeNotifier {
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
      String audioFilePathName,
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

    // get already downloaded audio file names
    final List<String> downloadedAudioFileNameLst =
        getDownloadedAudioNameLst(pathStr: playlistDownloadPath);

    await for (Video youtubeVideo in _yt.playlists.getVideos(playlistId)) {
      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(youtubeVideo.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final String audioTitle = youtubeVideo.title;
      String validAudioFileName =
          replaceUnauthorizedDirOrFileNameChars(youtubeVideo.title);
      final String audioFilePathName =
          '$playlistDownloadPath/$validAudioFileName.mp3';

      final bool alreadyDownloaded = downloadedAudioFileNameLst
          .any((fileName) => fileName.contains(validAudioFileName));

      if (alreadyDownloaded) {
        print('$audioTitle already downloaded **********');
        final Audio audio = Audio(
          title: audioTitle,
          filePathName: audioFilePathName,
          audioPlayer: AudioPlayer(),
        );

        audioLst.add(audio);
        notifyListeners();
        continue;
      }

      final Duration? audioDuration = youtubeVideo.duration;

      Stopwatch stopwatch = Stopwatch()..start();

      // Download the audio file
      await downloadAudioFileFunction(
        youtubeVideo,
        audioStreamInfo,
        audioFilePathName,
      );

      stopwatch.stop();

      final Audio audio = Audio(
        title: audioTitle,
        filePathName: audioFilePathName,
        downloadDuration: stopwatch.elapsed,
        audioDuration: audioDuration!,
        audioFileSize: await File(audioFilePathName).length(),
        audioPlayer: AudioPlayer(),
      );

      audioLst.add(audio);

      notifyListeners();
    }
  }

  Future<void> downloadPlaylistAudioWithJustAudio(
    DownloadPlaylist playlistToDownload,
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

    // get already downloaded audio file names
    final List<String> downloadedAudioFileNameLst =
        getDownloadedAudioNameLst(pathStr: playlistDownloadPath);

    await for (Video youtubeVideo in _yt.playlists.getVideos(playlistId)) {
      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(youtubeVideo.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final String audioTitle = youtubeVideo.title;
      String validAudioFileName =
          replaceUnauthorizedDirOrFileNameChars(youtubeVideo.title);
      final String audioFilePathName =
          '$playlistDownloadPath/${validAudioFileName}.mp3';

      final bool alreadyDownloaded = downloadedAudioFileNameLst
          .any((fileName) => fileName.contains(validAudioFileName));

      if (alreadyDownloaded) {
        print('$audioTitle already downloaded **********');
        final Audio audio = Audio(
          title: audioTitle,
          filePathName: audioFilePathName,
          audioPlayer: AudioPlayer(),
        );

        audioLst.add(audio);
        notifyListeners();
        continue;
      }

      final Duration? audioDuration = youtubeVideo.duration;

      final Audio audio = Audio(
        title: audioTitle,
        audioDuration: audioDuration!,
        filePathName: audioFilePathName,
        audioPlayer: AudioPlayer(),
      );

      audioLst.add(audio);

      // Download the audio file
      await _downloadAudioFileYoutube(
        youtubeVideo,
        audioStreamInfo,
        audioFilePathName,
      );
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

  Future<void> _downloadAudioFileYoutube(
    Video youtubeVideo,
    AudioStreamInfo audioStreamInfo,
    String audioFilePathName,
  ) async {
    final IOSink audioFile = File(audioFilePathName).openWrite();
    final Stream<List<int>> stream =
        _yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(audioFile);
  }

  Future<void> _downloadAudioFileDio(
    Video youtubeVideo,
    AudioStreamInfo audioStreamInfo,
    String audioFilePathName,
  ) async {
    // Création d'un objet `Dio` pour télécharger le fichier audio
    final dio = Dio();

    // Téléchargement du fichier audio
    await dio.download(audioStreamInfo.url.toString(), audioFilePathName);
  }

  String replaceUnauthorizedDirOrFileNameChars(String rawFileName) {
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
