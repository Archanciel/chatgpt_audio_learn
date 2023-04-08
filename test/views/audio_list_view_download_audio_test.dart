import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/src/youtube_explode_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chatgpt_audio_learn/main.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_player_vm.dart';
import 'package:chatgpt_audio_learn/viewmodels/language_provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/theme_provider.dart';
import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';

class MockAudioDownloadVM extends ChangeNotifier implements AudioDownloadVM {
  final List<Playlist> _playlistLst = [];

  MockAudioDownloadVM() {
    _playlistLst.add(Playlist(url: 'https://example.com/playlist1'));
  }

  @override
  Future<void> downloadPlaylistAudios(
      {required Playlist playlistToDownload}) async {
    List<Audio> audioLst = [
      Audio(
          enclosingPlaylist: playlistToDownload,
          originalVideoTitle: 'Audio 1',
          videoUrl: 'https://example.com/video2',
          audioDownloadDateTime: DateTime(2023, 3, 25),
          videoUploadDate: DateTime.now(),
          audioDuration: const Duration(minutes: 3, seconds: 42)),
      Audio(
          enclosingPlaylist: playlistToDownload,
          originalVideoTitle: 'Audio 2',
          videoUrl: 'https://example.com/video2',
          audioDownloadDateTime: DateTime(2023, 3, 25),
          videoUploadDate: DateTime.now(),
          audioDuration: const Duration(minutes: 5, seconds: 21)),
      Audio(
          enclosingPlaylist: playlistToDownload,
          originalVideoTitle: 'Audio 3',
          videoUrl: 'https://example.com/video2',
          audioDownloadDateTime: DateTime(2023, 3, 25),
          videoUploadDate: DateTime.now(),
          audioDuration: const Duration(minutes: 2, seconds: 15)),
    ];

    int i = 1;
    int speed = 100000;
    int size = 900000;

    for (Audio audio in audioLst) {
      audio.audioDownloadSpeed = speed * i;
      audio.audioFileSize = size * i;
      i++;
    }

    _playlistLst[0].downloadedAudioLst = audioLst;
    _playlistLst[0].playableAudioLst = audioLst;

    notifyListeners();
  }

  @override
  late YoutubeExplode youtubeExplode;

  @override
  void addNewPlaylist(Playlist playlist) {
    // TODO: implement addNewPlaylist
    int i = 0;
  }

  @override
  // TODO: implement currentDownloadingAudio
  Audio get currentDownloadingAudio => _playlistLst[0].downloadedAudioLst[0];

  @override
  // TODO: implement downloadProgress
  double get downloadProgress => 0.5;

  @override
  // TODO: implement isDownloading
  bool get isDownloading => false;

  @override
  // TODO: implement isHighQuality
  bool get isHighQuality => false;

  @override
  // TODO: implement lastSecondDownloadSpeed
  int get lastSecondDownloadSpeed => 100000;

  @override
  // TODO: implement listOfPlaylist
  List<Playlist> get listOfPlaylist => _playlistLst;

  @override
  void setAudioQuality({required bool isHighQuality}) {
    // TODO: implement setAudioQuality
  }
}

void main() {
  group('AudioListView', () {
    late MockAudioDownloadVM mockAudioViewModel;

    setUp(() {
      mockAudioViewModel = MockAudioDownloadVM();
    });

    testWidgets('displays list of audios', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AudioDownloadVM>.value(
              value: mockAudioViewModel,
            ),
            ChangeNotifierProvider(create: (_) => AudioPlayerVM()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(
                create: (_) =>
                    LanguageProvider(initialLocale: const Locale('en'))),
          ],
          child: Consumer2<ThemeProvider, LanguageProvider>(
              builder: (context, themeProvider, languageProvider, child) {
            return MaterialApp(
              theme: themeProvider.isDarkMode
                  ? ThemeData.dark().copyWith(
                      colorScheme: ThemeData.dark().colorScheme.copyWith(
                            background: Colors.black,
                            surface: Colors.black,
                          ),
                      primaryColor: Colors.black,
                      scaffoldBackgroundColor: Colors.black,
                      iconTheme: ThemeData.dark().iconTheme.copyWith(
                            color: Colors
                                .blue.shade700, // Set icon color in dark mode
                          ),
                      elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          primary: Colors
                              .blue.shade700, // Set button color in dark mode
                          onPrimary: Colors
                              .white, // Set button text color in dark mode
                        ),
                      ),
                      textTheme: ThemeData.dark().textTheme.copyWith(
                            bodyText2: ThemeData.dark()
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.blue.shade700),
                            subtitle1: ThemeData.dark()
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.white),
                          ),
                      checkboxTheme: ThemeData.dark().checkboxTheme.copyWith(
                            checkColor: MaterialStateProperty.all(
                              Colors.blue.shade700, // Set Checkbox check color
                            ),
                            fillColor: MaterialStateProperty.all(
                              Colors.white, // Set Checkbox fill color
                            ),
                          ),
                      inputDecorationTheme: InputDecorationTheme(
                        fillColor: Colors.grey[900],
                        filled: true,
                        border: const OutlineInputBorder(),
                      ),
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: Colors.white,
                        selectionColor: Colors.white.withOpacity(0.3),
                        selectionHandleColor: Colors.white.withOpacity(0.5),
                      ),
                    )
                  : ThemeData.light(),
              home: const Scaffold(
                body: MyHomePage(),
              ),
              locale: languageProvider.currentLocale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          }),
        ),
      );

      // Wait for the audios to be loaded
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('downLoadButton')));
      await tester.pumpAndSettle();

      // Verify that all the audios are displayed
      expect(find.text('Audio 1'), findsOneWidget);
      expect(find.text('0:03:42. Size 900 Ko. Downloaded at 100 Ko/sec'),
          findsOneWidget);

      expect(find.text('Audio 2'), findsOneWidget);
      expect(find.text('0:05:21. Size 1.80 Mo. Downloaded at 200 Ko/sec'),
          findsOneWidget);

      expect(find.text('Audio 3'), findsOneWidget);
      expect(find.text('0:02:15. Size 2.70 Mo. Downloaded at 300 Ko/sec'),
          findsOneWidget);
    });
  });
}
