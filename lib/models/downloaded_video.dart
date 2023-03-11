import 'dart:io';

import 'audio.dart';

/// Video downloaded informations
class DownloadedVideo {
  final String id;
  final String title;
  final DateTime downloadDate;
  final Audio audio;

  DownloadedVideo(
      {required this.id,
      required this.title,
      required this.downloadDate,
      required this.audio});

  @override
  String toString() {
    return '$title ${audio.audioDuration.toString()}';
  }
}
