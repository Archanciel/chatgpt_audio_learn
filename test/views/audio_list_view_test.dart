import 'package:chatgpt_audio_learn/models/audio.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_player_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/theme_provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/language_provider.dart';
import 'package:chatgpt_audio_learn/main_translation.dart';
import 'package:youtube_explode_dart/src/youtube_explode_base.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockAudioDownloadVM extends ChangeNotifier implements AudioDownloadVM {
  final List<Playlist> _playlistLst = [];

  MockAudioDownloadVM() {
    _playlistLst.add(Playlist(url: 'https://mockurl.com'));
  }

  @override
  Future<void> downloadPlaylistAudios({
    required String playlistUrl,
  }) async {
    List<Audio> audioLst = [
      Audio(
          enclosingPlaylist: Playlist(url: playlistUrl),
          originalVideoTitle: 'Audio 1',
          videoUrl: 'https://example.com/video2',
          audioDownloadDateTime: DateTime(2023, 3, 25),
          videoUploadDate: DateTime.now(),
          audioDuration: const Duration(minutes: 3, seconds: 42)),
      Audio(
          enclosingPlaylist: Playlist(url: playlistUrl),
          originalVideoTitle: 'Audio 2',
          videoUrl: 'https://example.com/video2',
          audioDownloadDateTime: DateTime(2023, 3, 25),
          videoUploadDate: DateTime.now(),
          audioDuration: const Duration(minutes: 5, seconds: 21)),
      Audio(
          enclosingPlaylist: Playlist(url: playlistUrl),
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
  group('AudioListView mock downloading audios', () {
    late MockAudioDownloadVM mockAudioViewModel;

    setUp(() {
      mockAudioViewModel = MockAudioDownloadVM();
    });

    testWidgets('displays list of downloaded audios',
        (WidgetTester tester) async {
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
                          foregroundColor: Colors
                              .white, backgroundColor: Colors
                              .blue.shade700, // Set button text color in dark mode
                        ),
                      ),
                      textTheme: ThemeData.dark().textTheme.copyWith(
                            bodyMedium: ThemeData.dark()
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.blue.shade700),
                            titleMedium: ThemeData.dark()
                                .textTheme
                                .titleMedium!
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

      TextField urlTextField =
          tester.widget(find.byKey(const Key('playlistUrlTextField')));
      expect(urlTextField.controller!.text, 'https://mockurl.com');

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

  group('AudioListView language selection', () {
    testWidgets('Changing language', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MainApp(
              key: Key('mainAppKey'),
            ),
          ),
        ),
      );

// Check the initial language
      expect(find.text('Download Audio Youtube'), findsOneWidget);

// Open the language selection popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

// Select the French language option
      await tester.tap(find.text('Select French'));
      await tester.pumpAndSettle();

// Check if the language has changed
      expect(find.text('Télécharger Audio Youtube'), findsOneWidget);

// Open the language selection popup menu again
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

// Select the English language option
      await tester.tap(find.text('Affichage anglais'));
      await tester.pumpAndSettle();

// Check if the language has changed back
      expect(find.text('Download Audio Youtube'), findsOneWidget);
    });
  });
}
