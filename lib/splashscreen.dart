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
    Timer(Duration(seconds: 2), () {
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
          Container(
            color: Colors.black,
            child: Center(
              child: FlutterLogo(size: 400),
            ),
          ),
          // Animierter orangener Container mit InkWell
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            left: _isVisible ? MediaQuery.of(context).size.width / 4 : 0,
            top: _isVisible ? MediaQuery.of(context).size.height / 4 : 0,
            child: InkWell(
              onTap: () {
                // Navigiert zur nächsten Seite
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MeinHomebildschirm()),
                );
              },
              child: Container(
                width: 200,
                height: 400,
               child: Image.asset(
                      'assets/_44db56b6-465b-4127-bf30-e0fb740191e8.jpeg'),
               ),
            ),
          ),
         ],
      ),
    );
  }
}
