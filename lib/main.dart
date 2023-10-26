import 'package:flutter/material.dart';

void main() {
  runApp(const WochenplanerApp());
}

class WochenplanerApp extends StatelessWidget {
  const WochenplanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wochenplaner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WochenplanerPage(),
    );
  }
}

class WochenplanerPage extends StatefulWidget {
  const WochenplanerPage({super.key});

  @override
  _WochenplanerPageState createState() => _WochenplanerPageState();
}

class _WochenplanerPageState extends State<WochenplanerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wochenplaner'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hier könnte Ihr Wochenplan stehen.',
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Aufgabe hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }
}