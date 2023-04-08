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

class MockAudioViewModel extends ChangeNotifier implements AudioDownloadVM {
  List<Audio> audioLst = [];
  List<Playlist> playlistLst = [];

  MockAudioViewModel() {
    playlistLst.add(Playlist(url: 'https://example.com/playlist1'));
  }

  @override
  Future<void> downloadPlaylistAudios(
      {required Playlist playlistToDownload}) async {
    audioLst = [
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
  Audio get currentDownloadingAudio => audioLst[0];

  @override
  // TODO: implement downloadProgress
  double get downloadProgress => 0.5;

  @override
  // TODO: implement isDownloading
  bool get isDownloading => true;

  @override
  // TODO: implement isHighQuality
  bool get isHighQuality => false;

  @override
  // TODO: implement lastSecondDownloadSpeed
  int get lastSecondDownloadSpeed => 100000;

  @override
  // TODO: implement listOfPlaylist
  List<Playlist> get listOfPlaylist => throw UnimplementedError();

  @override
  void setAudioQuality({required bool isHighQuality}) {
    // TODO: implement setAudioQuality
  }
}

void main() {
  group('AudioListView', () {
    late MockAudioViewModel mockAudioViewModel;

    setUp(() {
      mockAudioViewModel = MockAudioViewModel();
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
