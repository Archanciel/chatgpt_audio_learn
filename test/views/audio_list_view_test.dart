import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/theme_provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/language_provider.dart';
import 'package:chatgpt_audio_learn/views/audio_list_view.dart';

void main() {
  testWidgets('Language changes when selecting a different language',
      (WidgetTester tester) async {
    // Initialize providers
    final themeProvider = ThemeProvider();
    final languageProvider = LanguageProvider(initialLocale: Locale('en'));
    final audioDownloadVM = AudioDownloadVM();

    // Build the AudioListView widget with providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: audioDownloadVM),
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: languageProvider),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AudioListView(),
          ),
        ),
      ),
    );

// Check the initial language
    expect(find.text('Download audio'), findsOneWidget);

// Open the language selection popup menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

// Select the French language option
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

// Check if the language has changed
    expect(find.text('Télécharger audio'), findsOneWidget);

// Open the language selection popup menu again
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

// Select the English language option
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

// Check if the language has changed back
    expect(find.text('Download audio'), findsOneWidget);
  });
}

// Now, you have a test to check if the language changes
// correctly when selecting a different language from the
// `PopupMenuButton` in the `AudioListView` widget. Make
// sure to adjust the test code to match your app's localization
// strings and widget structure.

