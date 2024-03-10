import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom CheckBox AlertDialog Example'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Change this value to see the effect
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    CheckBoxAlertDialogWidget(initiallyChecked: true),
              );
            },
            child: Text('Show AlertDialog checkbox true'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Change this value to see the effect
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    CheckBoxAlertDialogWidget(initiallyChecked: false),
              );
            },
            child: Text('Show AlertDialog checkbox false'),
          ),
        ],
      ),
    );
  }
}

class CheckBoxAlertDialogWidget extends StatefulWidget {
  final bool initiallyChecked;

  CheckBoxAlertDialogWidget({Key? key, required this.initiallyChecked})
      : super(key: key);

  @override
  _CheckBoxAlertDialogWidgetState createState() =>
      _CheckBoxAlertDialogWidgetState();
}

class _CheckBoxAlertDialogWidgetState extends State<CheckBoxAlertDialogWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initiallyChecked;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('AlertDialog with Checkbox'),
      content: CheckboxListTile(
        title: Text("Check me"),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
