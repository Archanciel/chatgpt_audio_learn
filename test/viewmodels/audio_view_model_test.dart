import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';

class MockYoutubeExplode extends Mock implements YoutubeExplode {}

class MockPlaylist extends Mock implements Playlist {}

class MockPlaylistVideo extends Mock implements Video {}

class MockAudioStreamInfo extends Mock implements AudioStreamInfo {}

void main() {
  group('AudioViewModel', () {
    late AudioDownloadVM viewModel;
    late MockYoutubeExplode mockYoutubeExplode;

    setUp(() {
      mockYoutubeExplode = MockYoutubeExplode();
      viewModel = AudioDownloadVM();
      viewModel.yt = mockYoutubeExplode;
    });

    test('fetchAudios downloads all audios', () async {
      final mockPlaylist = MockPlaylist();
      final mockVideo1 = MockPlaylistVideo();
      final mockVideo2 = MockPlaylistVideo();
      final mockAudioStreamInfo = MockAudioStreamInfo();

      final videoTitle1 = 'Video 1';
      final videoTitle2 = 'Video 2';
      final videoDuration1 = Duration(minutes: 3, seconds: 42);
      final videoDuration2 = Duration(minutes: 5, seconds: 21);

      final expectedAudios = [
        Audio(
          originalVideoTitle: videoTitle1,
          filePathName: '/storage/emulated/0/Download/Video 1.mp3',
          audioPlayer: AudioPlayer(),
          audioDuration: videoDuration1,
        ),
        Audio(
          originalVideoTitle: videoTitle2,
          filePathName: '/storage/emulated/0/Download/Video 2.mp3',
          audioPlayer: AudioPlayer(),
          audioDuration: videoDuration2,
        )
      ];

      when(mockYoutubeExplode.playlists.get(any))
          .thenAnswer((_) async => mockPlaylist);

      when(mockPlaylist.videos).thenReturn([mockVideo1, mockVideo2]);

      when(mockVideo1.title).thenReturn(videoTitle1);
      when(mockVideo2.title).thenReturn(videoTitle2);

      when(mockVideo1.duration).thenReturn(videoDuration1);
      when(mockVideo2.duration).thenReturn(videoDuration2);

      when(mockYoutubeExplode.videos.streamsClient.getManifest(any)).thenAnswer(
          (_) async => Manifest(
              audioOnly:
                  StreamManifest(audioOnlyStreams: [mockAudioStreamInfo])));

      when(mockAudioStreamInfo.url).thenReturn('http://example.com/audio.mp3');

      await viewModel.downloadPlaylistAudios('http://example.com/playlist');

      expect(viewModel.audioLst, expectedAudios);
    });
  });
}
