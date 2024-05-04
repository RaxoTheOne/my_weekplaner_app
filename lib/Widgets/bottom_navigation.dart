import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/presentation/calenderpage.dart';
import 'package:my_weekplaner_app/presentation/homepage.dart';
import 'package:my_weekplaner_app/presentation/settingspage.dart';

class MyHomescreen extends StatefulWidget {
  const MyHomescreen({Key? key}) : super(key: key);

  @override
  _MyHomescreenState createState() => _MyHomescreenState();
}

class _MyHomescreenState extends State<MyHomescreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CalendarPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Weekplaner'),
        backgroundColor: const Color.fromARGB(
            204, 175, 165, 165), // Hintergrundfarbe der AppBar
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(
            255, 91, 88, 88), // Hintergrundfarbe der Bottom Navigation Bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(
            255, 255, 255, 255), // Farbe für ausgewählte Elemente
        unselectedItemColor:
            Colors.grey, // Farbe für nicht ausgewählte Elemente
        onTap: _onItemTapped,
      ),
    );
  }
}
