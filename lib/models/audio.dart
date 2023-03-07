// dart file located in lib\models

import 'package:audioplayers/audioplayers.dart';

class Audio {
  final String title;
  final Duration? duration;
  final String filePath;

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
    required this.filePath,
    required this.audioPlayer,
    this.duration,
  });

  void invertPaused() {
    _isPaused = !_isPaused;
  }
}
