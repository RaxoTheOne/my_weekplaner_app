import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/app.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Startet die Animation nach einer Verzögerung von 2 Sekunden
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hintergrund des Splashscreens
          Image.asset(
            'assets/_44db56b6-465b-4127-bf30-e0fb740191e8.jpeg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Animierter orangener Container mit InkWell
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  duration: Duration(seconds: 1),
                  opacity: _isVisible ? 1.0 : 0.0,
                  child: InkWell(
                    onTap: () {
                      // Navigiert zur nächsten Seite
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MeinHomebildschirm(),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 300,
                      // Hier kannst du weitere Widgets für dein Bild hinzufügen
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // ProgressIndicator
                if (!_isVisible)
                  CircularProgressIndicator(
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
