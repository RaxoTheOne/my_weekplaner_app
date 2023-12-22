import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/app.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Startet die Animation nach einer Verzögerung von 3 Sekunden
    Timer(Duration(seconds: 3), () {
      // Navigiert zur nächsten Seite
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MeinHomebildschirm(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hintergrund des Splashscreens
          Image.asset(
            'assets/_cf771525-d194-4742-9e45-a413a6604178.jpeg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Animierter orangener Container
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 300,
                  // Hier kannst du weitere Widgets für dein Bild hinzufügen
                ),
                SizedBox(height: 20),
                // ProgressIndicator
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
