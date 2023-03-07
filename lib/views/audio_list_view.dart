// dart file located in lib\views

import 'package:chatgpt_audio_learn/viewmodels/video_download_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/download_playlist.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_download_view_model.dart';
import '../viewmodels/audio_player_view_model.dart';

class AudioListView extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController(
      text:
          'https://youtube.com/playlist?list=PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0');

  final AudioPlayerViewModel _audioPlayerViwModel = AudioPlayerViewModel();

  @override
  Widget build(BuildContext context) {
    final AudioDownloadViewModel audioViewModel =
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
                audioViewModel.downloadPlaylistAudios(playlistToDownload);
              }
            },
            child: const Text('Download Audio'),
          ),
          ElevatedButton(
            onPressed: () async {
              VideoDownloadViewModel videoDownloadViewModel =
                  VideoDownloadViewModel();
              final String link = _textEditingController.text.trim();
              if (link.isNotEmpty) {
                DownloadPlaylist playlistToDownload =
                    DownloadPlaylist(url: link);
                await videoDownloadViewModel
                    .downloadPlaylistVideos(playlistToDownload);
                print('***************** **************');
                print(playlistToDownload.downloadedVideoLst);
                print('***************** **************');
              }
            },
            child: const Text('Download Video'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioViewModel.audioLst.length,
              itemBuilder: (BuildContext context, int index) {
                final audio = audioViewModel.audioLst[index];
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
