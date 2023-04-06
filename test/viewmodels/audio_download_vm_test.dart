import 'dart:io';

import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

void main() {
  const String testPlaylistUrl =
      'https://youtube.com/playlist?list=PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o';
  const String testPlaylistTitle = 'audio_learn_test_download_2_small_videos';
  const String testPlaylistDir =
      '$kDownloadAppTestDir\\audio_learn_test_download_2_small_videos';

  // Necessary to avoid FatalFailureException (FatalFailureException: Failed
  // to perform an HTTP request to YouTube due to a fatal failure. In most
  // cases, this error indicates that YouTube most likely changed something,
  // which broke the library.
  // If this issue persists, please report it on the project's GitHub page.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Download playlist audios', () {
    test('Check initial values', () {
      final Directory directory = Directory(testPlaylistDir);

      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }

      final AudioDownloadVM audioDownloadVM = AudioDownloadVM();

      expect(audioDownloadVM.listOfPlaylist, []);
      expect(audioDownloadVM.listOfPlaylist, []);
      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 0.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);
    });

    testWidgets('Playlist 2 short audios: playlist dir not exist',
        (WidgetTester tester) async {
      late AudioDownloadVM audioDownloadVM;
      final Directory directory = Directory(testPlaylistDir);

      deletePlaylistDownloadDir(directory);

      expect(directory.existsSync(), false);

      // await tester.pumpWidget(MyApp());
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (BuildContext context) {
          audioDownloadVM = AudioDownloadVM();
          return audioDownloadVM;
        },
        child: MaterialApp(home: DownloadPlaylistPage()),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Add a delay to allow the download to finish.
      // Note: this might not be enough time, consider increasing the duration or finding a more stable way to check for completion.
      await Future.delayed(Duration(seconds: 10));
      await tester.pump();

      expect(directory.existsSync(), true);

      expect(audioDownloadVM.listOfPlaylist[0].title, testPlaylistTitle);
      expect(audioDownloadVM.listOfPlaylist[0].url, testPlaylistUrl);

      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 1.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);

      // Check if there are two files in the directory
      final List<FileSystemEntity> files =
          directory.listSync(recursive: false, followLinks: false);
      expect(files.length, 3);

      // You can add more checks here to validate the downloaded files

      deletePlaylistDownloadDir(directory);
    });
  });
}

void deletePlaylistDownloadDir(Directory directory) {
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => AudioDownloadVM(),
        child: DownloadPlaylistPage(),
      ),
    );
  }
}

class DownloadPlaylistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download Playlist Audios')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<AudioDownloadVM>(context, listen: false)
                .downloadPlaylistAudios(
              playlistToDownload: Playlist(
                url:
                    'https://youtube.com/playlist?list=PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o',
              ),
            );
          },
          child: const Text('Download Playlist Audios'),
        ),
      ),
    );
  }
}
