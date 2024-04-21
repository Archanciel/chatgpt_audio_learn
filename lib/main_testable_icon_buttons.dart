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
                        const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const IconButtonsDialogWidget();
                  },
                );
              },
              child: const Text('Show Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionButtonsRow() {
    ButtonStateManager buttonLayoutManager = ButtonStateManager(
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
              onPressed: buttonLayoutManager
                      .getTwoButtonsState(_currentPositionValue)[0]
                  ? () {
                      _currentPositionValue -= 1;
                      setState(() {});
                    }
                  : null),
          IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.arrow_right),
              iconSize: 60.0,
              onPressed: buttonLayoutManager
                      .getTwoButtonsState(_currentPositionValue)[1]
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
    ButtonStateManager buttonLayoutManager = ButtonStateManager(
      minValue: 30,
      maxValue: 70,
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
                  buttonLayoutManager.getTwoButtonsState(_currentVolumeValue)[0]
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
                  buttonLayoutManager.getTwoButtonsState(_currentVolumeValue)[1]
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

class ButtonStateManager {
  final double _minValue;
  final double _maxValue;

  ButtonStateManager({
    required double minValue,
    required double maxValue,
  })  : _minValue = minValue,
        _maxValue = maxValue;

  List<bool> getTwoButtonsState(double currentValue) {
    return [
      currentValue > _minValue,
      currentValue < _maxValue,
    ];
  }
}

class IconButtonsDialogWidget extends StatefulWidget {
  const IconButtonsDialogWidget({super.key});

  @override
  _IconButtonsDialogWidgetState createState() =>
      _IconButtonsDialogWidgetState();
}

class _IconButtonsDialogWidgetState
    extends State<IconButtonsDialogWidget> {
  double _currentPositionValue = 1;
  double _currentVolumeValue = 50;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sort and Filter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildPositionButtonsRow() {
    ButtonStateManager buttonLayoutManager = ButtonStateManager(
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
              onPressed: buttonLayoutManager
                      .getTwoButtonsState(_currentPositionValue)[0]
                  ? () {
                      _currentPositionValue -= 1;
                      setState(() {});
                    }
                  : null),
          IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.arrow_right),
              iconSize: 60.0,
              onPressed: buttonLayoutManager
                      .getTwoButtonsState(_currentPositionValue)[1]
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
    ButtonStateManager buttonLayoutManager = ButtonStateManager(
      minValue: 30,
      maxValue: 70,
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
                  buttonLayoutManager.getTwoButtonsState(_currentVolumeValue)[0]
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
                  buttonLayoutManager.getTwoButtonsState(_currentVolumeValue)[1]
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