import 'package:chatgpt_audio_learn/main_expandable_list.dart';
import 'package:chatgpt_audio_learn/viewmodels/expandable_playlist_list_vm.dart';
import 'package:chatgpt_audio_learn/views/expandable_playlist_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockExpandablePlaylistListVM extends ExpandablePlaylistListVM {
  @override
  Future<String> obtainPlaylistTitle(String? playlistId) async {
    return 'audio_learn_new_youtube_playlist_test';
  }
}

void main() {
  group('ExpandableListView', () {
    testWidgets(
        'should render ListViewWidget, not using MyApp but ListViewWidget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      expect(find.byType(ExpandablePlaylistListView), findsOneWidget);
    });

    testWidgets('should render ListViewWidget using MyApp',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MyApp(),
          ),
        ),
      );

      expect(find.byType(ExpandablePlaylistListView), findsOneWidget);
    });

    testWidgets('should toggle list on press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listTileFinder = find.byType(ListTile);
      expect(listTileFinder, findsWidgets);

      final List<Widget> listTileLst =
          tester.widgetList(listTileFinder).toList();
      expect(listTileLst.length, 7);

      // hidding the list
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      expect(listTileFinder, findsNothing);
    });

    testWidgets('check buttons enabled after item selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listItemFinder = find.byType(ListTile).first;
      await tester.tap(listItemFinder);
      await tester.pump();

      // testing that the Delete button is disabled
      Finder deleteButtonFinder = find.byKey(const ValueKey('delete_button'));
      expect(deleteButtonFinder, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(deleteButtonFinder).enabled, isFalse);

      // testing that the up and down buttons are disabled
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNull);

      // Verify that the first ListTile checkbox is not
      // selected
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pumpAndSettle();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // Verify that the Delete button is now enabled.
      // The Delete button must be obtained again
      // since the widget has been recreated !
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Verify that the up and down buttons are now enabled.
      // The Up and Down buttons must be obtained again
      // since the widget has been recreated !
      upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);
    });

    testWidgets(
        'check checkbox remains selected after toggling list up and down',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listItemFinder = find.byType(ListTile).first;
      await tester.tap(listItemFinder);
      await tester.pump();

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // hidding the list
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      // testing that the Delete button is disabled
      Finder deleteButtonFinder = find.byKey(const ValueKey('delete_button'));
      expect(deleteButtonFinder, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(deleteButtonFinder).enabled, isFalse);

      // testing that the up and down buttons are disabled
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNull);

      // redisplaying the list
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      // Verify that the Delete button is now enabled.
      // The Delete button must be obtained again
      // since the widget has been recreated !
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Verify that the up and down buttons are now enabled.
      // The Up and Down buttons must be obtained again
      // since the widget has been recreated !
      upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);

      // Verify that the first ListTile checkbox is always
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);
    });

    testWidgets('check buttons disabled after item unselected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listItemFinder = find.byType(ListTile).first;
      await tester.tap(listItemFinder);
      await tester.pump();

      // Verify that the first ListTile checkbox is not
      // selected
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // Verify that the Delete button is now enabled.
      // The Delete button must be obtained again
      // since the widget has been recreated !
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Verify that the up and down buttons are now enabled.
      // The Up and Down buttons must be obtained again
      // since the widget has been recreated !
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);

      // Retap the first ListTile checkbox to unselect it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // unselected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // testing that the Delete button is now disabled
      Finder deleteButtonFinder = find.byKey(const ValueKey('delete_button'));
      expect(deleteButtonFinder, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(deleteButtonFinder).enabled, isFalse);

      // testing that the up and down buttons are now disabled
      upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNull);

      downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNull);
    });

    testWidgets('ensure only one checkbox is settable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listItem = find.byType(ListTile).first;
      await tester.tap(listItem);
      await tester.pump();

      // Verify that the first ListTile checkbox is not
      // selected
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // Find and select the ListTile with text 'Item 4'
      String itemTextStr = 'Item 4';
      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemTextStr,
      );

      // Verify that the first ListTile checkbox is no longer
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);
    });

    testWidgets('select and delete item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      Finder listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      ExpandablePlaylistListVM listViewModel =
          Provider.of<ExpandablePlaylistListVM>(tester.element(listViewFinder),
              listen: false);
      expect(listViewModel.items.length, 7);

      // Verify that the Delete button is disabled
      expect(find.text('Delete'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', false),
      );

      // Find and select the ListTile item to delete
      const String itemToDeleteTextStr = 'Item 3';

      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemToDeleteTextStr,
      );

      // Verify that the Delete button is now enabled
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Tap the Delete button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
      await tester.pump();

      // Verify that the item was deleted by checking that
      // the ListViewModel.items getter return a list whose
      // length is 10 minus 1 and secondly verify that
      // the deleted ListTile is no longer displayed.

      listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      listViewModel = Provider.of<ExpandablePlaylistListVM>(
          tester.element(listViewFinder),
          listen: false);
      expect(listViewModel.items.length, 6);

      expect(find.widgetWithText(ListTile, itemToDeleteTextStr), findsNothing);
    });

    testWidgets('select and move down item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      Finder listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      ExpandablePlaylistListVM listViewModel =
          Provider.of<ExpandablePlaylistListVM>(tester.element(listViewFinder),
              listen: false);
      expect(listViewModel.items.length, 7);

      // Find and select the ListTile to move'
      const String itemToDeleteTextStr = 'Item 2';

      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemToDeleteTextStr,
      );

      // Verify that the move buttons are enabled
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      Finder downButtonFinder =
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down);
      IconButton downButton = tester.widget<IconButton>(downButtonFinder);
      expect(downButton.onPressed, isNotNull);

      // Tap the move down button
      await tester.tap(downButtonFinder);
      await tester.pump();

      listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      listViewModel = Provider.of<ExpandablePlaylistListVM>(
          tester.element(listViewFinder),
          listen: false);
      expect(listViewModel.items[1].url, 'Item 3');
      expect(listViewModel.items[2].url, 'Item 2');
    });

    testWidgets('select and move down twice before last item',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      Finder listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      ExpandablePlaylistListVM listViewModel =
          Provider.of<ExpandablePlaylistListVM>(tester.element(listViewFinder),
              listen: false);
      expect(listViewModel.items.length, 7);

      // Find and select the ListTile to move'
      const String itemToDeleteTextStr = 'Item 6';

      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemToDeleteTextStr,
      );

      // Verify that the move buttons are enabled
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      Finder downButtonFinder =
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down);
      IconButton downButton = tester.widget<IconButton>(downButtonFinder);
      expect(downButton.onPressed, isNotNull);

      // Tap the move down button twice
      await tester.tap(downButtonFinder);
      await tester.pump();
      await tester.tap(downButtonFinder);
      await tester.pump();

      listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      listViewModel = Provider.of<ExpandablePlaylistListVM>(
          tester.element(listViewFinder),
          listen: false);
      expect(listViewModel.items[0].url, 'Item 6');
      expect(listViewModel.items[6].url, 'Item 7');
    });

    testWidgets('select and move up item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pumpAndSettle();

      Finder listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      ExpandablePlaylistListVM listViewModel =
          Provider.of<ExpandablePlaylistListVM>(tester.element(listViewFinder),
              listen: false);
      expect(listViewModel.items.length, 7);

      // Find and select the ListTile to move'
      const String itemToDeleteTextStr = 'Item 5';

      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemToDeleteTextStr,
      );

      // Verify that the move buttons are enabled
      Finder downButtonFinder =
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up);
      IconButton upButton = tester.widget<IconButton>(downButtonFinder);
      expect(upButton.onPressed, isNotNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);

      // Tap the move up button
      await tester.tap(downButtonFinder);
      await tester.pump();

      listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      listViewModel = Provider.of<ExpandablePlaylistListVM>(
          tester.element(listViewFinder),
          listen: false);
      expect(listViewModel.items[3].url, 'Item 5');
      expect(listViewModel.items[4].url, 'Item 4');
    });

    testWidgets('select and move up twice first item',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ExpandablePlaylistListVM>(create: (_) => MockExpandablePlaylistListVM()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: const ExpandablePlaylistListView(),
            ),
          ),
        ),
      );

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(const ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      Finder listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      ExpandablePlaylistListVM listViewModel =
          Provider.of<ExpandablePlaylistListVM>(tester.element(listViewFinder),
              listen: false);
      expect(listViewModel.items.length, 7);

      // Find and select the ListTile to move'
      const String itemToDeleteTextStr = 'Item 1';

      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemToDeleteTextStr,
      );

      // Verify that the move buttons are enabled
      Finder upButtonFinder =
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up);
      IconButton upButton = tester.widget<IconButton>(upButtonFinder);
      expect(upButton.onPressed, isNotNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);

      // Tap twice the move up button
      await tester.tap(upButtonFinder);
      await tester.pump();
      await tester.tap(upButtonFinder);
      await tester.pump();

      listViewFinder = find.byType(ExpandablePlaylistListView);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      listViewModel = Provider.of<ExpandablePlaylistListVM>(
          tester.element(listViewFinder),
          listen: false);
      expect(listViewModel.items[0].url, 'Item 2');
      expect(listViewModel.items[5].url, 'Item 1');
    });
  });
}

Future<void> findSelectAndTestListTileCheckbox({
  required WidgetTester tester,
  required String itemTextStr,
}) async {
  Finder listItemTileFinder = find.widgetWithText(ListTile, itemTextStr);
  // Find the Checkbox widget inside the ListTile
  Finder checkboxFinder = find.descendant(
    of: listItemTileFinder,
    matching: find.byType(Checkbox),
  );

  // Assert that the checkbox is not selected
  expect(tester.widget<Checkbox>(checkboxFinder).value, false);

  // now tap the fourth item checkbox
  await tester.tap(find.descendant(
    of: listItemTileFinder,
    matching: find.byWidgetPredicate((widget) => widget is Checkbox),
  ));
  await tester.pump();

  // Assert that the fourth item checkbox is selected
  expect(tester.widget<Checkbox>(checkboxFinder).value, true);
}
