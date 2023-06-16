import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import '../viewmodels/expandable_playlist_list_vm.dart';

class ExpandablePlaylistListView extends StatefulWidget {
  const ExpandablePlaylistListView({super.key});

  @override
  State<ExpandablePlaylistListView> createState() =>
      _ExpandablePlaylistListViewState();
}

class _ExpandablePlaylistListViewState
    extends State<ExpandablePlaylistListView> {
  final TextEditingController _playlistUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                key: const Key('playlistUrlTextField'),
                controller: _playlistUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'Youtube playlist URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 3.0,
            ),
            SizedBox(
              width: 100.0,
              child: ElevatedButton(
                key: const Key('addPlaylistButton'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.0))),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 3.0),
                  ),
                ),
                onPressed: () {
                  final String playlistUrl = _playlistUrlController.text.trim();
                  if (playlistUrl.isNotEmpty) {
                    Provider.of<ExpandablePlaylistListVM>(context,
                            listen: false)
                        .addItem(playlistUrl);
                    _playlistUrlController.clear();
                  }
                },
                child: Text('Add Playlist'),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                key: const Key('toggle_button'),
                onPressed: () {
                  Provider.of<ExpandablePlaylistListVM>(context, listen: false)
                      .toggleList();
                },
                child: const Text('Toggle List'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                key: const Key('delete_button'),
                onPressed: Provider.of<ExpandablePlaylistListVM>(context)
                        .isButton1Enabled
                    ? () {
                        Provider.of<ExpandablePlaylistListVM>(context,
                                listen: false)
                            .deleteSelectedItem(context);
                      }
                    : null,
                child: const Text('Delete'),
              ),
            ),
            Expanded(
              child: IconButton(
                key: const Key('move_up_button'),
                onPressed: Provider.of<ExpandablePlaylistListVM>(context)
                        .isButton2Enabled
                    ? () {
                        Provider.of<ExpandablePlaylistListVM>(context,
                                listen: false)
                            .moveSelectedItemUp();
                      }
                    : null,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 50,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                key: const Key('move_down_button'),
                onPressed: Provider.of<ExpandablePlaylistListVM>(context)
                        .isButton3Enabled
                    ? () {
                        Provider.of<ExpandablePlaylistListVM>(context,
                                listen: false)
                            .moveSelectedItemDown();
                      }
                    : null,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
        Consumer<ExpandablePlaylistListVM>(
          builder: (context, listViewModel, child) {
            if (listViewModel.isListExpanded) {
              return Expanded(
                child: ListView.builder(
                  itemCount: listViewModel.items.length,
                  itemBuilder: (context, index) {
                    Playlist item = listViewModel.items[index];
                    return ListTile(
                      title: Text(item.url),
                      trailing: Checkbox(
                        value: item.isSelected,
                        onChanged: (value) {
                          listViewModel.selectItem(context, index);
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
