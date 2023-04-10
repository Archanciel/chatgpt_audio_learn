import 'dart:io';

import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:chatgpt_audio_learn/utils/dir_util.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

final String todayDownloadFileNamePrefix =
    Audio.downloadDatePrefixFormatter.format(DateTime.now());

void main() {
  const String testPlaylistId = 'PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o';
  const String testPlaylistUrl =
      'https://youtube.com/playlist?list=PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o';
  const String testPlaylistTitle = 'audio_learn_test_download_2_small_videos';
  const String testPlaylistDir =
      '$kDownloadAppTestDir\\audio_learn_test_download_2_small_videos';
  const int secondsDelay = 7;

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

      final AudioDownloadVM audioDownloadVM =
          AudioDownloadVM(testPlayListTitle: testPlaylistTitle);

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
          audioDownloadVM =
              AudioDownloadVM(testPlayListTitle: testPlaylistTitle);
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
      // when all tsts are run. 7 seconds solve the problem.
      await Future.delayed(const Duration(seconds: 10));
      await tester.pump();

      expect(directory.existsSync(), true);

      Playlist downloadedPlaylist = audioDownloadVM.listOfPlaylist[0];

      checkDownloadedPlaylist(
        downloadedPlaylist: downloadedPlaylist,
        playlistId: testPlaylistId,
        playlistTitle: testPlaylistTitle,
        playlistUrl: testPlaylistUrl,
        playlistDir: testPlaylistDir,
      );

      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 1.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);

      // downloadedAudioLst contains added Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.downloadedAudioLst[0],
        downloadedAudioTwo: downloadedPlaylist.downloadedAudioLst[1],
        downloadFileNamePrefix: todayDownloadFileNamePrefix,
      );

      // playableAudioLst contains inserted at list start Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.playableAudioLst[1],
        downloadedAudioTwo: downloadedPlaylist.playableAudioLst[0],
        downloadFileNamePrefix: todayDownloadFileNamePrefix,
      );

      // Checking if there are 3 files in the directory (2 mp3 and 1 json)
      final List<FileSystemEntity> files =
          directory.listSync(recursive: false, followLinks: false);

      expect(files.length, 3);

      deletePlaylistDownloadDir(directory);
    });
    testWidgets(
        'Playlist 2 short audios: playlist 1st audio was already downloaded and was deleted',
        (WidgetTester tester) async {
      late AudioDownloadVM audioDownloadVM;
      final Directory directory = Directory(testPlaylistDir);

      deletePlaylistDownloadDir(directory);

      expect(directory.existsSync(), false);

      await DirUtil.createDirIfNotExist(pathStr: testPlaylistDir);
      await DirUtil.copyFileToDirectory(
        sourceFilePathName:
            "${testPlaylistDir}_saved\\${testPlaylistTitle}_1_audio.json",
        targetDirectoryPath: testPlaylistDir,
        targetFileName: '$testPlaylistTitle.json',
      );

      AudioDownloadVM audioDownloadVMbeforeDownload =
          AudioDownloadVM(testPlayListTitle: testPlaylistTitle);
      Playlist downloadedPlaylistBeforeDownload =
          audioDownloadVMbeforeDownload.listOfPlaylist[0];

      checkDownloadedPlaylist(
        downloadedPlaylist: downloadedPlaylistBeforeDownload,
        playlistId: testPlaylistId,
        playlistTitle: testPlaylistTitle,
        playlistUrl: testPlaylistUrl,
        playlistDir: testPlaylistDir,
      );

      List<Audio> downloadedAudioLstBeforeDownload =
          downloadedPlaylistBeforeDownload.downloadedAudioLst;
      List<Audio> playableAudioLstBeforeDownload =
          downloadedPlaylistBeforeDownload.playableAudioLst;

      expect(downloadedAudioLstBeforeDownload.length, 1);
      expect(playableAudioLstBeforeDownload.length, 1);

      checkDownloadedAudioOne(
        downloadedAudio: downloadedAudioLstBeforeDownload[0],
        downloadFileNamePrefix: '230406',
      );
      checkDownloadedAudioOne(
        downloadedAudio: playableAudioLstBeforeDownload[0],
        downloadFileNamePrefix: '230406',
      );

      // await tester.pumpWidget(MyApp());
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (BuildContext context) {
          audioDownloadVM =
              AudioDownloadVM(testPlayListTitle: testPlaylistTitle);
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
      // when all tsts are run. 7 seconds solve the problem.
      await Future.delayed(const Duration(seconds: secondsDelay));
      await tester.pump();

      expect(directory.existsSync(), true);

      Playlist downloadedPlaylist = audioDownloadVM.listOfPlaylist[0];

      checkDownloadedPlaylist(
        downloadedPlaylist: downloadedPlaylist,
        playlistId: testPlaylistId,
        playlistTitle: testPlaylistTitle,
        playlistUrl: testPlaylistUrl,
        playlistDir: testPlaylistDir,
      );

      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 1.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);

      // downloadedAudioLst contains added Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.downloadedAudioLst[0],
        downloadedAudioTwo: downloadedPlaylist.downloadedAudioLst[1],
        downloadFileNamePrefix: '230406',
        todayFileNamePrefix: todayDownloadFileNamePrefix,
      );

      // playableAudioLst contains inserted at list start Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.playableAudioLst[1],
        downloadedAudioTwo: downloadedPlaylist.playableAudioLst[0],
        downloadFileNamePrefix: '230406',
        todayFileNamePrefix: todayDownloadFileNamePrefix,
      );

      // Checking if there are 3 files in the directory (1 mp3 and 1 json)
      final List<FileSystemEntity> files =
          directory.listSync(recursive: false, followLinks: false);

      expect(files.length, 2);

      deletePlaylistDownloadDir(directory);
    });
  });
  group('Download recreated playlist with short audios', () {
    testWidgets(
        'Recreated playlist 2 new short audios: initial playlist 1st and 2nd audio were already downloaded and were deleted',
        (WidgetTester tester) async {
      late AudioDownloadVM audioDownloadVM;
      final Directory directory = Directory(testPlaylistDir);

      deletePlaylistDownloadDir(directory);

      expect(directory.existsSync(), false);

      await DirUtil.createDirIfNotExist(pathStr: testPlaylistDir);
      await DirUtil.copyFileToDirectory(
        sourceFilePathName: "${testPlaylistDir}_saved\\$testPlaylistTitle.json",
        targetDirectoryPath: testPlaylistDir,
        targetFileName: '$testPlaylistTitle.json',
      );

      AudioDownloadVM audioDownloadVMbeforeDownload =
          AudioDownloadVM(testPlayListTitle: testPlaylistTitle);
      Playlist downloadedPlaylistBeforeDownload =
          audioDownloadVMbeforeDownload.listOfPlaylist[0];

      checkDownloadedPlaylist(
        downloadedPlaylist: downloadedPlaylistBeforeDownload,
        playlistId: testPlaylistId,
        playlistTitle: testPlaylistTitle,
        playlistUrl: testPlaylistUrl,
        playlistDir: testPlaylistDir,
      );

      List<Audio> downloadedAudioLstBeforeDownload =
          downloadedPlaylistBeforeDownload.downloadedAudioLst;
      List<Audio> playableAudioLstBeforeDownload =
          downloadedPlaylistBeforeDownload.playableAudioLst;

      checkDownloadedAudios(
        downloadedAudioOne: downloadedAudioLstBeforeDownload[0],
        downloadedAudioTwo: downloadedAudioLstBeforeDownload[1],
        downloadFileNamePrefix: '230406',
      );

      // playableAudioLst contains inserted at list start Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: playableAudioLstBeforeDownload[1],
        downloadedAudioTwo: playableAudioLstBeforeDownload[0],
        downloadFileNamePrefix: '230406',
      );

      // await tester.pumpWidget(MyApp());
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (BuildContext context) {
          audioDownloadVM =
              AudioDownloadVM(testPlayListTitle: testPlaylistTitle);
          return audioDownloadVM;
        },
        child: MaterialApp(home: DownloadPlaylistPage()),
      ));

      const String recreatedPlaylistId = 'PLzwWSJNcZTMSwrDOAZEPf0u6YvrKGNnvC';
      const String recreatedPlaylistWithSameTitleUrl = 
          'https://youtube.com/playlist?list=PLzwWSJNcZTMSwrDOAZEPf0u6YvrKGNnvC';

      await tester.enterText(
        find.byKey(const Key('playlistUrlTextField')),
        recreatedPlaylistWithSameTitleUrl,
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Add a delay to allow the download to finish. 5 seconds is ok
      // when running the audio_download_vm_test only.
      // Waiting 5 seconds only causes MissingPluginException
      // 'No implementation found for method $method on channel $name'
      // when all tsts are run. 7 seconds solve the problem.
      await Future.delayed(const Duration(seconds: secondsDelay));
      await tester.pump();

      expect(directory.existsSync(), true);

      Playlist downloadedPlaylist = audioDownloadVM.listOfPlaylist[0];

      checkDownloadedPlaylist(
        downloadedPlaylist: downloadedPlaylist,
        playlistId: recreatedPlaylistId,
        playlistTitle: testPlaylistTitle,
        playlistUrl: recreatedPlaylistWithSameTitleUrl,
        playlistDir: testPlaylistDir,
      );

      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 1.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);

      // downloadedAudioLst contains added Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.downloadedAudioLst[0],
        downloadedAudioTwo: downloadedPlaylist.downloadedAudioLst[1],
        downloadFileNamePrefix: '230406',
      );

      // playableAudioLst contains inserted at list start Audio^s
      checkDownloadedAudios(
        downloadedAudioOne: downloadedPlaylist.playableAudioLst[3],
        downloadedAudioTwo: downloadedPlaylist.playableAudioLst[2],
        downloadFileNamePrefix: '230406',
      );

      // Checking if there are 3 files in the directory (1 mp3 and 1 json)
      final List<FileSystemEntity> files =
          directory.listSync(recursive: false, followLinks: false);

      expect(files.length, 3);

      deletePlaylistDownloadDir(directory);
    });
  });
}

