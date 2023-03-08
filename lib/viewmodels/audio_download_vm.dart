import '../models/download_playlist.dart';

abstract class AudioDownloadVM {
  Future<void> downloadPlaylistAudios(
      DownloadPlaylist playlistToDownload);
}
