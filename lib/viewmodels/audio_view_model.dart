import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/audio.dart';

class AudioViewModel extends ChangeNotifier {
  final List<Audio> _audios = [];
  List<Audio> get audios => _audios;
  YoutubeExplode _yt = YoutubeExplode();
  final _audioDownloadDir = Directory('/storage/emulated/0/Download');


  YoutubeExplode get yt => _yt;
  set yt(YoutubeExplode yt) => _yt = yt;

  Future<void> fetchAudios(String link) async {
    final playlistId = PlaylistId.parsePlaylistId(link);
    final playlist = await _yt.playlists.get(playlistId);

    await for (var video in _yt.playlists.getVideos(playlistId)) {
      final streamManifest =
          await _yt.videos.streamsClient.getManifest(video.id);
      final audioStreamInfo =
          streamManifest.audioOnly.first;

      final audioTitle = video.title;
      final audioDuration = video.duration;

      final filePath = '${_audioDownloadDir.path}/${video.title}.mp3';


      final audio = Audio(title: audioTitle, duration: audioDuration!, filePath: filePath);
      _audios.add(audio);

      // Download the audio file
      await _downloadAudioFile(video, audioStreamInfo, filePath);
      // Do something with the downloaded file
    }

    notifyListeners();
  }

  Future<void> _downloadAudioFile(
      Video video, AudioStreamInfo audioStreamInfo, String filePath) async {
    final yt = YoutubeExplode();

    final output = File(filePath).openWrite();
    final stream = await yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(output);
  }
}
