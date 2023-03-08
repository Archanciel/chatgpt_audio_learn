import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../models/download_playlist.dart';
import 'audio_download_VM.dart';

class Track {
  final String title;
  final String artist;
  final Uri audio;

  Track({
    required this.title,
    required this.artist,
    required this.audio,
  });
}

class AudioDownloadViewModelJa extends ChangeNotifier
    implements AudioDownloadVM {
  Future<void> downloadPlaylistAudios(
      DownloadPlaylist playlistToDownload) async {
    final player = AudioPlayer();
    final playlistResponse = await http.get(Uri.parse(playlistToDownload.url));
    final playlistJson = json.decode(playlistResponse.body);
    final playlist = [
      for (var item in playlistJson)
        Track(
          title: item['title'],
          artist: item['artist'],
          audio: Uri.parse(item['audio']),
        ),
    ];
    final audioSource = ConcatenatingAudioSource(children: [
      for (var track in playlist) AudioSource.uri(track.audio),
    ]);
    await player.setAudioSource(audioSource);
    final directory = Directory('downloads');
    if (!await directory.exists()) {
      await directory.create();
    }
    for (var i = 0; i < playlist.length; i++) {
      final audioFile = File('${directory.path}/audio_$i.mp3');
      final audioUrl = playlist[i].audio.toString();
      final audioResponse = await http.get(Uri.parse(audioUrl));
      await audioFile.writeAsBytes(audioResponse.bodyBytes);
    }
  }
}
