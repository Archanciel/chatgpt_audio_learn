import 'package:flutter/material.dart';

import 'constants.dart';

Future<void> main() async {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AudioLearn',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('AudioLearn'),
          ],
        ),
      ),
      body: ExpandablePlaylistListView(),
    );
  }
}

class ExpandablePlaylistListView extends StatefulWidget {
  final MaterialStateProperty<RoundedRectangleBorder>
      appElevatedButtonRoundedShape =
      MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRoundedButtonBorderRadius)));

  ExpandablePlaylistListView({super.key});

  @override
  State<ExpandablePlaylistListView> createState() =>
      _ExpandablePlaylistListViewState();
}

class _ExpandablePlaylistListViewState
    extends State<ExpandablePlaylistListView> {
  final TextEditingController _playlistUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kDefaultMargin),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  key: const Key('playlistUrlTextField'),
                  controller: _playlistUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Playlist URL)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: kRowWidthSeparator,
              ),
              SizedBox(
                width: kSmallButtonWidth,
                child: ElevatedButton(
                  key: const Key('addPlaylistButton'),
                  style: ButtonStyle(
                    shape: widget.appElevatedButtonRoundedShape,
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          horizontal: kSmallButtonInsidePadding),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Add'),
                ),
              ),
              const SizedBox(
                width: kRowWidthSeparator,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 75,
                child: ElevatedButton(
                  key: const Key('playlist_toggle_button'),
                  style: ButtonStyle(
                    shape: widget.appElevatedButtonRoundedShape,
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          horizontal: kSmallButtonInsidePadding),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Playlists'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
