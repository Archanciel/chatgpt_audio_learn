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

class ExpandablePlaylistListVM with ChangeNotifier {
  List<Playlist> listOfPlaylist = [
    Playlist(id: 1, title: 'title1'),
    Playlist(id: 2, title: 'title2'),
    Playlist(id: 3, title: 'title3'),
    Playlist(id: 4, title: 'very long very long very long very long very long very long title4'),
  ];

  Playlist? _selectedPlaylist;
  Playlist? get selectedPlaylist => _selectedPlaylist;

  void selectPlaylist(Playlist? playlist) {
    _selectedPlaylist = playlist;
    notifyListeners();
  }
}

class PlaylistOneSelectedDialogWidget extends StatelessWidget {
  const PlaylistOneSelectedDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpandablePlaylistListVM>(
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
                groupValue: playlistProvider.selectedPlaylist,
                onChanged: (Playlist? value) {
                  playlistProvider.selectPlaylist(value);
                },
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
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
                TextField(
                  readOnly: true,
                  maxLines: 1,
                  controller: TextEditingController(
                    text: Provider.of<ExpandablePlaylistListVM>(context)
                            .selectedPlaylist
                            ?.title ??
                        'No playlist selected',
                  ),
                ),
                SelectableText(Provider.of<ExpandablePlaylistListVM>(context).selectedPlaylist?.title ?? 'No playlist selected',
                maxLines: 1,),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const PlaylistOneSelectedDialogWidget(),
                    ).then((_) {
                      ExpandablePlaylistListVM expandablePlaylistVM =
                          Provider.of<ExpandablePlaylistListVM>(context,
                              listen: false);
                      Playlist? selectedPlaylist =
                          expandablePlaylistVM._selectedPlaylist;
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
      create: (context) => ExpandablePlaylistListVM(),
      child: const MyApp(),
    ),
  );
}
