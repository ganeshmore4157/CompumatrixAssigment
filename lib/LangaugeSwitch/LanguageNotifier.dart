import 'package:flutter/material.dart';
import 'package:news_apk/LangaugeSwitch/LanguagePreferences.dart';


class LanguageNotifier extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  LanguageNotifier() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    String? languageCode = await LanguagePreferences().getSelectedLanguageCode();
    _locale = Locale(languageCode ?? 'en');
    notifyListeners();
  }

  Future<void> switchLanguage() async {
    String newLanguageCode = _locale.languageCode == 'en' ? 'hi' : 'en';
    _locale = Locale(newLanguageCode);
    await LanguagePreferences().setSelectedLanguageCode(newLanguageCode);
    notifyListeners();
  }
}
