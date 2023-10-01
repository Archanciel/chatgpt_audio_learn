// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
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
  int _currentIndex = 0; // initial selected screen

  // data for CurvedNavigationBar

  late List<StatelessWidget> _screensLst;

  late List<String> _screenTitlesLst;

  late List<Widget> _curvedNavigationBarItemIconsLst;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // data for CurvedNavigationBar

    _screensLst = [
      const ScreenOne(),
      const ScreenTwo(),
      const ScreenThree(),
      const ScreenFour(),
    ];

    _screenTitlesLst = [
      'Screen One',
      'Screen Two',
      'Screen Three',
      'Screen Four',
    ];

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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    /// For iOS platform: SafeArea and ClipRect needed
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text(
              _screenTitlesLst[_currentIndex],
              style: TextStyle(
                color: Colors.yellowAccent.withOpacity(0.8),
              ),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: DraggableScrollableSheet(
            initialChildSize: 1.0, // necessary to use full screen surface
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                // necessary for scrolling to work
                child: GestureDetector(
                  // enables that when clicking above or below a
                  // TextField, the keyboard is hidden. Otherwise,
                  // the keyboard remains open !
                  onTap: () {
                    // call this method here to hide soft keyboard
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                        ),
                        child: SizedBox(
                            height: screenHeight - 80, // ok on S8
                            child: _screensLst[_currentIndex]),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: screenHeight - 193, // ok on S8
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            iconTheme: const IconThemeData(
                              color: Colors.blueGrey,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CurvedNavigationBar(
                                key: _navigationKey,
                                color: Colors.white,
                                buttonBackgroundColor:
                                    Colors.yellow.withOpacity(0.5),
                                backgroundColor: Colors.transparent,
                                height: 55,
                                animationCurve: Curves.easeInOut,
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                index: _currentIndex,
                                items: _curvedNavigationBarItemIconsLst,
                                onTap: (index) => setState(() {
                                  _currentIndex = index;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  const ScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent.withOpacity(0.2),
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
      color: Colors.lightBlueAccent.withOpacity(0.2),
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
      color: Colors.lightBlueAccent.withOpacity(0.2),
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
      color: Colors.lightBlueAccent.withOpacity(0.2),
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
