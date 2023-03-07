class PlaylistVideo {
  final String id;
  final String title;
  final DateTime uploadDate;

  /// Video referenced in a playlist informations
  PlaylistVideo({
    required this.id,
    required this.title,
    required this.uploadDate,
  });
}
