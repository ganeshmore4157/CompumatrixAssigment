import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const String _selectedLanguageCodeKey = 'selected_language_code';

  Future<void> setSelectedLanguageCode(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageCodeKey, languageCode);
  }

  Future<String?> getSelectedLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedLanguageCodeKey);
  }
}
