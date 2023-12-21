import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
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
          Container(
            width: double.infinity,
            height: double.infinity,
            child: FlareActor(
              'assets/your_animation.flr',  // Pfad zu deiner Flare-Animation
              animation: 'play',  // Name deiner Animation
              fit: BoxFit.cover,
            ),
          ),
          // Animierter orangener Container
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hier kannst du weitere Widgets für dein Bild hinzufügen
                SizedBox(height: 20),
                // ProgressIndicator
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
