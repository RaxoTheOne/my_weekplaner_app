import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointment {
  DateTime date;
  TimeOfDay time;
  String description;

  Appointment({
    required this.date,
    required this.time,
    required this.description,
  });

  @override
  String toString() {
    return '$date, $time, $description';
  }

  static Appointment fromString(String appointmentString) {
  final parts = appointmentString.split(', ');
  final date = DateTime.parse(parts[0]);

  // Entferne führende Nullen aus Stunden und Minuten
  final timeString = parts[1].replaceAll(RegExp('^0+'), '');
  
  final time = TimeOfDay(
    hour: int.parse(timeString.split(':')[0]),
    minute: int.parse(timeString.split(':')[1]),
  );
  final description = parts[2];

  return Appointment(
    date: date,
    time: time,
    description: description,
  );
}

}

class AppointmentModel extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(Appointment appointment) {
    _appointments.remove(appointment);
    notifyListeners();
  }

  void removeAppointmentsOnDate(DateTime date) {
    _appointments
        .removeWhere((appointment) => isSameDay(appointment.date, date));
    notifyListeners();
  }

  Future<void> saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final appointmentStrings =
        _appointments.map((appointment) => appointment.toString()).toList();
    prefs.setStringList('appointments', appointmentStrings);
  }

  Future<void> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAppointments = prefs.getStringList('appointments');

    if (savedAppointments != null) {
      _appointments = savedAppointments
          .map((appointmentString) => Appointment.fromString(appointmentString))
          .toList();
      notifyListeners();
    }
  }
}
