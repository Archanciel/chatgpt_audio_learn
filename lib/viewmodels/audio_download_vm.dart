import '../models/audio.dart';
import '../models/download_playlist.dart';

abstract class AudioDownloadVM {
  final List<Audio> audioLst = [];
  
  Future<void> downloadPlaylistAudios(
      DownloadPlaylist playlistToDownload);
}