void checkDownloadedPlaylist({
  required Playlist downloadedPlaylist,
  required String playlistId,
  required String playlistTitle,
  required String playlistUrl,
  required String playlistDir,
}) {
  expect(downloadedPlaylist.id, playlistId);
  expect(downloadedPlaylist.title, playlistTitle);
  expect(downloadedPlaylist.url, playlistUrl);
  expect(downloadedPlaylist.downloadPath, playlistDir);
}

void checkDownloadedAudios({
  required Audio downloadedAudioOne,
  required Audio downloadedAudioTwo,
  required String downloadFileNamePrefix,
  String? todayFileNamePrefix,
}) {
  checkDownloadedAudioOne(
    downloadedAudio: downloadedAudioOne,
    downloadFileNamePrefix: downloadFileNamePrefix,
  );

  expect(downloadedAudioTwo.originalVideoTitle, "Innovation (Short Film)");
  expect(downloadedAudioTwo.validVideoTitle, "Innovation (Short Film)");
  expect(downloadedAudioTwo.videoUrl,
      "https://www.youtube.com/watch?v=0lTH9cCod4M");
  expect(downloadedAudioTwo.videoUploadDate,
      DateTime.parse("2020-01-07T00:00:00.000"));
  expect(downloadedAudioTwo.audioDuration, const Duration(milliseconds: 49000));
  expect(downloadedAudioTwo.isMusicQuality, false);
  expect(downloadedAudioTwo.audioFileName,
      "${todayFileNamePrefix ?? downloadFileNamePrefix}-Innovation (Short Film) 20-01-07.mp3");
  expect(downloadedAudioTwo.audioFileSize, 295404);
}

