import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const DisplayDialogContainingListView(),
    );
  }
}

class DisplayDialogContainingListView extends StatefulWidget {
  const DisplayDialogContainingListView({super.key});

  @override
  State<DisplayDialogContainingListView> createState() => _DisplayDialogContainingListViewState();
}

class _DisplayDialogContainingListViewState extends State<DisplayDialogContainingListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Problem Solving #5"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Dialog"),
        onPressed: () => dialoger(context),
      ),
    );
  }
}

dynamic dialoger(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Listview"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 30,
              itemBuilder: (_, i) {
                return Text("Item $i");
              },
            ),
          ),
        );
      });
}
