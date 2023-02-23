import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/audio.dart';

class AudioViewModel extends ChangeNotifier {
  final List<Audio> _audios = [];
  List<Audio> get audios => _audios;

  Future<void> fetchAudios(String link) async {
    final yt = YoutubeExplode();
    final playlistId = PlaylistId.parsePlaylistId(link);
    final playlist = await yt.playlists.get(playlistId);

    await for (var video in yt.playlists.getVideos(playlistId)) {
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final audioStreamInfo =
          manifest.audioOnly.withHighestBitrate() ?? manifest.audioOnly.last;

      final audioTitle = video.title;
      final audioDuration = video.duration;

      final audio = Audio(title: audioTitle, duration: audioDuration!);
      _audios.add(audio);

      // Download the audio file
      final file = await _downloadAudioFile(video, audioStreamInfo);
      // Do something with the downloaded file
    }

    notifyListeners();
  }

  Future<File> _downloadAudioFile(Video video, AudioStreamInfo audioStreamInfo) async {
    final yt = YoutubeExplode();
    final stream = yt.videos.streamsClient.get(audioStreamInfo);

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${video.title}.mp3';
    final file = File(filePath);

    await file.writeAsBytes(await stream.first);
    return file;
  }
}
