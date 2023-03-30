// dart file located in lib

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/utils/dir_util.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';
import 'viewmodels/audio_player_vm.dart';
import 'viewmodels/language_provider.dart';
import 'viewmodels/theme_provider.dart';

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

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioDownloadVM()),
        ChangeNotifierProvider(create: (_) => AudioPlayerVM()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (_) => LanguageProvider(initialLocale: const Locale('en'))),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: 'ChatGPT Audio Learn',
            locale: languageProvider.currentLocale,
            // title: AppLocalizations.of(context)!.title,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
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
                      border: const OutlineInputBorder(),
                    ),
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.white,
                      selectionColor: Colors.white.withOpacity(0.3),
                      selectionHandleColor: Colors.white.withOpacity(0.5),
                    ),
                  )
                : ThemeData.light(),
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

/// Before enclosing Scaffold in MyHomePage, this exception was
/// thrown: 
///
/// Exception has occurred.
/// _CastError (Null check operator used on a null value)
///
/// if the AppBar title is obtained that way:
///
///            home: Scaffold(
///              appBar: AppBar(
///                title: Text(AppLocalizations.of(context)!.title),
/// 
/// The issue occurs because the context provided to the
/// AppLocalizations.of(context) is not yet aware of the
/// localization configuration, as it's being accessed within
/// the same MaterialApp widget where you define the localization
/// delegates and the locale.
///
/// To fix this issue, you can wrap your Scaffold in a new widget,
/// like MyHomePage, which will have access to the correct context.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          PopupMenuButton<String>(
            onSelected: (String languageCode) {
              Locale newLocale = Locale(languageCode);
              AppLocalizations.delegate.load(newLocale).then((localizations) {
                Provider.of<LanguageProvider>(context, listen: false)
                    .changeLocale(newLocale);
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'en',
                  child: Text(AppLocalizations.of(context)!
                      .translate(AppLocalizations.of(context)!.english)),
                ),
                PopupMenuItem<String>(
                  value: 'fr',
                  child: Text(AppLocalizations.of(context)!
                      .translate(AppLocalizations.of(context)!.french)),
                ),
              ];
            },
          ),
        ],
      ),
      body: AudioListView(),
    );
  }
}
