import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/audio.dart';

class AudioViewModel extends ChangeNotifier {
  final List<Audio> _audioLst = [];
  List<Audio> get audioLst => _audioLst;

  YoutubeExplode _yt = YoutubeExplode();
  YoutubeExplode get yt => _yt;
  set yt(YoutubeExplode yt) => _yt = yt;

  final Directory _audioDownloadDir = Directory('/storage/emulated/0/Download');

  Future<void> fetchAudios(String link) async {
    final String? playlistId = PlaylistId.parsePlaylistId(link);
    final Playlist playlist = await _yt.playlists.get(playlistId);

    await for (var video in _yt.playlists.getVideos(playlistId)) {
      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(video.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final String audioTitle = video.title;
      final Duration? audioDuration = video.duration;

      final String filePath = '${_audioDownloadDir.path}/${video.title}.mp3';

      final Audio audio = Audio(
          title: audioTitle, duration: audioDuration!, filePath: filePath);
      _audioLst.add(audio);

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
