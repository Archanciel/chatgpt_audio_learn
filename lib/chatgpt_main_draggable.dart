import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  double _sliderValue = 0;

  final List<IconData> _icons = [
    Icons.timer,
    Icons.book,
    Icons.list,
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _sliderValue = index.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _icons.asMap().entries.map((entry) {
              return IconButton(
                icon: Icon(entry.value),
                onPressed: () => _onPageChanged(entry.key),
                color: _currentIndex == entry.key ? Colors.blue : Colors.grey,
              );
            }).toList(),
          ),
          Slider(
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
                _currentIndex = value.round();
              });
            },
            divisions: _icons.length - 1,
            max: (_icons.length - 1).toDouble(),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: _icons.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Center(
                  child: Icon(
                    _icons[index],
                    size: 200,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
