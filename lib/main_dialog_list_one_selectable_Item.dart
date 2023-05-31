import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Playlist {
  int id;
  String title;

  Playlist({
    required this.id,
    required this.title,
  });
}

class PlaylistProvider with ChangeNotifier {
  List<Playlist> listOfPlaylist = [
    Playlist(id: 1, title: 'title1'),
    Playlist(id: 2, title: 'title2'),
    Playlist(id: 3, title: 'title3'),
    Playlist(id: 4, title: 'title4'),
  ];

  Playlist? selectedPlaylist;

  void selectPlaylist(Playlist? playlist) {
    selectedPlaylist = playlist;
    notifyListeners();
  }
}

class PlaylistDialog extends StatefulWidget {
  const PlaylistDialog({super.key});

  @override
  _PlaylistDialogState createState() => _PlaylistDialogState();
}

class _PlaylistDialogState extends State<PlaylistDialog> {
  Playlist? _selectedPlaylist;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, _) => AlertDialog(
        title: const Text('Select a Playlist'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: playlistProvider.listOfPlaylist.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile<Playlist>(
                title: Text(playlistProvider.listOfPlaylist[index].title),
                value: playlistProvider.listOfPlaylist[index],
                groupValue: _selectedPlaylist,
                onChanged: (Playlist? value) {
                  setState(() {
                    _selectedPlaylist = value;
                  });
                },
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_selectedPlaylist != null) {
                playlistProvider.selectPlaylist(_selectedPlaylist!);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
          ElevatedButton(
            onPressed: () {
              playlistProvider.selectPlaylist(null);
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        // <== Add this
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Map of List Display')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const PlaylistDialog(),
                    ).then((_) {
                      PlaylistProvider playlistProvider =
                          Provider.of<PlaylistProvider>(context, listen: false);
                      Playlist? selectedPlaylist =
                          playlistProvider.selectedPlaylist;
                      print(selectedPlaylist?.title ?? 'No playlist selected');
                      // Now you can use selectedPlaylist here
                    });
                  },
                  child: const Text('Select one playlist'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlaylistProvider(),
      child: const MyApp(),
    ),
  );
}
