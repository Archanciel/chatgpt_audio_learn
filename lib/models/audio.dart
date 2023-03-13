// dart file located in lib\models

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatgpt_audio_learn/models/download_playlist.dart';
import 'package:intl/intl.dart';

class Audio {
  static DateFormat downloadDatePrefixFormatter = DateFormat('yyMMdd');
  static DateFormat uploadDateSuffixFormatter = DateFormat(' y-MM-dd');

  final DownloadPlaylist playlist;
  final String title;
  final DateTime downloadDate;
  final DateTime uploadDate;
  final String fileName;
  final Duration? audioDuration;
  int audioFileSize = 0;

  late Duration _downloadDuration;
  Duration get downloadDuration => _downloadDuration;
  set downloadDuration(Duration downloadDuration) {
    _downloadDuration = downloadDuration;
    downloadSpeed = (audioFileSize == 0)
        ? 0.0
        : audioFileSize / _downloadDuration.inSeconds;
  }

  late double downloadSpeed;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    _isPaused = false;
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  AudioPlayer audioPlayer;

  Audio({
    required this.playlist,
    required this.title,
    required this.downloadDate,
    required this.uploadDate,
    this.audioDuration,
    required this.audioPlayer,
  }) : fileName =
            '${buildDownloadDatePrefix(downloadDate)}${replaceUnauthorizedDirOrFileNameChars(title)}${buildUploadDateSuffix(uploadDate)}.mp3';

  void invertPaused() {
    _isPaused = !_isPaused;
  }

  String get filePathName {
    return '${playlist.downloadPath}${Platform.pathSeparator}$fileName';
  }

  static String buildDownloadDatePrefix(DateTime downloadDate) {
    String formattedDateStr = downloadDatePrefixFormatter.format(downloadDate);

    return '$formattedDateStr-';
  }

  static String buildUploadDateSuffix(DateTime uploadDate) {
    String formattedDateStr = uploadDateSuffixFormatter.format(uploadDate);

    return formattedDateStr;
  }

  static String replaceUnauthorizedDirOrFileNameChars(String rawFileName) {
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
