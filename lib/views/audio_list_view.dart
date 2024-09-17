// dart file located in lib\views

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants_old.dart';
import '../utils/ui_util.dart';
import '../viewmodels/playlist_edit_vm.dart';
import 'audio_list_item_widget.dart';

import '../models/audio.dart';
import '../viewmodels/audio_download_vm.dart';
import '../viewmodels/audio_player_vm.dart';

class AudioListView extends StatefulWidget {
  const AudioListView({super.key});

  @override
  State<AudioListView> createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  final TextEditingController _textEditingController = TextEditingController();

  final AudioPlayerVM _audioPlayerViwModel = AudioPlayerVM();

  //define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //request permission from initStateMethod
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  /// Requires adding the lines below to the main and debug AndroidManifest.xml
  /// files in order to work on S20 - Android 13 !
  ///     <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
  ///     <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
  ///     <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb && !Platform.isWindows) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      //ensure build method is called
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final AudioDownloadVM audioDownloadViewModel =
        Provider.of<AudioDownloadVM>(context);
    if (_textEditingController.text.isEmpty) {
      _textEditingController.text =
          (audioDownloadViewModel.listOfPlaylist.isNotEmpty)
              ? audioDownloadViewModel.listOfPlaylist[0].url
              : '';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            key: const Key('playlistUrlTextField'),
            controller: _textEditingController,
            decoration: const InputDecoration(
              labelText: 'Youtube playlist link',
              hintText: 'Enter the link to the youtube playlist',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AudioDownloadVM>(
              builder: (context, audioDownloadVM, child) {
                return ElevatedButton(
                  key: const Key('downLoadButton'),
                  onPressed: audioDownloadVM.isDownloading
                      ? null
                      : () {
                          final String playlistUrl =
                              _textEditingController.text.trim();
                          if (playlistUrl.isNotEmpty) {
                            audioDownloadVM.downloadPlaylistAudios(
                              playlistUrl: playlistUrl,
                            );
                          }
                        },
                  child: Text(AppLocalizations.of(context)!.downloadAudio),
                );
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: audioDownloadViewModel.isHighQuality,
                  onChanged: (bool? value) {
                    audioDownloadViewModel.setAudioQuality(
                        isHighQuality: value ?? false);
                  },
                ),
                Text(AppLocalizations.of(context)!.audioQuality),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            PlaylistEditVM playlistEditVM = PlaylistEditVM();

            playlistEditVM.removeVideoFromPlaylist();
          },
          child: const Text('Remove video from playlist'),
        ),
        // displaying the currently downloading audiodownload
        // informations.
        Consumer<AudioDownloadVM>(
          builder: (context, audioDownloadVM, child) {
            if (audioDownloadVM.isDownloading) {
              String downloadProgressPercent =
                  '${(audioDownloadVM.downloadProgress * 100).toStringAsFixed(1)}%';
              String downloadFileSize =
                  UiUtil.formatLargeIntValue(audioDownloadVM.currentDownloadingAudio.audioFileSize);
              String downloadSpeed =
                  '${UiUtil.formatLargeIntValue(audioDownloadVM.lastSecondDownloadSpeed)}/sec';
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      audioDownloadVM
                          .currentDownloadingAudio.originalVideoTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    LinearProgressIndicator(
                        value: audioDownloadVM.downloadProgress),
                    const SizedBox(height: 10.0),
                    Text(
                      '$downloadProgressPercent ${AppLocalizations.of(context)!.ofPreposition} $downloadFileSize ${AppLocalizations.of(context)!.atPreposition} $downloadSpeed',
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
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
