import 'dart:io';

/// Video downloaded informations
class DownloadedVideo {
  final String id;
  final String title;
  final String audioFilePath;
  final DateTime downloadDate;
  final Duration? audioDuration;

  DownloadedVideo({
    required this.id,
    required this.title,
    required this.audioFilePath,
    required this.downloadDate,
    required this.audioDuration,
  });

  @override
  String toString() {
    return '$title $audioDuration';
  }
}
