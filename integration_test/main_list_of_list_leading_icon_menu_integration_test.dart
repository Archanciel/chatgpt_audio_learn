import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:chatgpt_audio_learn/main_list_of_list_leading_icon_menu.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Check if tapping on popup menu works',
      (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MapOfListProvider(),
        child: const MyApp(),
      ),
    );

    // Ensure everything is loaded
    await tester.pumpAndSettle();

    // Find the second ListTile in the master list by its value.
    final Finder masterListItemFinder = find.text('key2');
    expect(masterListItemFinder, findsOneWidget);

    // Tap the ListTile in the master list.
    await tester.tap(masterListItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Assume we want to tap the popup menu of the sublist item "key2-value1"
    var sublistItem = find.text('key2-value1');
    expect(sublistItem, findsOneWidget);

    // Now find the leading icon button of the sublist item and tap it
    var leadingIconButton = find.descendant(
      of: sublistItem,
      matching: find.byIcon(Icons.menu),
    );
    expect(leadingIconButton, findsOneWidget);

    // Tap the leading icon button to open the popup menu
    await tester.tap(leadingIconButton);
    await tester.pumpAndSettle(); // Wait for popup menu to appear

    // Now find the popup menu item and tap on it
    var popupMenuItem = find.byKey(const Key('popup_menu_one'));
    expect(popupMenuItem, findsOneWidget);

    await tester.tap(popupMenuItem);
    await tester.pumpAndSettle(); // Wait for tap action to complete

    // Here, you can check if the action associated with the popup menu item has been executed
  });
}
