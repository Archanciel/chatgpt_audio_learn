// dart file located in test\mocks

import 'package:mockito/mockito.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

// class MockYoutubeExplode extends Mock implements yt.YoutubeExplode {}
// class MockYoutubeExplode extends Mock implements yt.YoutubeExplode {
//   @override
//   yt.PlaylistClient get playlists => super.noSuchMethod(Invocation.getter(#playlists));
// }
class MockYoutubeExplode extends Mock implements yt.YoutubeExplode {
  @override
  yt.PlaylistClient get playlists {
    return MockPlaylistClient();
  }
}

class MockYoutubePlaylist extends Mock implements yt.Playlist {}

class MockYoutubeVideo extends Mock implements yt.Video {}

class MockStreamManifest extends Mock implements yt.StreamManifest {}

class MockAudioOnlyStreamInfo extends Mock implements yt.AudioOnlyStreamInfo {}

class MockPlaylistClient extends Mock implements yt.PlaylistClient {}