class Audio {
  final String title;
  final Duration duration;
  final String filePath;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlaying) => _isPlaying = isPlaying;

  Audio({
    required this.title,
    required this.duration,
    required this.filePath,
  });

  void invertPlaying() {
    _isPlaying = !_isPlaying;
  }
}
