import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/audio_download_vm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => AudioDownloadVM(),
        child: const DownloadPlaylistPage(),
      ),
    );
  }
}

class DownloadPlaylistPage extends StatelessWidget {
  const DownloadPlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download Playlist Audios')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<AudioDownloadVM>(context, listen: false)
                .downloadPlaylistAudios(
              playlistUrl: 'https://youtube.com/playlist?list=PLzwWSJNcZTMRB9ILve6fEIS_OHGrV5R2o',
            );
          },
          child: const Text('Download Playlist Audios'),
        ),
      ),
    );
  }
}
