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
  final TextEditingController _smallTextFieldController =
      TextEditingController();

  @override
  void dispose() {
    _playlistUrlController.dispose();
    _smallTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kDefaultMargin),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // must exist to avoid exception
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6, // controls the height ratio
                        child: TextField(
                          key: const Key('playlistUrlTextField'),
                          maxLines: 1,
                          style: const TextStyle(fontSize: 15),
                          controller: _playlistUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Playlist URL',
                            hintText:
                                'https://www.youtube.com/playlist?list=PL4cUxeGkcC9gjxLvV4VEkZ6H6H4yWuS58',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height:
                            kRowHeightSeparator, // controls the space between TextFields
                      ),
                      Expanded(
                        flex: 4, // controls the height ratio
                        child: TextField(
                          key: const Key('smallTextField'),
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                          controller:
                              _smallTextFieldController, // define a new controller for this field
                          decoration: const InputDecoration(
                            labelText: 'Small Field',
                            hintText: 'Enter something here',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ],
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
          ),
          SizedBox(
            height: kRowHeightSeparator,
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
