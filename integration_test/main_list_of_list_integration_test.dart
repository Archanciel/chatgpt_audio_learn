import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:chatgpt_audio_learn/main_list_of_list.dart'
    as app; // Replace with your actual package name

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('select a master list item and then a sublist item',
      (WidgetTester tester) async {
    app.main();

    // Wait for the app to build.
    await tester.pumpAndSettle();

    // Find the first ListTile Text in the master list by its value.
    final Finder masterlistListTileText = find.text('key1');
    expect(masterlistListTileText, findsOneWidget);

    // Tap the ListTile Text in the master list.
    await tester.tap(masterlistListTileText);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Check if the check icon appears next to the selected master list item.
    expect(
        find.byIcon(Icons.check).evaluate().any((element) =>
            (element.findAncestorWidgetOfExactType<ListTile>()?.title as Text)
                .data ==
            'key1'),
        isTrue);

    // Find the sublist ListTile Text widget
    final Finder sublistListTileText = find.text('key1-value1');
    expect(sublistListTileText, findsOneWidget);
c:\Users\Jean-Pierre\Development\Flutter\audiolearn\lib\tools\chatgpt_audioplayers_6_1_0.dart c:\Users\Jean-Pierre\Development\Flutter\audiolearn\lib\tools\audio_player_view_model.dart
    // Tap the sublist ListTile Text widget
    await tester.tap(sublistListTileText);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Check if the check icon appears next to the selected sublist item.
    expect(
        find.byIcon(Icons.check).evaluate().any((element) =>
            (element.findAncestorWidgetOfExactType<ListTile>()?.title as Text)
                .data ==
            'key1-value1'),
        isTrue);
  });
}
