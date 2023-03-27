import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale;

  LanguageProvider({required Locale initialLocale})
      : _currentLocale = initialLocale;

  Locale get currentLocale => _currentLocale;

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;

    notifyListeners();
  }
}
