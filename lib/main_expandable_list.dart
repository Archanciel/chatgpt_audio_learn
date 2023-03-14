import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_audio_learn/viewmodels/list_vm.dart';
import 'package:chatgpt_audio_learn/views/expandable_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListVM(),
      child: MaterialApp(
        title: 'MVVM Example',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('MVVM Example'),
          ),
          body: ExpandableListView(),
        ),
      ),
    );
  }
}
