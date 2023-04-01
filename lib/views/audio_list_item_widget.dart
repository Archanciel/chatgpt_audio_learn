// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/audio.dart';
import '../utils/ui_util.dart';
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
    String subTitleStr = buildSubTitle();
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(audio.originalVideoTitle),
      subtitle: Text(subTitleStr),
      trailing: _buildPlayButton(),
    );
  }

  String buildSubTitle() {
    String subTitle;

    Duration? audioDuration = audio.audioDuration;
    int audioFileSize = audio.audioFileSize;
    String audioFileSizeStr;

    audioFileSizeStr = UiUtil.formatLargeIntValue(audioFileSize);

    int audioDownloadSpeed = audio.audioDownloadSpeed;
    String audioDownloadSpeedStr;

    if (audioDownloadSpeed.isInfinite) {
      audioDownloadSpeedStr = 'infinite o/sec';
    } else {
      audioDownloadSpeedStr = '${UiUtil.formatLargeIntValue(audioDownloadSpeed)}/sec';
    }

    if (audioDuration == null) {
      subTitle = '?';
    } else {
      subTitle =
          '${audioDuration.HHmmss()}. Size $audioFileSizeStr. Downloaded at $audioDownloadSpeedStr';
    }
    return subTitle;
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
