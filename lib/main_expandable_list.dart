import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_audio_learn/viewmodels/expandable_playlist_list_vm.dart';
import 'package:chatgpt_audio_learn/views/expandable_playlist_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpandablePlaylistListVM(),
      child: MaterialApp(
        title: 'MVVM Example',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('MVVM Example'),
          ),
          body: const ExpandablePlaylistListView(),
        ),
      ),
    );
  }
}
