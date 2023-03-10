import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/download_playlist.dart';
import '../viewmodels/audio_download_view_model.dart';

class CustomElevatedButton extends StatefulWidget {
  final TextEditingController textEditingController;

  const CustomElevatedButton({
    super.key,
    required this.textEditingController,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    print('+++++++++++++ CustomElevatedButton rebuilt !');
    final AudioDownloadViewModel audioDownloadViewModel =
        Provider.of<AudioDownloadViewModel>(context);

    return ElevatedButton(
      onPressed: () {
        final String playlistUrl = widget.textEditingController.text.trim();
        DownloadPlaylist playlistToDownload =
            DownloadPlaylist(url: playlistUrl);

        if (playlistUrl.isNotEmpty) {
          audioDownloadViewModel.downloadPlaylistAudios(
            playlistToDownload: playlistToDownload,
            audioDownloadViewModelType: AudioDownloadViewModelType.youtube,
          );
        }
      },
      child: const Text('Download Audio'),
    );
  }
}
