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

    // Find the second ListTile Text widget in the master list
    final Finder masterlistListTileText = find.text('key2');
    expect(masterlistListTileText, findsOneWidget);

    // Tap the on the ListTile Text in the master list
    await tester.tap(masterlistListTileText);

    // Wait for the tap to be processed and for any animations to complete
    await tester.pumpAndSettle();

    // Assume we want to tap the popup menu of the sublist ListTile
    // "key2-value1"

    // First, find the sublist ListTile Text widget
    final Finder sublistListTileText = find.text('key2-value1');
    expect(sublistListTileText, findsOneWidget);

    // Then obtain the ListTile widget enclosing the Text widget by
    // finding its ancestor
    final Finder sublistListTile = find.ancestor(
      of: sublistListTileText,
      matching: find.byType(ListTile),
    );

    // Now find the leading icon button of the sublist ListTile and tap it
    final Finder sublistListTileLeadingIconButton = find.descendant(
      of: sublistListTile,
      matching: find.byIcon(Icons.menu),
    );
    expect(sublistListTileLeadingIconButton, findsOneWidget);

    // Tap the leading icon button to open the popup menu
    await tester.tap(sublistListTileLeadingIconButton);
    await tester.pumpAndSettle(); // Wait for popup menu to appear

    // Now find the popup menu item and tap on it
    final Finder popupMenuItem = find.byKey(const Key('popup_menu_one'));
    expect(popupMenuItem, findsOneWidget);

    await tester.tap(popupMenuItem);
    await tester.pumpAndSettle(); // Wait for tap action to complete
  });
}
