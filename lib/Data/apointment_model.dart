import 'package:flutter/material.dart';

class Appointment {
  DateTime date;
  TimeOfDay time;
  String description;

  Appointment({
    required this.date,
    required this.time,
    required this.description,
    required String category,
  });

  @override
  String toString() {
    return '$date, $time, $description';
  }

  static Appointment fromString(String appointmentString) {
    final parts = appointmentString.split(', ');
    
    // Überprüfen, ob die Teile ausreichend vorhanden sind
    if (parts.length < 3) {
      throw FormatException('Ungültiges Terminformat: $appointmentString');
    }

    final date = DateTime.parse(parts[0]);

    // Entfernen Sie die umgebenden Klammern, wenn vorhanden
    final timeString = parts[1]
        .replaceAll(RegExp(r'^TimeOfDay\('), '')
        .replaceAll(RegExp(r'\)$'), '')
        .trim();

    // Überprüfen Sie, ob das Zeitformat HH:mm ist
    if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(timeString)) {
      throw FormatException('Ungültiges Zeitformat: $timeString');
    }

    final time = TimeOfDay(
      hour: int.parse(timeString.split(':')[0]),
      minute: int.parse(timeString.split(':')[1]),
    );
    final description = parts[2];

    return Appointment(
      date: date,
      time: time,
      description: description,
      category: '',
    );
  }
}
