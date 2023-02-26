// dart file located in lib\views

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_view_model.dart';
import '../viewmodels/audio_player_view_model.dart';

class AudioListView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController(
      text:
          'https://youtube.com/playlist?list=PLzwWSJNcZTMSw4qRX5glEyrL_IBvWbiqk');

  AudioPlayerViewModel _audioPlayerViwModel;

  AudioListView({required AudioPlayer audioPlayer})
      : _audioPlayerViwModel = AudioPlayerViewModel(audioPlayer: audioPlayer);

  @override
  Widget build(BuildContext context) {
    final AudioViewModel audioViewModel = Provider.of<AudioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Audio Downloader'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Youtube playlist link',
                hintText: 'Enter the link to the youtube playlist',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String link = _textEditingController.text.trim();
              if (link.isNotEmpty) {
                audioViewModel.fetchAudios(link);
              }
            },
            child: const Text('Download Audio'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioViewModel.audioLst.length,
              itemBuilder: (BuildContext context, int index) {
                final audio = audioViewModel.audioLst[index];
                return AudioListItemWidget(
                  audio: audio,
                  onPlayPressed: (Audio audio) {
                    _audioPlayerViwModel.play(audio);
                  },
                  onStopPressed: (Audio audio) {
                    _audioPlayerViwModel.stop(audio);
                  },
                  onPausePressed: (Audio audio) {
                    _audioPlayerViwModel.pause(audio);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
