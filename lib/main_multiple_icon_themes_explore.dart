import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum EnumIconType { iconOne, iconTwo, iconThree }

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// Define custom icon themes for light theme
  final IconThemeData lightThemeIconOne =
      const IconThemeData(color: Colors.blue);
  final IconThemeData lightThemeIconTwo =
      const IconThemeData(color: Colors.green);
  final IconThemeData lightThemeIconThree =
      const IconThemeData(color: Colors.purple);

// Define custom icon themes for dark theme
  final IconThemeData darkThemeIconOne = const IconThemeData(color: Colors.red);
  final IconThemeData darkThemeIconTwo =
      const IconThemeData(color: Colors.orange);
  final IconThemeData darkThemeIconThree =
      const IconThemeData(color: Colors.yellow);

// Define the light and dark themes
  static final ThemeData themeDataLight = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyMedium: ThemeData.light()
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black),
          titleMedium: ThemeData.light()
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black),
        ),
      );

  static final ThemeData themeDataDark = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.copyWith(
          bodyMedium: ThemeData.dark()
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
          titleMedium: ThemeData.dark()
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      );

  IconThemeData getIconTheme(ThemeProvider themeProvider,
      {EnumIconType iconType = EnumIconType.iconOne}) {
    ThemeData currentTheme =
        themeProvider.isDarkMode ? themeDataDark : themeDataLight;
    switch (iconType) {
      case EnumIconType.iconOne:
        return themeProvider.isDarkMode ? darkThemeIconOne : lightThemeIconOne;
      case EnumIconType.iconTwo:
        return themeProvider.isDarkMode ? darkThemeIconTwo : lightThemeIconTwo;
      case EnumIconType.iconThree:
        return themeProvider.isDarkMode
            ? darkThemeIconThree
            : lightThemeIconThree;
      default:
        return currentTheme.iconTheme; // Default icon theme
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.isDarkMode ? themeDataDark : themeDataLight,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                    icon: Icon(themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode),
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  children: [
                    // This icon button uses the default icon theme
                    // of the current theme
                    IconButton(
                      onPressed: () {
                        // Votre code ici
                      },
                      icon: const Icon(Icons.download_outlined,
                          size: 35), // Icône
                    ),
                    // This icon button uses the EnumIconType.iconOne
                    // icon theme
                    IconButton(
                      onPressed: () {
                        // Votre code ici
                      },
                      icon: IconTheme(
                        data: getIconTheme(themeProvider,
                            iconType: EnumIconType.iconOne),
                        child: const Icon(Icons.download_for_offline, size: 35),
                      ),
                      // Icône
                    ),
                    IconButton(
                      onPressed: () {
                        // Votre code ici
                      },
                      icon: IconTheme(
                        data: getIconTheme(themeProvider,
                            iconType: EnumIconType.iconTwo),
                        child: const Icon(Icons.download_rounded, size: 35),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Alarm icon only: '),
                        IconTheme(
                          data: getIconTheme(themeProvider,
                              iconType: EnumIconType.iconThree),
                          child: const Icon(Icons.access_alarm, size: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
