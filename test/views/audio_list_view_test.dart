import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_view_model_yt.dart';
import 'package:youtube_explode_dart/src/youtube_explode_base.dart';

class MockAudioViewModel extends ChangeNotifier
    implements AudioDownloadViewModelYt {
  @override
  List<Audio> audioLst = [];

  @override
  Future<void> downloadPlaylistAudios(String playlistUrl) async {
    audioLst = [
      Audio(
          title: 'Audio 1',
          duration: Duration(minutes: 3, seconds: 42),
          filePathName: '/storage/emulated/0/Download/Audio 1.mp3'),
      Audio(
          title: 'Audio 2',
          duration: Duration(minutes: 5, seconds: 21),
          filePathName: '/storage/emulated/0/Download/Audio 2.mp3'),
      Audio(
          title: 'Audio 3',
          duration: Duration(minutes: 2, seconds: 15),
          filePathName: '/storage/emulated/0/Download/Audio 3.mp3'),
    ];

    notifyListeners();
  }

  @override
  late YoutubeExplode yt;
}

void main() {
  group('AudioListView', () {
    late MockAudioViewModel mockAudioViewModel;

    setUp(() {
      mockAudioViewModel = MockAudioViewModel();
    });

    testWidgets('displays list of audios', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AudioDownloadViewModelYt>.value(
          value: mockAudioViewModel,
          child: MaterialApp(
            home: Scaffold(
              body: AudioListView(),
            ),
          ),
        ),
      );

      // Wait for the audios to be loaded
      await tester.pumpAndSettle();

      // Verify that all the audios are displayed
      expect(find.text('Audio 1'), findsOneWidget);
      expect(find.text('3:42'), findsOneWidget);

      expect(find.text('Audio 2'), findsOneWidget);
      expect(find.text('5:21'), findsOneWidget);

      expect(find.text('Audio 3'), findsOneWidget);
      expect(find.text('2:15'), findsOneWidget);
    });
  });
}