void checkDownloadedAudioOne({
  required Audio downloadedAudio,
  required String downloadFileNamePrefix,
}) {
  expect(downloadedAudio.originalVideoTitle,
      "English conversation: Tea or coffee?");
  expect(
      downloadedAudio.validVideoTitle, "English conversation - Tea or coffee");
  expect(
      downloadedAudio.videoUrl, "https://www.youtube.com/watch?v=X9s0hsOw3Uc");
  expect(downloadedAudio.videoUploadDate,
      DateTime.parse("2023-03-22T00:00:00.000"));
  expect(downloadedAudio.audioDuration, const Duration(milliseconds: 24000));
  expect(downloadedAudio.isMusicQuality, false);
  expect(downloadedAudio.audioFileName,
      "${downloadFileNamePrefix}-English conversation - Tea or coffee 23-03-22.mp3");
  expect(downloadedAudio.audioFileSize, 143076);
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

class DownloadPlaylistPage extends StatefulWidget {
  @override
  State<DownloadPlaylistPage> createState() => _DownloadPlaylistPageState();
}

class _DownloadPlaylistPageState extends State<DownloadPlaylistPage> {
  TextEditingController _urlController = TextEditingController(
    text:
        'https://youtube.com/playlist?list=PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download Playlist Audios')),
      body: Center(
        child: Column(
          children: [
            TextField(
              key: const Key('playlistUrlTextField'),
              controller: _urlController,
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AudioDownloadVM>(context, listen: false)
                    .downloadPlaylistAudios(
                  playlistToDownload: Playlist(
                    url: _urlController.text,
                  ),
                );
              },
              child: const Text('Download Playlist Audios'),
            ),
          ],
        ),
      ),
    );
  }
}
