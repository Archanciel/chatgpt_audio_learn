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
      home: MediaControlScreen(),
    );
  }
}

class MediaControlScreen extends StatefulWidget {
  @override
  _MediaControlScreenState createState() => _MediaControlScreenState();
}

class _MediaControlScreenState extends State<MediaControlScreen> {
  double _currentSliderValue = 0;

  Widget _buildControlButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove_circle_outline), // Bouton pour diminuer le temps de début
          onPressed: () {/* Action pour diminuer le temps de début */},
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline), // Bouton pour augmenter le temps de début
          onPressed: () {/* Action pour augmenter le temps de début */},
        ),
        IconButton(
          icon: Icon(Icons.skip_previous), // Bouton pour aller au clip précédent
          onPressed: () {/* Action pour aller au clip précédent */},
        ),
        IconButton(
          icon: Icon(Icons.play_circle_filled), // Bouton de lecture
          onPressed: () {/* Action de lecture */},
        ),
        IconButton(
          icon: Icon(Icons.skip_next), // Bouton pour aller au clip suivant
          onPressed: () {/* Action pour aller au clip suivant */},
        ),
        IconButton(
          icon: Icon(Icons.remove_circle_outline), // Bouton pour diminuer le temps de fin
          onPressed: () {/* Action pour diminuer le temps de fin */},
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline), // Bouton pour augmenter le temps de fin
          onPressed: () {/* Action pour augmenter le temps de fin */},
        ),
      ],
    );
  }

  Widget _buildTimeDisplayRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            initialValue: '00:09',
          ),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            initialValue: '00:16',
          ),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            initialValue: '00:18',
          ),
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

  Widget _buildPlaybackControlRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.fast_rewind),
          onPressed: () {/* Rewind action */},
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {/* Play action */},
        ),
        IconButton(
          icon: Icon(Icons.fast_forward),
          onPressed: () {/* Fast forward action */},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Control'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildControlButtonRow(),
            SizedBox(height: 20), // Ajout d'un espace entre les rangées
            _buildTimeDisplayRow(),
            _buildSlider(),
            _buildPlaybackControlRow(),
          ],
        ),
      ),
    );
  }
}
