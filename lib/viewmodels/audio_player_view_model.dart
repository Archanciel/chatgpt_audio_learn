// dart file located in lib\viewmodels

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import '../models/audio.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  Future<void> play(Audio audio) async {
    final file = File(audio.filePathName);
    if (!await file.exists()) {
      print('File not found: ${audio.filePathName}');
    }

    await audio.audioPlayer.play(DeviceFileSource(audio.filePathName));
    audio.isPlaying = true;

    notifyListeners();
  }

  Future<void> pause(Audio audio) async {
    // Stop the audio
    if (audio.isPaused) {
      await audio.audioPlayer.resume();
    } else {
      await audio.audioPlayer.pause();
    }

    audio.invertPaused();

    notifyListeners();
  }

  Future<void> stop(Audio audio) async {
    // Stop the audio
    await audio.audioPlayer.stop();
    audio.isPlaying = false;
    notifyListeners();
  }
}
