import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/list_model.dart';
import '../viewmodels/list_vm.dart';

class ExpandableListView extends StatefulWidget {
  @override
  State<ExpandableListView> createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                key: Key('toggle_button'),
                onPressed: () {
                  Provider.of<ListVM>(context, listen: false).toggleList();
                },
                child: const Text('Toggle List'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                key: Key('delete_button'),
                onPressed: Provider.of<ListVM>(context).isButton1Enabled
                    ? () {
                        Provider.of<ListVM>(context, listen: false)
                            .deleteSelectedItem(context);
                      }
                    : null,
                child: const Text('Delete'),
              ),
            ),
            Expanded(
              child: IconButton(
                key: Key('move_up_button'),
                onPressed: Provider.of<ListVM>(context).isButton2Enabled
                    ? () {
                        Provider.of<ListVM>(context, listen: false)
                            .moveSelectedItemUp();
                      }
                    : null,
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 50,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                key: Key('move_down_button'),
                onPressed: Provider.of<ListVM>(context).isButton3Enabled
                    ? () {
                        Provider.of<ListVM>(context, listen: false)
                            .moveSelectedItemDown();
                      }
                    : null,
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
        Consumer<ListVM>(
          builder: (context, listViewModel, child) {
            if (listViewModel.isListExpanded) {
              return Expanded(
                child: ListView.builder(
                  itemCount: listViewModel.items.length,
                  itemBuilder: (context, index) {
                    ListItem item = listViewModel.items[index];
                    return ListTile(
                      title: Text(item.name),
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
