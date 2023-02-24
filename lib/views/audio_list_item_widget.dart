import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/audio.dart';
import '../viewmodels/audio_player_view_model.dart';

class AudioListItem extends StatelessWidget {
  final Audio audio;
  final AudioPlayerViewModel audioPlayer = AudioPlayerViewModel();
  final void Function(Audio audio) onPlayPressed;
  final void Function(Audio audio) onStopPressed;
  final void Function(Audio audio) onPausePressed;

  AudioListItem({
    required this.audio,
    required this.onPlayPressed,
    required this.onStopPressed,
    required this.onPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.music_note),
      title: Text(audio.title),
      subtitle: Text(audio.duration.toString()),
      trailing: _buildPlayButton(),
    );
  }

  Widget _buildPlayButton() {
    return Consumer<AudioPlayerViewModel>(
      builder: (context, audioPlayer, child) {
        if (audioPlayer.state == AudioPlayerState.playing) {
          // return IconButton(
          //   icon: Icon(Icons.stop),
          //   onPressed: () {
          //     audioPlayer.stop();
          //   },
          // );
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  audioPlayer.pause(audio);
                },
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  audioPlayer.stop(audio);
                },
              ),
            ],
          );
        } else {
          return IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              audioPlayer.play(audio);
            },
          );
        }
      },
    );
  }
}
