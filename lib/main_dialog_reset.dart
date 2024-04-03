import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  // If app runs on Windows, Linux or MacOS, set the app size
  // and position

  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await getScreenList().then((List<Screen> screens) {
      // Assumez que vous voulez utiliser le premier écran (principal)
      final Screen screen = screens.first;
      final Rect screenRect = screen.visibleFrame;

      // Définissez la largeur et la hauteur de votre fenêtre
      const double windowWidth = 900;
      const double windowHeight = 1300;

      // Calculez la position X pour placer la fenêtre sur le côté droit de l'écran
      final double posX = screenRect.right - windowWidth;
      // Optionnellement, ajustez la position Y selon vos préférences
      final double posY = (screenRect.height - windowHeight) / 2;

      final Rect windowRect =
          Rect.fromLTWH(posX, posY, windowWidth, windowHeight);
      setWindowFrame(windowRect);
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dialogue avec Widgets'),
        ),
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _showCustomDialog(context),
        child: const Text('Afficher le dialogue'),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isChecked = false;
  String? _selectedItem;
  final List<String> _items = ['add an element']; // CORRECTION

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dialogue Personnalisé'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration:
                  const InputDecoration(hintText: 'Entrez quelque chose'),
            ),
            CheckboxListTile(
              title: const Text('Cochez-moi'),
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Sélectionnez un élément'),
              value: _selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                  _items.add('Élément ${_items.length}');
                });
              },
              items: _items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Réinitialiser'),
          onPressed: _resetFields,
        ),
        TextButton(
          child: const Text('Fermer'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _resetFields() {
    setState(() {
      _textEditingController.clear();
      _isChecked = false;
      _selectedItem = null;
      _items.clear();
    });
  }
}
