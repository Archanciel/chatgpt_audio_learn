import 'dart:io';

import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/models/audio.dart';
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

  group('Download 1 playlist with short audios', () {
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

      // Add a delay to allow the download to finish. 5 seconds is ok
      // when running the audio_download_vm_test only.
      // Waiting 5 seconds only causes MissingPluginException
      // 'No implementation found for method $method on channel $name'
      // when all tsts are run. 10 seconds solve the problem.
      await Future.delayed(const Duration(seconds: 10));
      await tester.pump();

      expect(directory.existsSync(), true);

      Playlist downloadedPlaylist = audioDownloadVM.listOfPlaylist[0];

      expect(downloadedPlaylist.id, 'PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o');
      expect(downloadedPlaylist.title, testPlaylistTitle);
      expect(downloadedPlaylist.url, testPlaylistUrl);
      expect(downloadedPlaylist.downloadPath, testPlaylistDir);

      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 1.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);

      // downloadedAudioLst contains added Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.downloadedAudioLst[0],
        downloadedAudioTwo: downloadedPlaylist.downloadedAudioLst[1],
      );

      // playableAudioLst contains inserted at list start Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.playableAudioLst[1],
        downloadedAudioTwo: downloadedPlaylist.playableAudioLst[0],
      );

      // Checking if there are 3 files in the directory (2 mp3 and 1 json)
      final List<FileSystemEntity> files =
          directory.listSync(recursive: false, followLinks: false);

      expect(files.length, 3);

      deletePlaylistDownloadDir(directory);
    });
  });
}

void checkDownloadedAudios({
  required Audio downloadedAudioOne,
  required Audio downloadedAudioTwo,
}) {
  expect(downloadedAudioOne.originalVideoTitle,
      "English conversation: Tea or coffee?");
  expect(downloadedAudioOne.validVideoTitle,
      "English conversation - Tea or coffee");
  expect(downloadedAudioOne.videoUrl,
      "https://www.youtube.com/watch?v=X9s0hsOw3Uc");
  expect(downloadedAudioOne.videoUploadDate,
      DateTime.parse("2023-03-22T00:00:00.000"));
  expect(downloadedAudioOne.audioDuration, const Duration(milliseconds: 24000));
  expect(downloadedAudioOne.isMusicQuality, false);
  expect(downloadedAudioOne.audioFileName,
      "230406-English conversation - Tea or coffee 23-03-22.mp3");
  expect(downloadedAudioOne.audioFileSize, 143076);

  expect(downloadedAudioTwo.originalVideoTitle, "Innovation (Short Film)");
  expect(downloadedAudioTwo.validVideoTitle, "Innovation (Short Film)");
  expect(downloadedAudioTwo.videoUrl,
      "https://www.youtube.com/watch?v=0lTH9cCod4M");
  expect(downloadedAudioTwo.videoUploadDate,
      DateTime.parse("2020-01-07T00:00:00.000"));
  expect(downloadedAudioTwo.audioDuration, const Duration(milliseconds: 49000));
  expect(downloadedAudioTwo.isMusicQuality, false);
  expect(downloadedAudioTwo.audioFileName,
      "230406-Innovation (Short Film) 20-01-07.mp3");
  expect(downloadedAudioTwo.audioFileSize, 295404);
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
