import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:chatgpt_audio_learn/main_list_of_list_selection_color.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('select a master list item and then a sublist item',
      (WidgetTester tester) async {
    // Since it is not possible to test the ListTile enclosing Container
    // color unless we apply a Key to the Container, we will test the
    // selection state of the corresponding MapOfListProvider.selectedKeys
    // and MapOfListProvider.selectedSublistItem values.
    //
    // This indicates why we do not use app.main() as in the original
    // integration test.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MapOfListsVM(),
        child: const MyApp(),
      ),
    );

    // Wait for the app to build.
    await tester.pumpAndSettle();

    // Find the first ListTile in the master list by its value.
    Finder masterListItemFinder = find.text('key1');
    expect(masterListItemFinder, findsOneWidget);

    // Tap the ListTile in the master list.
    await tester.tap(masterListItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Find the third ListTile in the master list by its value.
    masterListItemFinder = find.text('key3');
    expect(masterListItemFinder, findsOneWidget);

    // Tap the ListTile in the master list.
    await tester.tap(masterListItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Access the provider and print the selected keys
    final providerMaster = Provider.of<MapOfListsVM>(
        tester.element(find.byType(MasterList)),
        listen: false);
    expect(providerMaster.selectedKeys.keys, equals(['key1', 'key3']));

    // Find the sublist item by its value.
    Finder sublistItemFinder = find.text('key1-value1');
    expect(sublistItemFinder, findsOneWidget);

    // Tap the sublist item.
    await tester.tap(sublistItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Access the provider and print the selected sublist item
    MapOfListsVM providerSub = Provider.of<MapOfListsVM>(
        tester.element(find.byType(SubList)),
        listen: false);

    // Verify the sublist item is selected
    expect(providerSub.selectedSublistItem, equals('key1-value1'));

    // Find the sublist item by its value.
    sublistItemFinder = find.text('key3-value2');
    expect(sublistItemFinder, findsOneWidget);

    // Tap the sublist item.
    await tester.tap(sublistItemFinder);

    // Wait for the tap to be processed and for any animations to complete.
    await tester.pumpAndSettle();

    // Access the provider and print the selected sublist item
    providerSub = Provider.of<MapOfListsVM>(
        tester.element(find.byType(SubList)),
        listen: false);

    // Verify the sublist item is selected
    expect(providerSub.selectedSublistItem, equals('key3-value2'));
  });
}
