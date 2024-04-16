import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color effectiveSliderThumbColor = SliderTheme.of(context).thumbColor ??
        Theme.of(context).colorScheme.primary;

    print('Effective thumb color: $effectiveSliderThumbColor');
    return MaterialApp(
      title: 'Media Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioExtractorView(),
    );
  }
}

class AudioExtractorView extends StatefulWidget {
  const AudioExtractorView({super.key});

  @override
  _AudioExtractorViewState createState() => _AudioExtractorViewState();
}

class _AudioExtractorViewState extends State<AudioExtractorView> {
  double _currentPositionValue = 1;
  double _currentVolumeValue = 50;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Extractor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPositionButtonsRow(),
            const SizedBox(
              height: 10,
            ),
            Text('Current position: $_currentPositionValue'),
            const SizedBox(
              height: 30,
            ),
            _buildVolumeButtonsRow(),
            const SizedBox(
              height: 10,
            ),
            Text('Current volume: $_currentVolumeValue'),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionButtonsRow() {
    ButtonLayoutManager buttonLayoutManager = ButtonLayoutManager(
      minValue: 0,
      maxValue: 3,
    );
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.arrow_left),
              iconSize: 60.0,
              onPressed:
                  buttonLayoutManager.getButtonStates(_currentPositionValue)[0]
                      ? () {
                          _currentPositionValue -= 1;
                          setState(() {});
                        }
                      : null),
          IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.arrow_right),
              iconSize: 60.0,
              onPressed:
                  buttonLayoutManager.getButtonStates(_currentPositionValue)[1]
                      ? () {
                          _currentPositionValue += 1;
                          setState(() {});
                        }
                      : null),
        ],
      ),
    );
  }

  Widget _buildVolumeButtonsRow() {
    ButtonLayoutManager buttonLayoutManager = ButtonLayoutManager(
      minValue: 0,
      maxValue: 100,
    );
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 60.0,
              onPressed:
                  buttonLayoutManager.getButtonStates(_currentVolumeValue)[0]
                      ? () {
                          _currentVolumeValue -= 20;
                          setState(() {});
                        }
                      : null),
          IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.arrow_drop_up),
              iconSize: 60.0,
              onPressed:
                  buttonLayoutManager.getButtonStates(_currentVolumeValue)[1]
                      ? () {
                          _currentVolumeValue += 20;
                          setState(() {});
                        }
                      : null),
        ],
      ),
    );
  }
}

class ButtonLayoutManager {
  final double _minValue;
  final double _maxValue;

  ButtonLayoutManager({
    required double minValue,
    required double maxValue,
  })  : _minValue = minValue,
        _maxValue = maxValue;

  List<bool> getButtonStates(double currentValue) {
    return [
      currentValue > _minValue,
      currentValue < _maxValue,
    ];
  }
}
