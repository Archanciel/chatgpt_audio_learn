import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ElevatedButton with Icon'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Votre code ici
              print('Button Pressed');
            },
            style: ElevatedButton.styleFrom(
              // Style optionnel du bouton
              backgroundColor: Colors.blue, // Couleur de fond
              foregroundColor: Colors.white, // Couleur du texte
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Padding du bouton
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min, // Pour s'assurer que le Row n'occupe pas plus d'espace que nécessaire
              children: <Widget>[
                Icon(Icons.download_outlined, size: 15), // Icône
                Text('Un'), // Texte
              ],
            ),
          ),
        ),
      ),
    );
  }
}
