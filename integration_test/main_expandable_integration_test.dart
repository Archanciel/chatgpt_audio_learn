import 'package:chatgpt_audio_learn/views/expandable_playlist_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chatgpt_audio_learn/viewmodels/expandable_playlist_list_vm.dart';

class MockExpandablePlaylistListVM extends ExpandablePlaylistListVM {
  @override
  Future<String> obtainPlaylistTitle(String? playlistId) async {
    return 'audio_learn_new_youtube_playlist_test';
  }
}

void main() {
  const String youtubePlaylistId = 'PLzwWSJNcZTMTSAE8iabVB6BCAfFGHHfah';
  const String youtubePlaylistUrl =
      'https://youtube.com/playlist?list=$youtubePlaylistId';
  const String youtubePlaylistTitle = 'audio_learn_new_youtube_playlist_test';

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test adding playlist NOT WORKING", (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ExpandablePlaylistListVM>(
            create: (context) => MockExpandablePlaylistListVM(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: ExpandablePlaylistListView()),
          // home: MyApp(), not working: notifyListeners() not called
          // home: Scaffold(body: MyApp()), not working: notifyListeners() not called
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Ensure the list is initially hidden
    expect(find.byType(ListView), findsNothing);

    // Tap the 'Toggle List' button to show the list
    await tester.tap(find.byKey(const Key('toggle_button')));
    await tester.pumpAndSettle();

    // The list should be visible now but empty
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);

    // Add a new playlist
    await tester.enterText(
        find.byKey(const Key('playlistUrlTextField')), youtubePlaylistUrl);

    TextField urlTextField =
        tester.widget(find.byKey(const Key('playlistUrlTextField')));
    expect(urlTextField.controller!.text, youtubePlaylistUrl);

    await tester.tap(find.byKey(const Key('addPlaylistButton')));
    await tester.pumpAndSettle();

    // Ensure the dialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);

    // Check the value of the AlertDialog TextField
    TextField confirmUrlTextField = tester
        .widget(find.byKey(const Key('playlistUrlConfirmationTextField')));
    expect(confirmUrlTextField.controller!.text, youtubePlaylistUrl);

    // Confirm the addition by tapping the confirmation button in the AlertDialog
    await tester
        .tap(find.byKey(const Key('addPlaylistConfirmDialogAddButton')));
    await tester.pumpAndSettle();

    // The list should have one item now
    expect(find.byType(ListTile), findsOneWidget);

    // Check if the added item is displayed correctly
    final playlistTile = find.byType(ListTile).first;
    expect(find.descendant(of: playlistTile, matching: find.text(youtubePlaylistTitle)),
        findsOneWidget);
  });
}
