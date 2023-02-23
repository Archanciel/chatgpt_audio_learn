import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/audio_view_model.dart';

class AudioListView extends StatelessWidget {
  final TextEditingController _textEditingController =
      TextEditingController(text: 'https://youtube.com/playlist?list=PLzwWSJNcZTMSw4qRX5glEyrL_IBvWbiqk');

  @override
  Widget build(BuildContext context) {
    final audioViewModel = Provider.of<AudioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Audio Downloader'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Youtube playlist link',
                hintText: 'Enter the link to the youtube playlist',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final link = _textEditingController.text.trim();
              if (link.isNotEmpty) {
                audioViewModel.fetchAudios(link);
              }
            },
            child: Text('Download Audio'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: audioViewModel.audios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(audioViewModel.audios[index].title),
                  subtitle: Text(
                      '${audioViewModel.audios[index].duration.inMinutes} mins'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
