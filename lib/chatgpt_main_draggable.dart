import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_audio_play.dart';

const Color kIconColor =
    Color.fromARGB(246, 44, 61, 255); // rgba(44, 61, 246, 255)
const Color kButtonColor = Color(0xFF3D3EC2);

// Constants for repeated values
const Duration pageTransitionDuration = Duration(milliseconds: 20);
const Curve pageTransitionCurve = Curves.ease;

enum Language {
  english,
  french,
}

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
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

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            theme: _darkTheme,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<IconData> _screenNavigationIconLst = [
    Icons.download,
    Icons.edit,
    Icons.audiotrack,
  ];

  final List<Widget> _appBarTitleWidgetLst = [];

  final List<StatefulWidget> _screenWidgetLst = [];

  @override
  void initState() {
    super.initState();

    _appBarTitleWidgetLst.add(
      AppBarTitleForPlaylistView(playlistViewHomePage: widget),
    );

    _appBarTitleWidgetLst.add(
      AppBarTitleForPlaylistView(playlistViewHomePage: widget),
    );

    _appBarTitleWidgetLst.add(
      AppBarTitleForPlaylistView(playlistViewHomePage: widget),
    );

    _screenWidgetLst.add(StringListView(onPageChange: _changePage));
    _screenWidgetLst.add(const IconScreenWidget(iconData: Icons.book));
    _screenWidgetLst.add(AudioPlayerView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitleWidgetLst[_currentIndex],
      ),
      body: Column(
        children: [
          _buildPageView(_screenWidgetLst[_currentIndex]),
          _buildIconButtonRow(),
        ],
      ),
    );
  }

  Expanded _buildPageView(StatefulWidget screenWidget) {
    return Expanded(
      child: PageView.builder(
        itemCount:
            _screenNavigationIconLst.length, // specifies the number of pages
        //                           that can be swiped by dragging left or right
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return screenWidget;
        },
      ),
    );
  }

  Row _buildIconButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _screenNavigationIconLst.asMap().entries.map((entry) {
        return IconButton(
          icon: Icon(entry.value),
          onPressed: () => _changePage(entry.key),
          color: _currentIndex == entry.key ? Colors.blue : Colors.grey,
          iconSize:
              24, // Set this if you want to control the icon's visual size
          padding: EdgeInsets
              .zero, // This is crucial to avoid default IconButton padding
        );
      }).toList(),
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
    });
  }
}

class StringListScreenWidget extends StatefulWidget {
  final List<String> items;

  const StringListScreenWidget({super.key, required this.items});

  @override
  State<StringListScreenWidget> createState() => _StringListScreenWidgetState();
}

class _StringListScreenWidgetState extends State<StringListScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(widget.items[index]));
      },
    );
  }
}

class IconScreenWidget extends StatefulWidget {
  final IconData iconData;

  const IconScreenWidget({super.key, required this.iconData});

  @override
  State<IconScreenWidget> createState() => _IconScreenWidgetState();
}

class _IconScreenWidgetState extends State<IconScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        widget.iconData,
        size: 200,
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;

    notifyListeners();
  }
}

/// When the PlaylistView screen is displayed, the AppBarTitlePlaylistView
/// is displayed in the AppBar title:
class AppBarTitleForPlaylistView extends StatelessWidget {
  const AppBarTitleForPlaylistView({
    super.key,
    required this.playlistViewHomePage,
  });

  final MyHomePage playlistViewHomePage;

  @override
  Widget build(BuildContext context) {
    // converting audio_learn corresponding code to this does not
    // solve anything
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            'Title',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17),
          ),
        ),
        // InkWell(
        //   key: const Key('image_open_youtube'),
        //   onTap: () async {
        //     await playlistViewHomePage.openUrlInExternalApp(
        //       url: kYoutubeUrl,
        //     );
        //   },
        //   child: Image.asset('assets/images/youtube-logo-png-2069.png',
        //       height: 38),
        // ),
      ],
    );
  }
}

class StringListView extends StatefulWidget {


  final Function(int) onPageChange;

  const StringListView({super.key, required this.onPageChange});

  @override
  State<StringListView> createState() => _StringListViewState();
}

class _StringListViewState extends State<StringListView> {
  final List<String> stringLst = [
    'Timer 1',
    'Timer 2',
    'Timer 3',
    'Timer 4',
    'Timer 5',
    'Timer 6',
    'Timer 7',
    'Timer 8',
    'Timer 9',
    'Timer 10',
    'Timer 11',
    'Timer 12',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stringLst.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(stringLst[index]),
          onTap: () {
            widget.onPageChange(2);  // 2 for the third page
          },
        );
      },
    );
  }
}
