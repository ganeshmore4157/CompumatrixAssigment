import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  // Get the current theme mode
  ThemeMode get themeMode => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // Load theme mode from storage
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // Save theme mode to storage
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Switch theme
  void switchTheme() {
    bool isDarkMode = _loadThemeFromBox();
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!isDarkMode);
  }
}
