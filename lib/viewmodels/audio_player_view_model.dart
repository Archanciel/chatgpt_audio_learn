import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import '../models/audio.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerViewModel({required AudioPlayer audioPlayer})
      : _audioPlayer = audioPlayer;

  Future<void> play(Audio audio) async {
    final file = File(audio.filePath);
    if (!await file.exists()) {
      print('File not found: ${audio.filePath}');
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(audio.filePath));
    audio.isPlaying = true;

    notifyListeners();
  }

  Future<void> pause(Audio audio) async {
    // Stop the audio
    if (audio.isPaused) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }

    audio.invertPaused();

    notifyListeners();
  }

  Future<void> stop(Audio audio) async {
    // Stop the audio
    await _audioPlayer.stop();
    audio.isPlaying = false;
    notifyListeners();
  }
}
