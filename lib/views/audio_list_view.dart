// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/download_playlist.dart';
import '../viewmodels/audio_download_VM.dart';
import '../viewmodels/audio_download_view_model_dio.dart';
import '../viewmodels/audio_download_view_model_ja.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_download_view_model_yt.dart';
import '../viewmodels/audio_player_view_model.dart';

enum ViewModelType { youtube, dio, justAudio }

class AudioListView extends StatefulWidget {
  @override
  State<AudioListView> createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  final TextEditingController _textEditingController = TextEditingController(
      text:
          'https://youtube.com/playlist?list=PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0');

  final AudioPlayerViewModel _audioPlayerViwModel = AudioPlayerViewModel();

  @override
  Widget build(BuildContext context) {
    AudioDownloadVM audioDownloadViewModel =
        Provider.of<AudioDownloadViewModelDio>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Audio Downloader'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Youtube playlist link',
                hintText: 'Enter the link to the youtube playlist',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              audioDownloadViewModel = Provider.of<AudioDownloadViewModelYt>(
                context,
                listen: false,
              );
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModel
                    .downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio'),
          ),
          ElevatedButton(
            onPressed: () {
              audioDownloadViewModel = Provider.of<AudioDownloadViewModelDio>(
                context,
                listen: false,
              );
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModel
                    .downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio Io'),
          ),
          ElevatedButton(
            onPressed: () {
              audioDownloadViewModel = Provider.of<AudioDownloadViewModelJa>(
                context,
                listen: false,
              );
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModel
                    .downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio Io'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioDownloadViewModel.audioLst.length,
              itemBuilder: (BuildContext context, int index) {
                final audio = audioDownloadViewModel.audioLst[index];
                return AudioListItemWidget(
                  audio: audio,
                  onPlayPressed: (Audio audio) {
                    _audioPlayerViwModel.play(audio);
                  },
                  onStopPressed: (Audio audio) {
                    _audioPlayerViwModel.stop(audio);
                  },
                  onPausePressed: (Audio audio) {
                    _audioPlayerViwModel.pause(audio);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
