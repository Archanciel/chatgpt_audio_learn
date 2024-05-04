import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Help Display Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => HelpDialog(
                  helpItems: [
                    HelpItem(
                        title: 'Default Application',
                        content:
                            'If no option is selected, the default playback speed will apply only to newly created playlists.'),
                    HelpItem(
                        title: 'Modifying Existing Playlists',
                        content:
                            'By selecting this option, all existing playlists will use the new playback speed.'),
                  ],
                ),
              );
            },
            child: Text('Show Help'),
          ),
        ),
      ),
    );
  }
}

class HelpItem {
  final String title;
  final String content;

  HelpItem({required this.title, required this.content});
}

class HelpDialog extends StatelessWidget {
  final List<HelpItem> helpItems;

  const HelpDialog({Key? key, required this.helpItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        item.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(item.content),
              ),
            ],
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
