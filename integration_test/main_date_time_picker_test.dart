import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatgpt_audio_learn/main_date_time_picker.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Selects a specified hour in the time picker",
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Find the "Open Date Time Picker" button and tap it
    final openPickerButton = find.text('Open Date Time Picker');
    await tester.tap(openPickerButton);
    await tester.pumpAndSettle();

    // Select a date (e.g., January 1, 2023)
    // await tester.tap(find.text('1'));
    // await tester.pumpAndSettle();

    // Confirm the selected date
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Open the time picker
    // await tester.tap(openPickerButton);
    // await tester.pumpAndSettle();

    // Find the IconButton with Icons.keyboard_outlined within the time picker dialog
    final iconButtonFinder = find.descendant(
      of: find.byType(Dialog),
      matching: find.byIcon(Icons.keyboard_outlined),
    );

    // Tap the keyboard IconButton
    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();

    final EditableText hourEditableTextWidget =
        tester.widget<EditableText>(find.text("19").first);

    expect("19", hourEditableTextWidget.controller.text);

    hourEditableTextWidget.controller.text = "14";
    await tester.pumpAndSettle();

    // Confirm the selected time
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify that the selected date and time are displayed in the TextField
    final textField = find.byType(TextField);
    expect(
      tester.widget<TextField>(textField).controller!.text.contains('14'),
      true,
    );
  });
}
