class Audio {
  final String title;
  final Duration duration;
  final String filePath;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlaying) => _isPlaying = isPlaying;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  Audio({
    required this.title,
    required this.duration,
    required this.filePath,
  });

  void invertPaused() {
    _isPaused = !_isPaused;
  }
}
