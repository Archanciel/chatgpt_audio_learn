import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:chatgpt_audio_learn/constants.dart';
import 'package:chatgpt_audio_learn/models/playlist.dart';

void main() {
  group('AudioDownloadVM', () {
    late AudioDownloadVM audioDownloadVM;

    setUp(() {
      audioDownloadVM = AudioDownloadVM();
    });

    test('Check initial values', () {
      expect(audioDownloadVM.listOfPlaylist[0].title, kUniquePlaylistTitle);
      expect(audioDownloadVM.listOfPlaylist[0].url, kUniquePlaylistUrl);
      expect(audioDownloadVM.isDownloading, false);
      expect(audioDownloadVM.downloadProgress, 0.0);
      expect(audioDownloadVM.lastSecondDownloadSpeed, 0);
      expect(audioDownloadVM.isHighQuality, false);
    });
  });
}
