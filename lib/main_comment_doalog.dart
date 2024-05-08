import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Bookmark Dialog',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Bookmark Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBookmarkDialog(context),
          child: const Text('Show Bookmark Dialog'),
        ),
      ),
    );
  }

  void _showBookmarkDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Marque-page'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextField for Title
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez le titre ici',
                  ),
                ),
                // const SizedBox(height: 10),
                // Multiline TextField for Comments
                TextField(
                  controller: commentController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Entrez vos commentaires ici',
                  ),
                ),
                const SizedBox(height: 30),
                // Non-editable Text for Audio File Details
                // Audio Playback Controls
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        '231127-001208-Jancovici - débat avec Bernard Friot - Aix en Provence - 16_11_2023\n23-11-23.mp3',
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.fast_rewind),
                              onPressed: null,
                            ),
                            Text('2:20:45'),
                            IconButton(
                              icon: Icon(Icons.fast_forward),
                              onPressed: null,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: null,
                          padding: EdgeInsets.all(0), // Remove extra padding
                          constraints:
                              BoxConstraints(), // Ensure the button takes minimal space
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ANNULER'),
            ),
            TextButton(
              onPressed: () {
                // Logique de confirmation (sauvegarder les commentaires, etc.)
                print('Titre: ${titleController.text}');
                print('Commentaire: ${commentController.text}');
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
