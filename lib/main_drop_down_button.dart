import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DropdownButtonExample(),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  @override
  _DropdownButtonExampleState createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DropdownButton Example')),
      body: Center(
        child: _buildSortFilterParametersDropdownButton(),
      ),
    );
  }

  Row _buildSortFilterParametersDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem(value: "Option 1", child: Text("Option 1")),
      const DropdownMenuItem(value: "Option 2", child: Text("Option 2")),
      // Add more items here
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: selectedValue,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          hint: const Text('Select an Option'),
        ),
      ],
    );
  }
}
