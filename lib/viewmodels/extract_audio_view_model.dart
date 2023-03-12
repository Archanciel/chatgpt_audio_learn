import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../utils/dir_util.dart';

class AudioViewModel extends ChangeNotifier {
  late AudioPlayer _audioPlayer;
  late File _audioFile;
  late Duration _startPosition;
  late Duration _endPosition;
  bool _isExtractingClip = false;

  AudioViewModel() {
    _audioPlayer = AudioPlayer();
  }

  void setAudioFile(File audioFile) {
    _audioFile = audioFile;
  }

  void setClipStart(Duration start) {
    _startPosition = start;
  }

  void setClipEnd(Duration end) {
    _endPosition = end;
  }

  Future<void> extractAudioClip() async {
    _isExtractingClip = true;
    notifyListeners();

    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/audio_clip.mp3';

    final source = AudioSource.uri(Uri.parse(_audioFile.path));
    await _audioPlayer.play(_audioFile.path, isLocal: true, position: _startPosition);

    // Extract the audio clip
    final success = await _audioPlayer.extractSoundToFile(
      outputPath,
      // The start position of the clip
      start: _startPosition,
      // The end position of the clip
      end: _endPosition,
    );

    if (success) {
      // Create an AudioClip object from the output file
      final audioClip = AudioClip.fromFilePath(outputPath);
      _isExtractingClip = false;
      notifyListeners();
      // Do something with the extracted clip
    } else {
      // Handle the case where the extraction fails
      _isExtractingClip = false;
      notifyListeners();
    }
  }

  bool get isExtractingClip => _isExtractingClip;

  Future<Directory> getTemporaryDirectory() async {
    return Directory(await DirUtil.getPlaylistDownloadHomePath());
  }
}
