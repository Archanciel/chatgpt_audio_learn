// dart file located in lib\models

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:intl/intl.dart';

/// Contains informations of the audio extracted from the video
/// referenced in the enclosing playlist. In fact, the audio is
/// directly downloaded from Youtube.
class Audio {
  static DateFormat downloadDatePrefixFormatter = DateFormat('yyMMdd');
  static DateFormat uploadDateSuffixFormatter = DateFormat('yy-MM-dd');

  // Playlist in which the video is referenced
  Playlist? enclosingPlaylist;

  // Video title displayed on Youtube
  final String originalVideoTitle;

  // Video title which does not contain invalid characters which
  // would cause the audio file name to genertate an file creation
  // exception
  final String validVideoTitle;

  // Url referencing the video from which rhe audio was extracted
  final String videoUrl;

  // Audio download date
  final DateTime audioDownloadDate;

  // Date at which the video containing the audio was added on
  // Youtube
  final DateTime videoUploadDate;

  // Stored audio file name
  final String fileName;

  // Duration of downloaded audio
  final Duration? audioDuration;

  // Audio file size in bytes
  int audioFileSize = 0;

  // Duration in which the audio was downloaded
  late Duration _downloadDuration;
  Duration get downloadDuration => _downloadDuration;
  set downloadDuration(Duration downloadDuration) {
    _downloadDuration = downloadDuration;
    downloadSpeed = (audioFileSize == 0)
        ? 0.0
        : audioFileSize / _downloadDuration.inSeconds;
  }

  // Speed at which the audio was downloaded in bytes per second
  late double downloadSpeed;

  // State of the audio

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    _isPaused = false;
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  // AudioPlayer of the current audio
  AudioPlayer audioPlayer;

  double playSpeed = kAudioDefaultSpeed;

  Audio({
    required this.enclosingPlaylist,
    required this.originalVideoTitle,
    required this.videoUrl,
    required this.audioDownloadDate,
    required this.videoUploadDate,
    this.audioDuration,
    required this.audioPlayer,
  })  : validVideoTitle =
            replaceUnauthorizedDirOrFileNameChars(originalVideoTitle),
        fileName =
            '${buildDownloadDatePrefix(audioDownloadDate)}${replaceUnauthorizedDirOrFileNameChars(originalVideoTitle)} ${buildUploadDateSuffix(videoUploadDate)}.mp3';

  void invertPaused() {
    _isPaused = !_isPaused;
  }

  String get filePathName {
    return '${enclosingPlaylist!.downloadPath}${Platform.pathSeparator}$fileName';
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
