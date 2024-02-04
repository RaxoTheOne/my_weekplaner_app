import 'package:flutter/material.dart';

class Appointment {
  DateTime date;
  TimeOfDay time;
  String description;

  Appointment({
    required this.date,
    required this.time,
    required this.description, required String category,
  });

  @override
  String toString() {
    return '$date, $time, $description';
  }

  static Appointment fromString(String appointmentString) {
    final parts = appointmentString.split(', ');
    final date = DateTime.parse(parts[0]);

    final timeString = parts[1]
        .replaceAll(RegExp(r'^TimeOfDay\('), '')
        .replaceAll(RegExp(r'\)$'), '')
        .trim();

    final cleanedTimeString = timeString.replaceAll(RegExp('^0+'), '');

    if (!RegExp(r'^\d+:\d+$').hasMatch(cleanedTimeString)) {
      throw FormatException('Ungültiges Zeitformat: $timeString');
    }

    final time = TimeOfDay(
      hour: int.parse(cleanedTimeString.split(':')[0]),
      minute: int.parse(cleanedTimeString.split(':')[1]),
    );
    final description = parts[2];

    return Appointment(
      date: date,
      time: time,
      description: description, category: '',
    );
  }
}


