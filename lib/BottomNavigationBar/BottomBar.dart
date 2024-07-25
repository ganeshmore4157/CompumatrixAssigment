import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_apk/HomePage/NewsScreen.dart';
import 'package:news_apk/Setting/SettingScreen.dart';
import 'package:news_apk/Weather/WeatherPage.dart';
import 'package:news_apk/YoutubeNewsPage/YoutubeNews.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageBottom(),
    );
  }
}

class HomePageBottom extends StatefulWidget {
  @override
  _HomePageBottomState createState() => _HomePageBottomState();
}

class _HomePageBottomState extends State<HomePageBottom> {
  int _currentIndex = 0;
  DateTime? lastPressed;

  final List<Widget> _children = [
    NewsListPage(),
    YouTubeVideoListPage(),
    WeatherPage(),
    SettingsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    } else {
      final now = DateTime.now();
      const maxDuration = Duration(seconds: 2);
      final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;

      if (isWarning) {
        lastPressed = DateTime.now();
        final overlay = Overlay.of(context)!;
        final overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: customSnackBar(context),
          ),
        );

        overlay.insert(overlayEntry);

        Future.delayed(maxDuration, () {
          overlayEntry.remove();
        });

        return false;
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBody: true,
        body: _children[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.newspaper_rounded, size: 30, color: Colors.white),
            Icon(Icons.filter_drama_rounded, size: 30, color: Colors.white),
            Icon(Icons.person, size: 30, color: Colors.white),
          ],
          color: Colors.red.withOpacity(0.8),
          buttonBackgroundColor: Colors.red.withOpacity(0.8),
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: onTabTapped,
          letIndexChange: (index) => true,
        ),
      ),
    );
  }

  Widget customSnackBar(BuildContext context) {
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ListTile(
        leading: Image.asset(
          'assets/download.png',
          width: 30.0,
          height: 30.0,
        ),
        title: Text(
          'Press back again to exit',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
      ),
    );
  }
}
