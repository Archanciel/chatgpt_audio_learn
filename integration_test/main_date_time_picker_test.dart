import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatgpt_audio_learn/main_date_time_picker.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Set an hour in the time picker",
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Find the "Open Date Time Picker" button and tap it
    final openPickerButton = find.text('Open Date Time Picker');
    await tester.tap(openPickerButton);
    await tester.pumpAndSettle();

    // Confirm the displayed current date
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // in order to set a time in the time picker dialog, we
    // need to tap the keyboard icon displayed at the bottom
    // of the time picker dialog. Then, we will be able to
    // set the hour of the TextField that displays the current
    // hour.

    // Find the IconButton with Icons.keyboard_outlined within
    // the time picker dialog
    final iconButtonFinder = find.descendant(
      of: find.byType(Dialog),
      matching: find.byIcon(Icons.keyboard_outlined),
    );

    // Tap the keyboard IconButton
    await tester.tap(iconButtonFinder);
    await tester.pumpAndSettle();

    // Now, find the TextField that displays the current hour

    DateTime now = DateTime.now();
    final String currentHour = now.hour.toString();

    final EditableText hourEditableTextWidget =
        tester.widget<EditableText>(find.text(currentHour).first);

    // Verify that the hour displayed in the TextField is the
    // current hour
    expect(currentHour, hourEditableTextWidget.controller.text);

    // Now, modify the time picker hour to 14

    hourEditableTextWidget.controller.text = "14";
    await tester.pumpAndSettle();

    // Confirm the selected time
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify that the modified hour is displayed
    // in the screen TextField
    final textField = find.byType(TextField);
    expect(
      tester.widget<TextField>(textField).controller!.text.contains('14'),
      true,
    );
  });
}
