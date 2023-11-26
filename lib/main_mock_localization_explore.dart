import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockAppLocalizations extends AppLocalizations {
  MockAppLocalizations() : super('en');

  @override
  String get title => "Mocked Title";
  
  @override
  // TODO: implement atPreposition
  String get atPreposition => throw UnimplementedError();
  
  @override
  // TODO: implement audioQuality
  String get audioQuality => throw UnimplementedError();
  
  @override
  // TODO: implement delete
  String get delete => throw UnimplementedError();
  
  @override
  // TODO: implement downloadAudio
  String get downloadAudio => throw UnimplementedError();
  
  @override
  // TODO: implement english
  String get english => throw UnimplementedError();
  
  @override
  // TODO: implement french
  String get french => throw UnimplementedError();
  
  @override
  // TODO: implement language
  String get language => throw UnimplementedError();
  
  @override
  // TODO: implement moveItemDown
  String get moveItemDown => throw UnimplementedError();
  
  @override
  // TODO: implement moveItemUp
  String get moveItemUp => throw UnimplementedError();
  
  @override
  // TODO: implement ofPreposition
  String get ofPreposition => throw UnimplementedError();
  
  @override
  // TODO: implement toggleList
  String get toggleList => throw UnimplementedError();
  
  @override
  String translate(Object language) {
    // TODO: implement translate
    throw UnimplementedError();
  }

  // Override other methods to return mock strings
}

class MockAppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return MockAppLocalizations();
  }

  @override
  bool shouldReload(MockAppLocalizationsDelegate old) => false;
}

void main() {
  testWidgets('Test with mocked localizations', (WidgetTester tester) async {
    // Create a MaterialApp with Localizations.override
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Localizations.override(
              context: context,
              locale: const Locale('en'),
              delegates: [
                MockAppLocalizationsDelegate(),
                // Add other necessary delegates like GlobalMaterialLocalizations.delegate
              ],
              child: Builder(
                builder: (BuildContext innerContext) {
                  // Use `AppLocalizations.of(innerContext)` as usual
                  final localizations = AppLocalizations.of(innerContext);
                  return Text(localizations!.title);
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the mocked string is shown
    expect(find.text('Mocked Title'), findsOneWidget);
  });
}
