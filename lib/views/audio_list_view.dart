import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/audio.dart';
import '../viewmodels/audio_view_model.dart';

class AudioListView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController(
      text:
          'https://youtube.com/playlist?list=PLzwWSJNcZTMSw4qRX5glEyrL_IBvWbiqk');

  final _audioPlayer = AudioPlayer();
  late Audio _currentlyPlayingAudio;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final audioViewModel = Provider.of<AudioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Audio Downloader'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Youtube playlist link',
                hintText: 'Enter the link to the youtube playlist',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final link = _textEditingController.text.trim();
              if (link.isNotEmpty) {
                audioViewModel.fetchAudios(link);
              }
            },
            child: Text('Download Audio'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioViewModel.audios.length,

              itemBuilder: (context, index) {
                final audio = audioViewModel.audios[index];
                return ListTile(
                  leading: Icon(Icons.audiotrack),
                  title: Text(audio.title),
                  subtitle: Text(audio.duration.toString()),
                  trailing: _isPlaying
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: _isPlaying
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                              onPressed: _togglePlayback,
                            ),
                            IconButton(
                              icon: Icon(Icons.stop),
                              onPressed: _stopPlayback,
                            ),
                          ],
                        )
                      : IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () => _startPlayback(audio),
                        ),
                );
              },
              // itemBuilder: (context, index) {
              //   return ListTile(
              //     title: Text(audioViewModel.audios[index].title),
              //     subtitle: Text(
              //         '${audioViewModel.audios[index].duration.inMinutes} mins'),
              //   );
              // },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startPlayback(Audio audio) async {
    final file = File(audio.filePath);
    if (!await file.exists()) {
      print('File not found: ${audio.filePath}');
      return;
    }

    _audioPlayer.stop();
    _currentlyPlayingAudio = audio;
    await _audioPlayer.play(file.path, isLocal: true);
    _isPlaying = true;
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(_currentlyPlayingAudio.filePath);
    }

   _isPlaying = !_isPlaying;
  }

  void _stopPlayback() {
    _audioPlayer.stop();
    _isPlaying = false;
  }
}
