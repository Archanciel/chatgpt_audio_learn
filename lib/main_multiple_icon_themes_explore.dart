// ChatGpt chat: https://chat.openai.com/share/b5ed3be2-fa45-4539-bb7b-c1c046a38500

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MultipleIconType { iconOne, iconTwo, iconThree }

class ThemeProviderVM extends ChangeNotifier {
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

  /// Returns the icon theme data based on the theme currently applyed
  /// and the [MultipleIconType] enum value passed as parameter.
  ///
  /// The IconThemeData is used to wrap the icon widget.
  ///
  /// Example for the icon button:
  ///
  /// IconButton(
  ///   onPressed: () {
  ///   },
  ///   icon: IconTheme(
  ///     data: getIconThemeData(
  ///             themeProviderVM: themeProvider,
  ///             iconType: MultipleIconType.iconTwo,
  ///           ),
  ///     child: const Icon(Icons.download_outline, size: 35),
  ///   ),
  /// ),
  IconThemeData getIconThemeData({
    required ThemeProviderVM themeProviderVM,
    required MultipleIconType iconType,
  }) {
    switch (iconType) {
      case MultipleIconType.iconOne:
        return themeProviderVM.isDarkMode
            ? darkThemeIconOne
            : lightThemeIconOne;
      case MultipleIconType.iconTwo:
        return themeProviderVM.isDarkMode
            ? darkThemeIconTwo
            : lightThemeIconTwo;
      case MultipleIconType.iconThree:
        return themeProviderVM.isDarkMode
            ? darkThemeIconThree
            : lightThemeIconThree;
      default:
        ThemeData currentTheme =
            themeProviderVM.isDarkMode ? themeDataDark : themeDataLight;
        return currentTheme.iconTheme; // Default icon theme
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProviderVM()),
      ],
      child: Consumer<ThemeProviderVM>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.isDarkMode ? themeDataDark : themeDataLight,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Multiple icon themes'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Provider.of<ThemeProviderVM>(context, listen: false)
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
                        data: getIconThemeData(
                          themeProviderVM: themeProvider,
                          iconType: MultipleIconType.iconOne,
                        ),
                        child: const Icon(Icons.download_for_offline, size: 35),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Votre code ici
                      },
                      icon: IconTheme(
                        data: getIconThemeData(
                          themeProviderVM: themeProvider,
                          iconType: MultipleIconType.iconTwo,
                        ),
                        child: const Icon(Icons.download_rounded, size: 35),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Alarm icon only: '),
                        IconTheme(
                          data: getIconThemeData(
                            themeProviderVM: themeProvider,
                            iconType: MultipleIconType.iconThree,
                          ),
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
