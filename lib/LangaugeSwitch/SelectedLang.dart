import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_apk/BottomNavigationBar/BottomBar.dart';
import 'package:news_apk/LangaugeSwitch/LanguagePreferences.dart';

class LanguageSelectionPage extends StatelessWidget {
  void _changeLanguage(Locale locale) async {
    Get.updateLocale(locale);
    await LanguagePreferences().setSelectedLanguageCode(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/download.png', 
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                '   Welcome To My App  \n Please Select Langauge', 
                style: GoogleFonts.openSans(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Choose Language',
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'भाषा निवडा',
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _changeLanguage(Locale('en', 'US'));
                Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                              (route) => false,
                            );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                ),
                child: Text(
                  'English',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _changeLanguage(Locale('hi', 'IN'));
                 Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                              (route) => false,
                            );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                ),
                child: Text(
                  'Marathi',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
