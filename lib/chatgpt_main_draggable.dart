import 'package:flutter/material.dart';

const Color kIconColor =
    Color.fromARGB(246, 44, 61, 255); // rgba(44, 61, 246, 255)
const Color kButtonColor = Color(0xFF3D3EC2);

// Constants for repeated values
const Duration pageTransitionDuration = Duration(milliseconds: 300);
const Curve pageTransitionCurve = Curves.ease;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData _darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          background: Colors.black,
          surface: Colors.black,
        ),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    iconTheme: ThemeData.dark().iconTheme.copyWith(
          color: kIconColor, // Set icon color in dark mode
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kButtonColor, // Set button color in dark mode
        foregroundColor: Colors.white, // Set button text color in dark mode
      ),
    ),
    textTheme: ThemeData.dark().textTheme.copyWith(
          bodyMedium: ThemeData.dark()
              .textTheme
              .bodyMedium!
              .copyWith(color: kButtonColor),
          titleMedium: ThemeData.dark()
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
    checkboxTheme: ThemeData.dark().checkboxTheme.copyWith(
          checkColor: MaterialStateProperty.all(
            Colors.white, // Set Checkbox fill color
          ),
          fillColor: MaterialStateProperty.all(
            kIconColor, // Set Checkbox check color
          ),
        ),
    // determines the background color and border of
    // TextField
    inputDecorationTheme: const InputDecorationTheme(
      // fillColor: Colors.grey[900],
      fillColor: Colors.black,
      filled: true,
      border: OutlineInputBorder(),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white.withOpacity(0.3),
      selectionHandleColor: Colors.white.withOpacity(0.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkTheme,
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
  final PageController _pageController = PageController(); // Step 1

  final List<IconData> _icons = [
    Icons.timer,
    Icons.book,
    Icons.list,
  ];

  final List<String> _titles = [
    'Timer',
    'Book',
    'List',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_titles[_currentIndex]}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconButtonRow(), // Extracted widget
          _buildSlider(), // Extracted widget
          _buildPageView(), // Extracted widget
        ],
      ),
    );
  }

  SizedBox _buildIconButtonRow() {
    return SizedBox(
      height: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _icons.asMap().entries.map((entry) {
          return IconButton(
            icon: Icon(entry.value),
            onPressed: () => _changePage(entry.key),
            color: _currentIndex == entry.key ? Colors.blue : Colors.grey,
          );
        }).toList(),
      ),
    );
  }

Widget _buildSlider() {
  return SliderTheme(
    data: SliderThemeData(
      trackHeight: 2.0,
      activeTrackColor: kIconColor,
      inactiveTrackColor: kIconColor,
      thumbColor: kIconColor,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayColor: Colors.white.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      activeTickMarkColor: Colors.white,
      inactiveTickMarkColor: Colors.grey[300],
    ),
    child: Slider(
      value: _sliderValue,
      onChanged: (value) {
        setState(() {
          _sliderValue = value;
          _currentIndex = value.round();
        });
        _changePage(_currentIndex);
      },
      divisions: _icons.length - 1,
      max: (_icons.length - 1).toDouble(),
    ),
  );
}

  Expanded _buildPageView() {
    return Expanded(
      child: PageView.builder(
        itemCount: _icons.length,
        controller: _pageController,
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
    );
  }

  void _changePage(int index) {
    _onPageChanged(index);
    _pageController.animateToPage(
      index,
      duration: pageTransitionDuration, // Use constant
      curve: pageTransitionCurve, // Use constant
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _sliderValue = index.toDouble();
    });
  }
}
