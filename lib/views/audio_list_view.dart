// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/download_playlist.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_download_view_model_yt.dart';
import '../viewmodels/audio_download_view_model_dio.dart';
import '../viewmodels/audio_download_view_model_ja.dart';
import '../viewmodels/audio_player_view_model.dart';

class AudioListView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController(
      text:
          'https://youtube.com/playlist?list=PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0');

  final AudioPlayerViewModel _audioPlayerViwModel = AudioPlayerViewModel();

  @override
  Widget build(BuildContext context) {
    final AudioDownloadViewModelYt audioDownloadViewModelYt =
        Provider.of<AudioDownloadViewModelYt>(context);
    final AudioDownloadViewModelDio audioDownloadViewModelDio =
        Provider.of<AudioDownloadViewModelDio>(context);
   final AudioDownloadViewModelJa audioDownloadViewModelJa =
        Provider.of<AudioDownloadViewModelJa>(context);

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
                audioDownloadViewModelYt
                    .downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio'),
          ),
          ElevatedButton(
            onPressed: () {
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModelDio
                    .downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio Io'),
          ),
          ElevatedButton(
            onPressed: () {
              final String playlistUrl = _textEditingController.text.trim();
              DownloadPlaylist playlistToDownload =
                  DownloadPlaylist(url: playlistUrl);

              if (playlistUrl.isNotEmpty) {
                audioDownloadViewModelJa
                    .downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio Io'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioDownloadViewModelYt.audioLst.length,
              itemBuilder: (BuildContext context, int index) {
                final audio = audioDownloadViewModelYt.audioLst[index];
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
          Expanded(
            child: ListView.builder(
              itemCount: audioDownloadViewModelDio.audioLst.length,
              itemBuilder: (BuildContext context, int index) {
                final audio = audioDownloadViewModelDio.audioLst[index];
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
          Expanded(
            child: ListView.builder(
              itemCount: audioDownloadViewModelJa.audioLst.length,
              itemBuilder: (BuildContext context, int index) {
                final audio = audioDownloadViewModelJa.audioLst[index];
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
