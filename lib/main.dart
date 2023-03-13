// dart file located in lib

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/utils/dir_util.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_download_view_model.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';
import 'viewmodels/audio_player_view_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioDownloadViewModel()),
        ChangeNotifierProvider(create: (_) => AudioPlayerViewModel()),
      ],
      child: MaterialApp(
        title: 'Youtube Audio Downloader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AudioListView(),
      ),
    );
  }
}
