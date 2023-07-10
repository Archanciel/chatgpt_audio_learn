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

    // Find the first ListTile in the master list by its value.
    final Finder masterListItemFinder = find.text('key1');
    expect(masterListItemFinder, findsOneWidget);

    // Tap the ListTile in the master list.
    await tester.tap(masterListItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Check if the check icon appears next to the selected master list item.
    expect(
        find.byIcon(Icons.check).evaluate().any((element) =>
            (element.findAncestorWidgetOfExactType<ListTile>()?.title as Text)
                .data ==
            'key1'),
        isTrue);

    // Find the sublist item by its value.
    final Finder sublistItemFinder = find.text('key1-value1');
    expect(sublistItemFinder, findsOneWidget);

    // Tap the sublist item.
    await tester.tap(sublistItemFinder);

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
