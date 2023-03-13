import 'dart:io';

import 'audio.dart';

/// Video downloaded informations
/// Class not used
class DownloadedVideoToDelete {
  final String id;
  final String title;
  final DateTime downloadDate;
  final Audio audio;

  DownloadedVideoToDelete(
      {required this.id,
      required this.title,
      required this.downloadDate,
      required this.audio});

  @override
  String toString() {
    return '$title ${audio.audioDuration.toString()}';
  }
}
