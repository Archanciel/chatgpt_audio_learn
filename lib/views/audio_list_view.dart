// dart file located in lib\views

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/playlist.dart';
import '../viewmodels/playlist_edit_vm.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_download_vm.dart';
import '../viewmodels/audio_player_vm.dart';

enum ViewModelType { youtube, justAudio }

class AudioListView extends StatefulWidget {
  @override
  State<AudioListView> createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  final TextEditingController _textEditingController =
      TextEditingController(text: kPlaylistUrl);

  final AudioPlayerVM _audioPlayerViwModel = AudioPlayerVM();

  @override
  Widget build(BuildContext context) {
    final AudioDownloadVM audioDownloadViewModel =
        Provider.of<AudioDownloadVM>(context);
    return Column(
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
            Playlist playlistToDownload = Playlist(url: playlistUrl);

            if (playlistUrl.isNotEmpty) {
              audioDownloadViewModel.downloadPlaylistAudios(
                playlistToDownload: playlistToDownload,
                audioDownloadViewModelType: AudioDownloadViewModelType.youtube,
              );
            }
          },
          child: const Text('Download Audio Youtube'),
        ),
        ElevatedButton(
          onPressed: () {
            final String playlistUrl = _textEditingController.text.trim();
            Playlist playlistToDownload = Playlist(url: playlistUrl);

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
        ElevatedButton(
          onPressed: () {
            PlaylistEditVM playlistEditVM = PlaylistEditVM();

            playlistEditVM.removeVideoFromPlaylist();
          },
          child: const Text('Remove video from playlist'),
        ),
        Expanded(
          child: Consumer<AudioDownloadVM>(
            builder: (context, audioDownloadVM, child) {
              return ListView.builder(
                itemCount: (audioDownloadVM.listOfPlaylist.isEmpty)
                    ? 0
                    : audioDownloadVM.listOfPlaylist[0].playableAudioLst.length,
                itemBuilder: (BuildContext context, int index) {
                  final audio =
                      audioDownloadVM.listOfPlaylist[0].playableAudioLst[index];
                  return AudioListItemWidget(
                    audio: audio,
                    onPlayPressedFunction: (Audio audio) {
                      _audioPlayerViwModel.play(audio);
                    },
                    onStopPressedFunction: (Audio audio) {
                      _audioPlayerViwModel.stop(audio);
                    },
                    onPausePressedFunction: (Audio audio) {
                      _audioPlayerViwModel.pause(audio);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
