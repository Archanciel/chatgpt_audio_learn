import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioExtractorView(),
    );
  }
}

class AudioExtractorView extends StatefulWidget {
  @override
  _AudioExtractorViewState createState() => _AudioExtractorViewState();
}

class _AudioExtractorViewState extends State<AudioExtractorView> {
  final TextEditingController _startPositionTextEditingController =
      TextEditingController(text: '0:00:09');
  final TextEditingController _currentPositionTextEditingController =
      TextEditingController(text: '0:00:16');
  final TextEditingController _endPositionTextEditingController =
      TextEditingController(text: '0:00:18');
  double _currentSliderValue = 0;

  @override
  void dispose() {
    _startPositionTextEditingController.dispose();
    _currentPositionTextEditingController.dispose();
    _endPositionTextEditingController.dispose();

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
            _buildExtractPositionDataLayout(),
            _buildModifyExtractPositionButtonsRow(),
            _buildSlider(),
            _buildStopPlayButtonsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractPositionDataLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Start'),
            Text('Current'),
            Text('End'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              // Button to decrease extraction start time
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.remove_circle_outline,
              ),
              iconSize: 20,
              onPressed: () {},
            ),
            IconButton(
              // Button to increase extraction start time
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              iconSize: 20,
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  // Utiliser InputDecoration pour personnaliser l'apparence
                  isDense:
                      true, // Ajoutez ceci pour une meilleure contrôle de la taille
                  border: InputBorder.none, // Aucune bordure sous le TextField
                  // Si vous voulez une bordure quand le TextField est sélectionné:
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 3.0), // Reduces height
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                controller: _startPositionTextEditingController,
              ),
            ),
            const SizedBox(width: 5), // Ajout d'un espace entre les rangées
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  // Utiliser InputDecoration pour personnaliser l'apparence
                  isDense:
                      true, // Ajoutez ceci pour une meilleure contrôle de la taille
                  border: InputBorder.none, // Aucune bordure sous le TextField
                  // Si vous voulez une bordure quand le TextField est sélectionné:
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 3.0), // Reduces height
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                controller: _currentPositionTextEditingController,
              ),
            ),
            const SizedBox(width: 5), // Ajout d'un espace entre les rangées
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  // Utiliser InputDecoration pour personnaliser l'apparence
                  isDense:
                      true, // Ajoutez ceci pour une meilleure contrôle de la taille
                  border: InputBorder.none, // Aucune bordure sous le TextField
                  // Si vous voulez une bordure quand le TextField est sélectionné:
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 3.0), // Reduces height
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                controller: _endPositionTextEditingController,
              ),
            ),
            IconButton(
              // Button to decrease extraction end time
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.remove_circle_outline,
              ),
              iconSize: 20,
              onPressed: () {},
            ),
            IconButton(
              // Button to increase extraction end time
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              iconSize: 20,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModifyExtractPositionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.skip_previous),
          onPressed: () {/* Rewind action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.fast_rewind),
          onPressed: () {/* Rewind action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.copyright),
          iconSize: 18.0,
          onPressed: () {/* Rewind action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.arrow_left),
          iconSize: 31.0,
          onPressed: () {/* Play action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.arrow_right),
          iconSize: 31.0,
          onPressed: () {/* Play action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.copyright),
          iconSize: 18.0,
          onPressed: () {/* Rewind action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.fast_forward),
          onPressed: () {/* Fast forward action */},
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.skip_next),
          onPressed: () {/* Rewind action */},
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 100,
      divisions: 100,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  Widget _buildStopPlayButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: const Text('Stop'),
          onPressed: () {/* Stop action */},
        ),
        ElevatedButton(
          child: const Text('Play'),
          onPressed: () {/* Play action */},
        ),
      ],
    );
  }
}
