import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_apk/LangaugeSwitch/LanguagePreferences.dart';
import 'package:news_apk/LangaugeSwitch/LocalString.dart';
import 'package:news_apk/SplashScreen/SplashScreen.dart';
import 'package:news_apk/Theme/ThemeController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage

  LanguagePreferences languagePreferences = LanguagePreferences();
  String? savedLanguageCode = await languagePreferences.getSelectedLanguageCode();

  // Register ThemeController with GetX
  Get.put(ThemeController());

  runApp(MyApp(savedLanguageCode: savedLanguageCode));
}

class MyApp extends StatelessWidget {
  final String? savedLanguageCode;

  MyApp({this.savedLanguageCode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      fallbackLocale: Locale('en', 'US'),
      locale: savedLanguageCode != null ? Locale(savedLanguageCode!) : Locale('en', 'US'),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Get.find<ThemeController>().themeMode, // Use Get.find() to get the ThemeController instance
      home: SplashScreen(),
    );
  }
}
