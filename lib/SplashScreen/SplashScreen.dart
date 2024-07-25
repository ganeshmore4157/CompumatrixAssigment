import 'package:flutter/material.dart';
import 'package:news_apk/LangaugeSwitch/SelectedLang.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds:5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LanguageSelectionPage()),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/download.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return Center(
                child: Text('Image Error'),
              );
            },
          ),
        ],
      ),
    );
  }
  }