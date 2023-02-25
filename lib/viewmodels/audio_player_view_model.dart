import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayer/audioplayer.dart';

import '../models/audio.dart';

enum AudioPlayerState {
  playing,
  paused,
  stopped,
}

class AudioPlayerViewModel extends ChangeNotifier {
  AudioPlayerState _state = AudioPlayerState.stopped;
  AudioPlayerState get state => _state;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<AudioPlayerState> play(Audio audio) async {
    final file = File(audio.filePath);
    if (!await file.exists()) {
      print('File not found: ${audio.filePath}');
      return AudioPlayerState.stopped;
    }

    _audioPlayer.stop();
    await _audioPlayer.play(audio.filePath);
    audio.isPlaying = true;



    // Play the audio using the provided filePath
    _state = AudioPlayerState.playing;
    notifyListeners();
    return _state;
  }

  Future<AudioPlayerState> pause(Audio audio) async {
    // Stop the audio
      if (audio.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(audio.filePath);
    }

    audio.invertPlaying();

    _state = AudioPlayerState.paused;
    notifyListeners();
    return _state;
  }

  Future<AudioPlayerState> stop(Audio audio) async {
    // Stop the audio
    _state = AudioPlayerState.stopped;
    await _audioPlayer.stop();
    audio.isPlaying = false;
    notifyListeners();
    return _state;
  }
}
