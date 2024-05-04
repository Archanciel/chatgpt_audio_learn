import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: IconButton(
              icon: const Icon(Icons.help_outline,
              size: 50.0,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => HelpDialog(
                    helpItems: [
                      HelpItem(
                          titleLocalKey: 'Default Application',
                          contentLocalKey:
                              'If no option is selected, the default playback speed will apply only to newly created playlists.'),
                      HelpItem(
                          titleLocalKey: 'Modifying Existing Playlists',
                          contentLocalKey:
                              'By selecting this option, all existing playlists will use the new playback speed.'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Contains the title local key and content local key of a help item.
/// 
/// The local key is the key of the element of the help item defined
/// in the app_en.arb or app_fr.arb localization files.
class HelpItem {
  final String titleLocalKey;
  final String contentLocalKey;

  HelpItem({
    required this.titleLocalKey,
    required this.contentLocalKey,
  });
}

class HelpDialog extends StatelessWidget {
  final List<HelpItem> helpItems;

  const HelpDialog({
    Key? key,
    required this.helpItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int number = 1;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var item in helpItems) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${number++}. ${item.titleLocalKey}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(item.contentLocalKey),
              ),
            ],
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
