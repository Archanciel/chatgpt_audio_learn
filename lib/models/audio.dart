// dart file located in lib\models

import 'package:audioplayers/audioplayers.dart';

class Audio {
  final String title;
  final Duration? audioDuration;
  final Duration? downloadDuration;
  final String filePathName;
  final int? audioFileSize;
  final double downloadSpeed;

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
    required this.title,
    required this.filePathName,
    this.downloadDuration,
    this.audioDuration,
    this.audioFileSize,
    required this.audioPlayer,
  }) : downloadSpeed = (audioFileSize == null)
            ? 0.0
            : audioFileSize / downloadDuration!.inSeconds;

  void invertPaused() {
    _isPaused = !_isPaused;
  }
}
