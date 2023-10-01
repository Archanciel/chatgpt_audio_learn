// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

final Color screenBackgroundColor = Colors.lightBlueAccent.withOpacity(0.2);

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi screen app',
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  final _navigationKey = GlobalKey<CurvedNavigationBarState>();
  final PageController _pageController = PageController();

  int _currentIndex = 0; // initial selected screen

  late List<StatelessWidget> _screensLst;
  late List<String> _screenTitlesLst;
  late List<Widget> _curvedNavigationBarItemIconsLst;

  @override
  void initState() {
    super.initState();

    // Initialize your screens
    _screensLst = [const ScreenOne(), const ScreenTwo(), const ScreenThree(), const ScreenFour()];

    // Initialize screen titles
    _screenTitlesLst = [
      'Screen One',
      'Screen Two',
      'Screen Three',
      'Screen Four'
    ];

    // Initialize navigation icons
    _curvedNavigationBarItemIconsLst = [
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarPageOne'),
        child: Image.asset(
          "assets/images/calc_sleep_duration_blue_trans.png",
          width: 36,
          height: 36,
        ),
      ),
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarPageTwo'),
        child: Image.asset(
          "assets/images/time_difference_blue_trans.png",
          width: 35,
          height: 35,
        ),
      ),
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarPageThree'),
        child: Image.asset(
          "assets/images/add_duration_to_date_time_blue_trans.png",
          width: 36,
          height: 36,
        ),
      ),
      KeyedSubtree(
        // enables adding a key to the image useful for integration testing
        key: const ValueKey('navBarPageFour'),
        child: Image.asset(
          "assets/images/calculate_time_blue_trans.png",
          width: 38,
          height: 38,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitlesLst[_currentIndex],
              style: TextStyle(
                color: Colors.yellowAccent.withOpacity(0.8),
              ),
            ),
            elevation: 0,
            centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _updateCurrentIndex,
        children: _screensLst,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navigationKey,
        index: _currentIndex,
        items: _curvedNavigationBarItemIconsLst,
        buttonBackgroundColor: Colors.yellow.withOpacity(0.5),
        backgroundColor: screenBackgroundColor,
        onTap: (index) {
          _updateCurrentIndex(index);
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  const ScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenBackgroundColor,
      child: const Center(
        child: Text(
          'Screen One',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenBackgroundColor,
      child: const Center(
        child: Text(
          'Screen Two',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}

class ScreenThree extends StatelessWidget {
  const ScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenBackgroundColor,
      child: const Center(
        child: Text(
          'Screen Three',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}

class ScreenFour extends StatelessWidget {
  const ScreenFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenBackgroundColor,
      child: const Center(
        child: Text(
          'Screen Four',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
