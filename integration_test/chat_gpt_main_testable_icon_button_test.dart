import 'package:chatgpt_audio_learn/chat_gpt_main_testable_icon_button.dart'
    as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  // Necessary to avoid FatalFailureException (FatalFailureException: Failed
  // to perform an HTTP request to YouTube due to a fatal failure. In most
  // cases, this error indicates that YouTube most likely changed something,
  // which broke the library.
  // If this issue persists, please report it on the project's GitHub page.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('IconButton enabled/disabled test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify the button is enabled initially.
    final Finder toggleButton = find.byKey(Key('toggleButton'));
    expect(tester.widget<IconButton>(toggleButton).onPressed, isNotNull);

    // Tap the button to disable it.
    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    // Verify the button is now disabled.
    expect(tester.widget<IconButton>(toggleButton).onPressed, isNull);

    // Open the dialog.
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle(); // Wait for the dialog to open.

    // Verify the button inside the dialog is also disabled.
    final Finder dialogButton = find.byKey(Key('dialogButton'));
    expect(tester.widget<IconButton>(dialogButton).onPressed, isNull);

    // Close the dialog.
    Finder closeButton = find.byKey(Key('closeButton'));

    await tester.tap(closeButton);
    await tester.pumpAndSettle(); // Wait for the dialog to close.

    // Enable the button again.
    final Finder enableButton = find.byKey(Key('enableButton'));

    await tester.tap(enableButton);
    await tester.pumpAndSettle();

    // Verify the button is enabled again.
    expect(tester.widget<IconButton>(toggleButton).onPressed, isNotNull);

    // Open the dialog again.
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle(); // Wait for the dialog to open.

    // Verify the button inside the dialog is enabled.
    expect(tester.widget<IconButton>(dialogButton).onPressed, isNotNull);

    // Close the dialog.
    closeButton = find.byKey(Key('closeButton'));

    await tester.tap(closeButton);
    await tester.pumpAndSettle(); // Wait for the dialog to close.
  });
}
