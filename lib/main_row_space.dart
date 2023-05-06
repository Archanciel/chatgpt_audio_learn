import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatelessWidget {
  final String audioUrl;

  AudioPlayerScreen({required this.audioUrl});

  final double _audioIconSizeSmaller = 50;

  final double _audioIconSizeMedium = 60;

  final double _audioIconSizeLarge = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPositionButtons(),
        ],
      ),
    );
  }

  Widget _buildPositionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: _audioIconSizeMedium - 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                  iconSize: _audioIconSizeMedium,
                  onPressed: () => print(''),
                  icon: const Icon(Icons.fast_rewind),
                ),
              ),
              Expanded(
                child: IconButton(
                  iconSize: _audioIconSizeMedium,
                  onPressed: () => print(''),
                  icon: const Icon(Icons.fast_rewind),
                ),
              ),
              Expanded(
                child: IconButton(
                  iconSize: _audioIconSizeMedium,
                  onPressed: () => print(''),
                  icon: const Icon(Icons.fast_forward),
                ),
              ),
              Expanded(
                child: IconButton(
                  iconSize: _audioIconSizeMedium,
                  onPressed: () => print(''),
                  icon: const Icon(Icons.fast_forward),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Text(
                '1 m',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '10 s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '10 s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21.0,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '1 m',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AudioPlayerScreen(
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
  ));
}
