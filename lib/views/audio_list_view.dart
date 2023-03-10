// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/download_playlist.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_download_view_model.dart';
import '../viewmodels/audio_player_view_model.dart';

enum ViewModelType { youtube, dio, justAudio }

class AudioListView extends StatefulWidget {
  @override
  State<AudioListView> createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  ViewModelType _currentViewModelType = ViewModelType.youtube;

  final TextEditingController _textEditingController = TextEditingController(
      text:
          'https://youtube.com/playlist?list=PLzwWSJNcZTMQL091OKgsyHnyvjSajDVpC');

  final AudioPlayerViewModel _audioPlayerViwModel = AudioPlayerViewModel();

  @override
  Widget build(BuildContext context) {
    final AudioDownloadViewModel audioDownloadViewModel =
        Provider.of<AudioDownloadViewModel>(context);

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
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModel.downloadPlaylistAudios(
                  playlistToDownload: playlistToDownload,
                  audioDownloadViewModelType:
                      AudioDownloadViewModelType.youtube,
                );
              }
            },
            child: const Text('Download Audio Youtube'),
          ),
          ElevatedButton(
            onPressed: () {
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModel.downloadPlaylistAudios(
                  playlistToDownload: playlistToDownload,
                  audioDownloadViewModelType:
                      AudioDownloadViewModelType.justAudio,
                );
              }
            },
            child: const Text('Download Audio just_audio'),
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
