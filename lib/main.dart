import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kalender'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2023),
                lastDate: DateTime(2024),
              );
              // ignore: avoid_print
              if (picked != null) print(picked);
            },
            child: const Text('Datum auswählen'),
          ),
        ),
      ),
    );
  }
}