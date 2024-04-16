import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedValue;
  List<String> options = ["Option 1", "Option 2", "Option 3"];
  final FocusNode dropdownFocusNode = FocusNode(); // Step 1: Define a FocusNode

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = options
        .map((option) => DropdownMenuItem(
              value: option,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(option),
                  (option == selectedValue)
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              options.remove(option);
                              if (selectedValue == option) {
                                selectedValue =
                                    null; // Reset selected value if the deleted option was selected
                              }
                              // Step 3: Shift Focus after deletion
                              FocusScope.of(context).requestFocus(FocusNode());
                              // Navigator.pop(context);
                            });
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ))
        .toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic DropdownButton Example'),
        ),
        body: Center(
          child: DropdownButton<String>(
            value: selectedValue,
            focusNode: dropdownFocusNode, // Step 2: Attach the FocusNode
            hint: const Text("Select Option"),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            items: dropdownItems,
          ),
        ),
      ),
    );
  }
}
