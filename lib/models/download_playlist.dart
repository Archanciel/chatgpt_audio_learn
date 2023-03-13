import 'playlist_video.dart';
import 'downloaded_video.dart';

class DownloadPlaylist {
  String id = '';
  String title = '';
  final String url;
  String downloadPath = '';
  final List<PlaylistVideo> playlistVideoLst = [];
  final List<DownloadedVideoToDelete> downloadedVideoLst = [];

  DownloadPlaylist({
    required this.url,
  });

  void addDownloadedVideo(DownloadedVideoToDelete downloadedVideo) {
    downloadedVideoLst.add(downloadedVideo);
  }

  @override
  String toString() {
    return '$title';
  }
}
