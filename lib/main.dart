// dart file located in lib

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart' as l10n;
import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/utils/dir_util.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';
import 'viewmodels/audio_player_vm.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main(List<String> args) {
  List<String> myArgs = [];

  if (args.isNotEmpty) {
    myArgs = args;
  } else {
    // myArgs = ["delAppDir"]; // used to empty dir on emulator
    //                            app dir
  }

  // two methods which could not be declared async !
  //
  // Setting the TransferDataViewModel transfer data Map
  bool deleteAppDir = kDeleteAppDir;

  if (myArgs.isNotEmpty) {
    if (myArgs.contains("delAppDir")) {
      deleteAppDir = true;
    }
  }

  if (deleteAppDir) {
    DirUtil.createAppDirIfNotExist(isAppDirToBeDeleted: true);
    print('***** $kDownloadAppDir mp3 files deleted *****');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioDownloadVM()),
        ChangeNotifierProvider(create: (_) => AudioPlayerVM()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: l10n.AppLocalizations.of(context)!.title,
            localizationsDelegates: const [
              l10n.AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('fr', ''),
            ],
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
                        onPrimary:
                            Colors.white, // Set button text color in dark mode
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
                      border: OutlineInputBorder(),
                    ),
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.white,
                      selectionColor: Colors.white.withOpacity(0.3),
                      selectionHandleColor: Colors.white.withOpacity(0.5),
                    ),
                  )
                : ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Youtube Audio Downloader'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                    icon: Icon(themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String languageCode) {
                      Locale newLocale = Locale(languageCode);
                      l10n.AppLocalizations.delegate
                          .load(newLocale)
                          .then((localizations) {
                        Provider.of<AudioDownloadVM>(context, listen: false)
                            .changeLocale(context, newLocale);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'en',
                          child: Text(l10n.AppLocalizations.of(context)!
                              .translate('english')),
                        ),
                        PopupMenuItem<String>(
                          value: 'fr',
                          child: Text(l10n.AppLocalizations.of(context)!
                              .translate('french')),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              body: AudioListView(),
            ),
          );
        },
      ),
    );
  }
}
