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
  final Color kDarkAndLightIconColor =
      Color.fromARGB(246, 44, 61, 255); // rgba(44, 61, 246, 255)
  final Color kDarkAndLightDisabledIconColorOnDialog = Colors.grey.shade600;

  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _items = ['add an element']; // CORRECTION
  bool _applySortFilterToAudioDownloadView = false;
  bool _applySortFilterToAudioPlayerView = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dialogue Personnalisé'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Download Audio',
                  ),
                  Checkbox(
                    key: const Key('audioDownloadViewCheckbox'),
                    fillColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return kDarkAndLightDisabledIconColorOnDialog;
                        }
                        return kDarkAndLightIconColor;
                      },
                    ),
                    value: _applySortFilterToAudioDownloadView,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _applySortFilterToAudioDownloadView = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Audio Player',
                  ),
                  Checkbox(
                    key: const Key('audioPlayerViewCheckbox'),
                    fillColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return kDarkAndLightDisabledIconColorOnDialog;
                        }
                        return kDarkAndLightIconColor;
                      },
                    ),
                    value: _applySortFilterToAudioPlayerView,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _applySortFilterToAudioPlayerView = newValue!;
                      });
                    },
                  ),
                ],
              ),
            )
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
      _applySortFilterToAudioDownloadView = false;
      _applySortFilterToAudioPlayerView = false;
      _items.clear();
    });
  }
}
