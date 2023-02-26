// dart file located in lib

import 'package:audioplayers/audioplayers.dart';
import 'package:chatgpt_audio_learn/viewmodels/audio_view_model.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/audio_player_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioViewModel()),
        ChangeNotifierProvider(
            create: (_) => AudioPlayerViewModel()),
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
