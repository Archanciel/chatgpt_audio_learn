// lib/main.dart

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider Icons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Types d'Activité"),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _changePage(0),
          ),
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () => _changePage(1),
          ),
          IconButton(
            icon: Icon(Icons.layers),
            onPressed: () => _changePage(2),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          Center(child: Text('Premier écran')),
          Center(child: Text('Deuxième écran')),
          Center(child: Text('Troisième écran')),
        ],
      ),
    );
  }

  _changePage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
