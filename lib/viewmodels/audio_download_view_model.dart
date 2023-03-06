// dart file located in lib\viewmodels

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/audio.dart';

class AudioDownloadViewModel extends ChangeNotifier {
  final List<Audio> _audioLst = [];
  List<Audio> get audioLst => _audioLst;

  final YoutubeExplode _yt = YoutubeExplode();

  final Directory _audioDownloadDir = Directory('/storage/emulated/0/Download');

  Future<void> fetchAudios(String playlistUrl) async {
    final String? playlistId = PlaylistId.parsePlaylistId(playlistUrl);
    final Playlist playlist = await _yt.playlists.get(playlistId);

    await for (var video in _yt.playlists.getVideos(playlistId)) {
      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(video.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final String audioTitle = video.title;
      final Duration? audioDuration = video.duration;

      String validAudioFileName =
          _replaceUnauthorizedDirOrFileNameChars(video.title);

      final String filePath =
          '${_audioDownloadDir.path}/${validAudioFileName}.mp3';

      final Audio audio = Audio(
        title: audioTitle,
        duration: audioDuration!,
        filePath: filePath,
        audioPlayer: AudioPlayer(),
      );
      _audioLst.add(audio);

      // Download the audio file
      await _downloadAudioFile(video, audioStreamInfo, filePath);
      // Do something with the downloaded file

      notifyListeners();
    }
  }

  Future<void> _downloadAudioFile(
    Video video,
    AudioStreamInfo audioStreamInfo,
    String filePath,
  ) async {
    final IOSink output = File(filePath).openWrite();
    final Stream<List<int>> stream =
        _yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(output);
    print('********************* *******************');
  }

  String _replaceUnauthorizedDirOrFileNameChars(String rawFileName) {
    // Replace '|' by ' if '|' is located at end of file name
    if (rawFileName.endsWith('|')) {
      rawFileName = rawFileName.substring(0, rawFileName.length - 1);
    }

    // Replace '||' by '_' since YoutubeDL replaces '||' by '_'
    rawFileName = rawFileName.replaceAll('||', '|');

    // Replace '//' by '_' since YoutubeDL replaces '//' by '_'
    rawFileName = rawFileName.replaceAll('//', '/');

    final charToReplace = {
      '\\': '',
      '/': '_', // since YoutubeDL replaces '/' by '_'
      ':': ' -', // since YoutubeDL replaces ':' by ' -'
      '*': ' ',
      // '.': '', point is not illegal in file name
      '?': '',
      '"': "'", // since YoutubeDL replaces " by '
      '<': '',
      '>': '',
      '|': '_', // since YoutubeDL replaces '|' by '_'
      // "'": '_', apostrophe is not illegal in file name
    };

    // Replace all multiple characters in a string based on translation table created by dictionary
    String validFileName = rawFileName;
    charToReplace.forEach((key, value) {
      validFileName = validFileName.replaceAll(key, value);
    });

    // Since YoutubeDL replaces '?' by ' ', determining if a video whose title
    // ends with '?' has already been downloaded using
    // replaceUnauthorizedDirOrFileNameChars(videoTitle) + '.mp3' can be executed
    // if validFileName.trim() is NOT done.
    return validFileName.trim();
  }
}
