// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/audio.dart';
import '../viewmodels/audio_player_view_model.dart';

class AudioListItemWidget extends StatelessWidget {
  final Audio audio;
  final void Function(Audio audio) onPlayPressed;
  final void Function(Audio audio) onStopPressed;
  final void Function(Audio audio) onPausePressed;

  AudioListItemWidget({
    required this.audio,
    required this.onPlayPressed,
    required this.onStopPressed,
    required this.onPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(audio.title),
      subtitle: Text(audio.duration.toString()),
      trailing: _buildPlayButton(),
    );
  }

  Widget _buildPlayButton() {
    return Consumer<AudioPlayerViewModel>(
      builder: (context, audioPlayerViewModel, child) {
        if (audio.isPlaying) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  audioPlayerViewModel.pause(audio);
                },
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  audioPlayerViewModel.pause(audio);
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () {
                  audioPlayerViewModel.stop(audio);
                },
              ),
            ],
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              audioPlayerViewModel.play(audio);
            },
          );
        }
      },
    );
  }
}
