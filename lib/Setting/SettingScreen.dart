import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'.tr),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Circular avatar at the top center
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_640.png'), // Replace with your profile image asset
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    'Ganesh More',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '+91 9637149272',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SettingsMenuItem(
              icon: Icons.phone,
              color: Colors.red,
              text: 'Contact Us'.tr,
              onTap: () {},
            ),
            SizedBox(height: 10),
            SettingsMenuItem(
              icon: Icons.info,
              color: Colors.black,
              text: 'About Us'.tr,
              onTap: () {},
            ),
            SizedBox(height: 10),
            SettingsMenuItem(
              icon: Icons.share,
              color: Colors.brown,
              text: 'Share'.tr,
              onTap: () {},
            ),
            SizedBox(height: 10),
            SettingsMenuItem(
              icon: Icons.star,
              color: Colors.amber.shade700,
              text: 'Rate Us'.tr,
              onTap: () {},
            ),
            SizedBox(height: 10),
            SettingsMenuItem(
              icon: Icons.exit_to_app,
              color: Colors.teal,
              text: 'Exit'.tr,
              onTap: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onTap;

  SettingsMenuItem({
    required this.icon,
    required this.color,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 20),
            Text(
              text,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
