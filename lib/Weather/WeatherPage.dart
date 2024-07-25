import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _currentLocation = '';
  String _currentWeather = '';
  double _temperature = 0.0;
  double _windSpeed = 0.0;
  IconData _weatherIcon = Icons.error_outline;
  String _weatherIconPath = '';

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    if (await _checkAndRequestPermissions()) {
      await _getCurrentLocation();
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (!await Permission.location.isGranted) {
      var status = await Permission.location.request();
      if (status != PermissionStatus.granted) {
        _showPermissionDeniedDialog();
        return false;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDisabledDialog();
      return false;
    }

    return true;
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Services Disabled'),
        content:
            Text('Please enable location services in your device settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text(
            'Location permission is denied. Please grant permission from the app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Position: ${position.latitude}, ${position.longitude}');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      print('Placemarks: $placemarks');
      setState(() {
        _currentLocation =
            '${placemarks[0].locality}, ${placemarks[0].country}';
      });
      _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    final apiKey =
        'd543b5787c2d1f1e9d1a09e68572d29c'; // Replace with your API key
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    print('Weather API URL: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _currentWeather = '${data['weather'][0]['main']}';
        _temperature = data['main']['temp'];
        _windSpeed = data['wind']['speed'];
        _weatherIconPath = _getWeatherIconPath(data['weather'][0]['main']);
      });
    } else {
      print('Error fetching weather: ${response.reasonPhrase}');
    }
  }

  String _getWeatherIconPath(String weather) {
    switch (weather) {
      case 'Clear':
        return 'assets/sunny.gif';
      case 'Clouds':
        return 'assets/cloud.gif';
      case 'Rain':
        return 'assets/rain.gif';
      default:
        return 'assets/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    int currTemp = 30; // current temperature
    int maxTemp = 30; // today max temperature
    int minTemp = 2; // today min temperature
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather'.tr,
          style: GoogleFonts.nunito(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        //  backgroundColor: Colors.red.shade800,
        iconTheme: IconThemeData(color: Colors.green.shade500),
      ),
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
              //  color: isDarkMode ? Colors.black : Colors.white,
              color: Colors.white),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.03,
                        ),
                        child: Align(
                          child: Text(
                            _currentLocation,
                            style: GoogleFonts.questrial(
                              // color: isDarkMode ? Colors.white : Colors.black,
                              color: Colors.black,
                              fontSize: size.height * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: Align(
                          child: Text(
                            'Today', //day
                            style: GoogleFonts.questrial(
                              // color:
                              //     isDarkMode ? Colors.white54 : Colors.black54,
                              color: Colors.black,
                              fontSize: size.height * 0.035,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.01,
                        ),
                        child: Align(
                          child: Text(
                            '$_temperature˚C', //curent temperature
                            style: GoogleFonts.questrial(
                              color: currTemp <= 0
                                  ? Colors.blue
                                  : currTemp > 0 && currTemp <= 15
                                      ? Colors.indigo
                                      : currTemp > 15 && currTemp < 30
                                          ? Colors.deepPurple
                                          : Colors.green.shade300,
                              fontSize: size.height * 0.07,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.25),
                        child: Divider(
                          // color: isDarkMode ? Colors.white : Colors.black,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.001,
                          left: size.height * 0.150,
                        ),
                        child: Column(
                          children: [
                            if (_weatherIconPath.isNotEmpty)
                              Image.asset(
                                _weatherIconPath,
                                height: 100,
                                width: 100,
                              ),
                            // Other UI elements to show weather details
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.01,
                          bottom: size.height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'wind speed $_windSpeed km', // min temperature
                              style: GoogleFonts.questrial(
                                color: minTemp <= 0
                                    ? Colors.blue
                                    : minTemp > 0 && minTemp <= 15
                                        ? Colors.indigo
                                        : minTemp > 15 && minTemp < 30
                                            ? Colors.deepPurple
                                            : Colors.pink,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                            Text(
                              '',
                              style: GoogleFonts.questrial(
                                color: isDarkMode
                                    ? Colors.white54
                                    : Colors.black54,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                            Text(
                              '', //max temperature
                              style: GoogleFonts.questrial(
                                color: maxTemp <= 0
                                    ? Colors.blue
                                    : maxTemp > 0 && maxTemp <= 15
                                        ? Colors.indigo
                                        : maxTemp > 15 && maxTemp < 30
                                            ? Colors.deepPurple
                                            : Colors.pink,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2020/06/08/14/17/sky-5274530_640.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.01,
                                    left: size.width * 0.03,
                                  ),
                                  child: Text(
                                    'Forecast for today',
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.grey.shade300
                                          : Colors.black,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      //TODO: change weather forecast from local to api get
                                      buildForecastToday(
                                        "Now", //hour
                                        currTemp, //temperature
                                        20, //wind (km/h)
                                        0, //rain chance (%)
                                        FontAwesomeIcons.sun, //weather icon
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "15:00",
                                        1,
                                        10,
                                        40,
                                        FontAwesomeIcons.cloud,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "16:00",
                                        0,
                                        25,
                                        80,
                                        FontAwesomeIcons.cloudRain,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "17:00",
                                        -2,
                                        28,
                                        60,
                                        FontAwesomeIcons.snowflake,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "18:00",
                                        -5,
                                        13,
                                        40,
                                        FontAwesomeIcons.cloudMoon,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "19:00",
                                        -8,
                                        9,
                                        60,
                                        FontAwesomeIcons.snowflake,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "20:00",
                                        -13,
                                        25,
                                        50,
                                        FontAwesomeIcons.snowflake,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "21:00",
                                        -14,
                                        12,
                                        40,
                                        FontAwesomeIcons.cloudMoon,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "22:00",
                                        -15,
                                        1,
                                        30,
                                        FontAwesomeIcons.moon,
                                        size,
                                        isDarkMode,
                                      ),
                                      buildForecastToday(
                                        "23:00",
                                        -15,
                                        15,
                                        20,
                                        FontAwesomeIcons.moon,
                                        size,
                                        isDarkMode,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.02,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2024/02/08/14/13/sky-8561169_640.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.height * 0.02,
                                    left: size.width * 0.03,
                                  ),
                                  child: Text(
                                    '7-day forecast',
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: Column(
                                  children: [
                                    //TODO: change weather forecast from local to api get
                                    buildSevenDayForecast(
                                      "Today", //day
                                      minTemp, //min temperature
                                      maxTemp, //max temperature
                                      FontAwesomeIcons.cloud, //weather icon
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Wed",
                                      -5,
                                      5,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Thu",
                                      -2,
                                      7,
                                      FontAwesomeIcons.cloudRain,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Fri",
                                      3,
                                      10,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "San",
                                      5,
                                      12,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Sun",
                                      4,
                                      7,
                                      FontAwesomeIcons.cloud,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Mon",
                                      -2,
                                      1,
                                      FontAwesomeIcons.snowflake,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Tues",
                                      0,
                                      3,
                                      FontAwesomeIcons.cloudRain,
                                      size,
                                      isDarkMode,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForecastToday(String time, int temp, int wind, int rainChance,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$temp˚C',
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.025,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.wind,
                  color: Colors.white,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$wind km/h',
            style: GoogleFonts.questrial(
              color: Colors.white,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.umbrella,
                  color: Colors.white,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$rainChance %',
            style: GoogleFonts.questrial(
              color: Colors.white,
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSevenDayForecast(String time, int minTemp, int maxTemp,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white : Colors.black38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}
