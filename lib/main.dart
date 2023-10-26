import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wochenplaner',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wochenplaner'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Hier ist Ihr Wochenplan:',
                ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 7,
                  children: List.generate(30, (index) {
                    return Center(
                      child: Text(
                        'Tag ${index + 1}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}