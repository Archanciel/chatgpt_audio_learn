import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import '../mocks/mock_youtube_explode.dart';
import '../mocks/mock_playlist.dart';

void main() {
  group('AudioDownloadVM', () {
    late AudioDownloadVM audioDownloadVM;

    setUp(() {
      audioDownloadVM = AudioDownloadVM();
    });

    test('Check initial values', () {
      expect(audioDownloadVM.listOfPlaylist[0].title, kUniquePlaylistTitle);
      expect(audioDownloadVM.listOfPlaylist[0].url, kUniquePlaylistUrl);
      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 0.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);
    });

    test('Set audio quality', () {
      audioDownloadVM.setAudioQuality(isHighQuality: true);
      expect(audioDownloadVM.isHighQuality, true);

      audioDownloadVM.setAudioQuality(isHighQuality: false);
      expect(audioDownloadVM.isHighQuality, false);
    });

    test(
        'failing  downloadPlaylistAudios downloads audio files for a new playlist',
        () async {
      final mockYoutubeExplode = MockYoutubeExplode();
      final mockYoutubePlaylist = MockYoutubePlaylist();
      final mockYoutubeVideo = MockYoutubeVideo();
      final mockStreamManifest = MockStreamManifest();
      final mockAudioOnlyStreamInfo = MockAudioOnlyStreamInfo();

      Matcher anyInstanceOf(Type type) =>
          predicate((x) => x.runtimeType == type);

      // Mocking calls to the YoutubeExplode library
      // when(mockYoutubeExplode.playlists.get(any()))
      //     .thenAnswer((_) => Future.value(mockYoutubePlaylist));
      // when(mockYoutubeExplode.playlists.get(typed(any, named: "url")))
      //     .thenAnswer((_) => Future.value(mockYoutubePlaylist));

      when(mockYoutubeExplode.playlists.get(anyInstanceOf(String)))
          .thenAnswer((_) => Future.value(mockYoutubePlaylist));

      when(mockYoutubePlaylist.title).thenReturn('Mock Playlist');
      when(mockYoutubeExplode.playlists.getVideos(any))
          .thenAnswer((_) => Stream.value(mockYoutubeVideo));
      when(mockYoutubeVideo.title).thenReturn('Mock Video');
      when(mockYoutubeVideo.id).thenReturn(yt.VideoId('1234567890'));
      when(mockYoutubeExplode.videos.streamsClient.getManifest(any))
          .thenAnswer((_) => Future.value(mockStreamManifest));
      when(mockStreamManifest.audioOnly.first)
          .thenReturn(mockAudioOnlyStreamInfo);
      when(mockStreamManifest.audioOnly.withHighestBitrate())
          .thenReturn(mockAudioOnlyStreamInfo);
      when(mockAudioOnlyStreamInfo.size)
          .thenReturn(const yt.FileSize(1024 * 1024));
      when(mockYoutubeExplode.videos.streamsClient.get(any!)).thenAnswer(
          (_) => Stream.fromIterable([List<int>.filled(1024 * 1024, 0)]));

      final vm = AudioDownloadVM();
      vm.youtubeExplode = mockYoutubeExplode;

      final mockPlaylist = MockPlaylist();
      await vm.downloadPlaylistAudios(playlistToDownload: mockPlaylist);

      expect(vm.listOfPlaylist.length, 1);
      expect(vm.listOfPlaylist.first.downloadedAudioLst.length, 1);
    });
    test('downloadPlaylistAudios downloads audio files for a new playlist',
        () async {
      final mockYoutubeExplode = MockYoutubeExplode();
      final mockYoutubePlaylist = MockYoutubePlaylist();
      final mockYoutubeVideo = MockYoutubeVideo();
      final mockStreamManifest = MockStreamManifest();
      final mockAudioOnlyStreamInfo = MockAudioOnlyStreamInfo();
      final mockPlaylistClient = MockPlaylistClient();

      Matcher anyInstanceOf(Type type) =>
          predicate((x) => x.runtimeType == type);

      // Mocking calls to the YoutubeExplode library
      // when(mockYoutubeExplode.playlists).thenReturn(mockPlaylistClient);
      mockYoutubeExplode.playlists = mockPlaylistClient;

      when(mockPlaylistClient.get(anyInstanceOf(String)))
          .thenAnswer((_) => Future.value(mockYoutubePlaylist));
      when(mockYoutubePlaylist.title).thenReturn('Mock Playlist');
      // Rest of the test
    });
  });
}
