// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/audio.dart';
import '../viewmodels/audio_player_vm.dart';
import '../utils/time_util.dart';

class AudioListItemWidget extends StatelessWidget {
  final Audio audio;
  final void Function(Audio audio) onPlayPressedFunction;
  final void Function(Audio audio) onStopPressedFunction;
  final void Function(Audio audio) onPausePressedFunction;

  AudioListItemWidget({
    required this.audio,
    required this.onPlayPressedFunction,
    required this.onStopPressedFunction,
    required this.onPausePressedFunction,
  });

  @override
  Widget build(BuildContext context) {
    String subTitleStr =
        'Duration ${(audio.audioDuration == null) ? '?' : audio.audioDuration!.HHmm()}. Size ${(audio.audioFileSize == null) ? '?' : audio.audioFileSize} bytes. Downloaded at ${(audio.downloadSpeed.isFinite) ? audio.downloadSpeed.toInt() : 'infinite '} bytes/sec';
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(audio.originalVideoTitle),
      subtitle: Text(subTitleStr),
      trailing: _buildPlayButton(),
    );
  }

  Widget _buildPlayButton() {
    return Consumer<AudioPlayerVM>(
      builder: (context, audioPlayerViewModel, child) {
        if (audio.isPlaying) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              (audio.isPaused)
                  ? IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        audioPlayerViewModel.pause(audio);
                      },
                    )
                  : IconButton(
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
