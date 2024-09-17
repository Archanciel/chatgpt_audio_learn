// dart file located in lib\models

import 'package:json_annotation/json_annotation.dart';
import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
import 'package:chatgpt_audio_learn/constants_old.dart';
import 'package:intl/intl.dart';

import 'playlist_json.dart';

part 'audio_json.g.dart';

enum AudioSortCriterion {audioDownloadDateTime, validVideoTitle}

/// Contains informations of the audio extracted from the video
/// referenced in the enclosing playlist. In fact, the audio is
/// directly downloaded from Youtube.
@JsonSerializable()
class AudioJson {
  static DateFormat downloadDatePrefixFormatter = DateFormat('yyMMdd');
  static DateFormat uploadDateSuffixFormatter = DateFormat('yy-MM-dd');

  // PlaylistJson in which the video is referenced
  PlaylistJson? enclosingPlaylist;

  // Video title displayed on Youtube
  final String originalVideoTitle;

  // Video title which does not contain invalid characters which
  // would cause the audio file name to generate an file creation
  // exception
  final String validVideoTitle;

  // Url referencing the video from which rhe audio was extracted
  final String videoUrl;

  // Audio download date time
  final DateTime audioDownloadDateTime;

  // Duration in which the audio was downloaded
  Duration? audioDownloadDuration;

  // Date at which the video containing the audio was added on
  // Youtube
  final DateTime videoUploadDate;

  // Stored audio file name
  final String audioFileName;

  // Duration of downloaded audio
  final Duration? audioDuration;

  // Audio file size in bytes
  int audioFileSize = 0;
  set fileSize(int size) {
    audioFileSize = size;
    audioDownloadSpeed = (audioFileSize == 0 || audioDownloadDuration == null)
        ? 0
        : (audioFileSize / audioDownloadDuration!.inMicroseconds * 1000000)
            .round();
  }

  set downloadDuration(Duration downloadDuration) {
    audioDownloadDuration = downloadDuration;
    audioDownloadSpeed = (audioFileSize == 0 || audioDownloadDuration == null)
        ? 0
        : (audioFileSize / audioDownloadDuration!.inMicroseconds * 1000000)
            .round();
  }

  // Speed at which the audio was downloaded in bytes per second
  late int audioDownloadSpeed;

  // State of the audio

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    _isPaused = false;
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  double playSpeed = kAudioDefaultSpeed;

  bool isMusicQuality = false;

  AudioJson({
    required this.enclosingPlaylist,
    required this.originalVideoTitle,
    required this.videoUrl,
    required this.audioDownloadDateTime,
    this.audioDownloadDuration,
    required this.videoUploadDate,
    this.audioDuration,
  })  : validVideoTitle =
            replaceUnauthorizedDirOrFileNameChars(originalVideoTitle),
        audioFileName =
            '${buildDownloadDatePrefix(audioDownloadDateTime)}${replaceUnauthorizedDirOrFileNameChars(originalVideoTitle)} ${buildUploadDateSuffix(videoUploadDate)}.mp3';

  // Factory pour la désérialisation
  factory AudioJson.fromJson(Map<String, dynamic> json) => _$AudioJsonFromJson(json);

  // Méthode pour la sérialisation
  Map<String, dynamic> toJson() => _$AudioJsonToJson(this);

  void invertPaused() {
    _isPaused = !_isPaused;
  }

  String get filePathName {
    return '${enclosingPlaylist!.downloadPath}${Platform.pathSeparator}$audioFileName';
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
    return validFileName;
  }
}
