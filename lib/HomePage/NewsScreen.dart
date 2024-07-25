import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_apk/HomePage/ArticleDetailsPage.dart';
import 'package:news_apk/LangaugeSwitch/LanguagePreferences.dart';
import 'package:share_plus/share_plus.dart';



class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final List<Map<String, String>> articles = [
    {
      'headline': 'Hardik Pandya sits beside Gautam Gambhir in team bus',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSc2ee2hwfmTMAXb0e8ax2MkWWjzXaymiqzxA&s',
      'details': 'In their first practice session under new head coach Gautam Gambhir, the Indian cricketers, especially T20I captain Suryakumar Yadav and star all-rounder Hardik Pandya, were in a jovial mood. The break after the T20 World Cup appeared to have done a world of good to the cricketers, making a comeback to the side for the Sri Lanka tour that features three T20Is and three ODIs.\n The tour will begin with the T20Is on July 27 before the ODIs kick in on August 2 \nIn many ways, this Sri Lanka tour marks a new chapter in Indian cricket. After the highs of winning the T20 World Cup - their first ICC trophy in 11 years - Rahul Dravids tenure as the head coach ended. Captain Rohit Sharma and stalwarts Virat Kohli and Ravindra Jadej',
      'date': '2024-07-25 12:00'
    },
    {
      'headline': 'CUET UG 2024 Results Likely to be Declared by Next Week',
      'image': 'https://media.istockphoto.com/id/1072472414/photo/male-student-in-classroom-writing-in-notebook-stock-image.webp?s=1024x1024&w=is&k=20&c=LiaB75GrGeOPNFiaHVHtxYV1A4GzYZkGLe0yT7nQvsc=',
      'details': 'New Delhi: The National Testing Agency (NTA) is expected to declare the results for the Common University Entrance Test Undergraduate (CUET UG) anytime soon. Over 13 lakh candidates are sincerely waiting for the National Testing Agency (NTA) to release the CUET UG 2024 Results. Once it is released, the students can check the CUET UG marks using their application number and date of birth.\nThe NTA had earlier released the provisional answer key for the CUET UG exam held on July 19. Candidates who appeared for the exam can check the answer keys and raise objections by visiting the official website of the CUET UG. Then the NTA will publish the final answer key after reviewing the objections submitted by examine',
      'date': '2024-07-25 11:00'
    },
    {
      'headline': 'For Indias table tennis great Sharath Kamal, running into Roger Federer tops favourite Olympic memories',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm_hvuVkQvbbVY_OLVxHL1ctUwcutiXj7j7w&s',
      'details': 'Achanta Sharath Kamal, Indias table tennis star and flagbearer for the upcoming Paris Olympics, reminisced about his remarkable journey across five Olympic appearances.\nThe 42-year-old veteran shared his most cherished moments, from a chance encounter with tennis legend Roger Federer to challenging Chinese table tennis icon Ma Long on the court',
      'date': '2024-07-25 10:00'
    },
  ];

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    String? languageCode = await LanguagePreferences().getSelectedLanguageCode();
    setState(() {
      isEnglish = languageCode != 'hi';
    });
  }

  void _toggleLanguage() async {
    Locale newLocale = isEnglish ? Locale('hi', 'IN') : Locale('en', 'US');
    await LanguagePreferences().setSelectedLanguageCode(newLocale.languageCode);
    Get.updateLocale(newLocale);
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.red.shade300),
        title: Row(
          children: [
            Image.asset('assets/download.png', height: 40),
            Spacer(),
            Text(
              "NEWS ARTICLE".tr,
              style: GoogleFonts.nunito(
                color: Colors.red.shade300,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: _toggleLanguage,
              icon: Row(
                children: [
                  Icon(
                    Icons.g_translate,
                    color: Colors.red.shade300,
                  ),
                  SizedBox(width: 5),
                  Text(
                    isEnglish ? 'मराठी' : 'English',
                    style: GoogleFonts.nunito(color: Colors.red.shade300, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              tooltip: isEnglish ? 'Switch to English' : 'Switch to मराठी',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          buildImageSlider(),
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: Image.network(
                      article['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      article['headline']!.tr,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(article['date']!)),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.red.shade300),
                          onPressed: () {
                            Share.share(article['details']!);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(
                            headline: article['headline']!,
                            image: article['image']!,
                            details: article['details']!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageSlider() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
          ),
          items: articles.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(
                      children: [
                        Image.network(
                          item['image']!,
                          fit: BoxFit.cover,
                          height: 160,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          child: Container(
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Text(
                              item['headline']!.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}