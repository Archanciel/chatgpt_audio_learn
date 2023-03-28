import 'package:chatgpt_audio_learn/viewmodels/audio_download_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/theme_provider.dart';
import 'package:chatgpt_audio_learn/viewmodels/language_provider.dart';
import 'package:chatgpt_audio_learn/main.dart';

void main() {
  testWidgets('Language changes when selecting a different language',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MainApp(
            key: Key('mainAppKey'),
          ),
        ),
      ),
    );

// Check the initial language
    expect(find.text('Download Audio Youtube'), findsOneWidget);

// Open the language selection popup menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

// Select the French language option
    await tester.tap(find.text('Select French'));
    await tester.pumpAndSettle();

// Check if the language has changed
    expect(find.text('Télécharger Audio Youtube'), findsOneWidget);

// Open the language selection popup menu again
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

// Select the English language option
    await tester.tap(find.text('Affichage anglais'));
    await tester.pumpAndSettle();

// Check if the language has changed back
    expect(find.text('Download Audio Youtube'), findsOneWidget);
  });
}

// Now, you have a test to check if the language changes
// correctly when selecting a different language from the
// `PopupMenuButton` in the `AudioListView` widget. Make
// sure to adjust the test code to match your app's localization
// strings and widget structure.

