// dart file located in lib

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            title: 'Youtube Audio Downloader',
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
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
