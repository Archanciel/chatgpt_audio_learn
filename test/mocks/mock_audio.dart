// dart file located in test\mocks

import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:mockito/mockito.dart';

class MockPlaylist extends Mock implements Playlist {
  @override
  String get url => 'https://www.youtube.com/playlist?list=PL1234567890';

  @override
  String get title => 'Mock Playlist';

  @override
  String get downloadPath => 'mock_download_path';
}
