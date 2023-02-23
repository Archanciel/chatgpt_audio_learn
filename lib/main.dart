import 'package:chatgpt_audio_learn/viewmodels/audio_view_model.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioViewModel()),
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
