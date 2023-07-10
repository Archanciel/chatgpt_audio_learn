import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_audio_learn/main_list_of_list.dart'
    as app; // Replace with your actual package name

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('select a master list item and then a sublist item',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Wait for the app to build.
    await tester.pumpAndSettle();

    // Find the first ListTile in the master list using its key.
    Finder masterListItemFinder = find.byKey(const Key('key1'));
    expect(masterListItemFinder, findsOneWidget);

    // Tap the ListTile in the master list.
    await tester.tap(masterListItemFinder);

    // Find the second ListTile in the master list using its value.
    masterListItemFinder = find.text('key2');
    expect(masterListItemFinder, findsOneWidget);

    // Tap the ListTile in the master list.
    await tester.tap(masterListItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Find the sublist item.
    final sublistItemFinder = find.byKey(const Key('key1-value1'));
    expect(sublistItemFinder, findsOneWidget);

    // Tap the sublist item.
    await tester.tap(sublistItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Verify the sublist item is selected
    final provider = Provider.of<app.MapOfListProvider>(
        tester.element(find.byType(app.SubList)),
        listen: false);
    expect(provider.selectedSublistItem, equals('key1-value1'));
  });
}
