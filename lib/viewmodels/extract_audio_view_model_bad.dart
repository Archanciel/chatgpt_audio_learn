import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/dir_util.dart';

class AudioClip {
  final File file;
  final Duration duration;

  AudioClip({required this.file, required this.duration});

  static AudioClip fromFile(File file) {
    // Use flutter_sound to get duration of audio file
    final durationInSeconds = 0; // replace with actual duration
    final duration = Duration(seconds: durationInSeconds);
    return AudioClip(file: file, duration: duration);
  }
}

class AudioViewModel extends ChangeNotifier {
  late File _audioFile;
  late AudioClip _audioClip;
  final _audioPlayer = AudioPlayer();

  void setAudioFile(File audioFile) {
    _audioFile = audioFile;
  }

  void extractAudioClip(Duration start, Duration end) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/audio_clip.mp3';

    await _audioPlayer.setUrl(_audioFile.path);
    final startPosition = start.inMilliseconds / 1000.0;
    final endPosition = end.inMilliseconds / 1000.0;
    final duration = endPosition - startPosition;
    final Duration? clip = await _audioPlayer.getDuration();
    final clipDuration = clip!.inMilliseconds / 1000.0;

    if (clipDuration >= endPosition) {
      await _audioPlayer.setReleaseMode(ReleaseMode.STOP);
      await _audioPlayer.seek(Duration(milliseconds: startPosition.toInt()));
      await _audioPlayer.setDuration(Duration(seconds: duration.toInt()));
      await _audioPlayer.setUrl(_audioFile.path, isLocal: true);

      await _audioPlayer.onPlayerCompletion.first;
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(await _audioPlayer.readAsBytes());

      _audioClip = AudioClip.fromFile(outputFile);
      notifyListeners();
    } else {
      // Handle case where end position is beyond the end of the audio clip
    }
  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory(await DirUtil.getPlaylistDownloadHomePath());
  }
}
