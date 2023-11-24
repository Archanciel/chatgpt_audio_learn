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
          child: ElevatedButton.icon(
            onPressed: () {
              // Your code here
              print('Button Pressed');
            },
            icon: const Icon(Icons.download_outlined,
            size: 15,), // Icon
            // icon: Image.asset(
            //   'assets/images/down_arrow_white.png', // Remplacez par le chemin de votre image
            //   width: 20.0, // Spécifiez la largeur souhaitée
            //   height: 20.0, // Spécifiez la hauteur souhaitée
            // ),
            label: const Text('Tél'), // Text
            style: ElevatedButton.styleFrom(
              // Optional: Button styling
              backgroundColor: Colors.blue, // Background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
