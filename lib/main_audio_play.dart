import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  final String audioPathFileName;
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  Duration get position => _position;
  Duration get duration => _duration;
  Duration get remaining => _duration - _position;

  AudioPlayerViewModel({required this.audioPathFileName}) {
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  void _initializePlayer() async {
    await _audioPlayer.setSourceAsset(audioPathFileName);
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });
  }

  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  void playAudio() {
    _audioPlayer.play(AssetSource(audioPathFileName));
    notifyListeners();
  }

  void pauseAudio() {
    _audioPlayer.pause();
    notifyListeners();
  }

  void seekBy(Duration duration) {
    _audioPlayer.seek(_position + duration);
    notifyListeners();
  }

  void seekTo(Duration position) {
    _audioPlayer.seek(position);
    notifyListeners();
  }

  void skipToStart() {
    _audioPlayer.seek(Duration.zero);
    notifyListeners();
  }

  void skipToEnd() {
    _audioPlayer.seek(_duration);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final String audioPathFileName;

  const AudioPlayerScreen({super.key, required this.audioPathFileName});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final double _audioIconSizeSmaller = 50;
  final double _audioIconSizeMedium = 60;
  final double _audioIconSizeLarge = 90;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AudioPlayerViewModel(audioPathFileName: widget.audioPathFileName),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            Column(
              children: [
                const SizedBox(height: 16.0),
                _buildSlider(),
                _buildPositions(),
              ],
            ),
            _buildPlayButtons(),
            _buildPositionButtons()
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Consumer<AudioPlayerViewModel>(
      builder: (context, viewModel, child) {
        return Slider(
          value: viewModel.position.inSeconds.toDouble(),
          min: 0.0,
          max: viewModel.duration.inSeconds.toDouble(),
          onChanged: (double value) {
            viewModel.seekTo(Duration(seconds: value.toInt()));
          },
        );
      },
    );
  }

  Widget _buildPositions() {
    return Consumer<AudioPlayerViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(viewModel.position),
                style: const TextStyle(fontSize: 20.0),
              ),
              Text(
                _formatDuration(viewModel.remaining),
                style: const TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Widget _buildPlayButtons() {
    return Consumer<AudioPlayerViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: _audioIconSizeMedium,
              onPressed: () => viewModel.skipToStart(),
              icon: const Icon(Icons.skip_previous),
            ),
            IconButton(
              iconSize: _audioIconSizeLarge,
              onPressed: viewModel.isPlaying
                  ? viewModel.pauseAudio
                  : viewModel.playAudio,
              icon: Icon(viewModel.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            IconButton(
              iconSize: _audioIconSizeMedium,
              onPressed: () => viewModel.skipToEnd(),
              icon: const Icon(Icons.skip_next),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPositionButtons() {
    return Consumer<AudioPlayerViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _audioIconSizeMedium - 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () =>
                                viewModel.seekBy(const Duration(minutes: -1)),
                            icon: const Icon(Icons.fast_rewind),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () =>
                                viewModel.seekBy(const Duration(seconds: -10)),
                            icon: const Icon(Icons.fast_rewind),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () =>
                                viewModel.seekBy(const Duration(seconds: 10)),
                            icon: const Icon(Icons.fast_forward),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: _audioIconSizeMedium,
                            onPressed: () =>
                                viewModel.seekBy(const Duration(minutes: 1)),
                            icon: const Icon(Icons.fast_forward),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '1 m',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '10 s',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '10 s',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '1 m',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AudioPlayerScreen(
      audioPathFileName: 'audio/myAudio.mp3',
    ),
  ));
}
