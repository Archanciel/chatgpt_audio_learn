import 'package:chatgpt_audio_learn/main_expandable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_audio_learn/viewmodels/expandable_playlist_list_vm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test adding playlist", (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ExpandablePlaylistListVM(),
        child: const MaterialApp(
          home: MyApp(),
        ),
      ),
    );

    // Ensure the list is initially hidden
    expect(find.byType(ListView), findsNothing);

    // Tap the 'Toggle List' button to show the list
    await tester.tap(find.byKey(const Key('toggle_button')));
    await tester.pumpAndSettle();

    // The list should be visible now but empty
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    // Add a new playlist
    await tester.enterText(find.byKey(const Key('playlistUrlTextField')), 'https://youtube.com/playlist?list=EXAMPLE');
    await tester.tap(find.byKey(const Key('addPlaylistButton')));
    await tester.pumpAndSettle();

    // The list should have one item now
    expect(find.byType(ListTile), findsOneWidget);

    // Check if the added item is displayed correctly
    final playlistTile = find.byType(ListTile).first;
    expect(find.descendant(of: playlistTile, matching: find.text('https://youtube.com/playlist?list=EXAMPLE')), findsOneWidget);
  });
}
