import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String toString() {
    return '$date $time $description';
  }

  static DateTime parseDate(String dateString) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.parse(dateString);
  }

  static Appointment fromString(String appointmentString) {
    final parts = appointmentString.split(' ');
    final date = parseDate(parts[0]);
    final time = TimeOfDay(
      hour: int.parse(parts[1].split(':')[0]),
      minute: int.parse(parts[1].split(':')[1]),
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
  bool _isInteractionDone = false; // Neues Feld für den Interaktionsstatus

  List<Appointment> get appointments => _appointments;
  bool get isInteractionDone => _isInteractionDone; // Getter für den Interaktionsstatus

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(Appointment appointment) {
    _appointments.remove(appointment);
    notifyListeners();
    _updateInteractionStatus(true); // Beispiel für Interaktion
  }

  void removeAppointmentsOnDate(DateTime date) {
    _appointments.removeWhere((appointment) => isSameDay(appointment.date, date));
    notifyListeners();
    _updateInteractionStatus(true); // Beispiel für Interaktion
  }

  Future<void> saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final appointmentStrings = _appointments.map((appointment) => appointment.toString()).toList();
    prefs.setStringList('appointments', appointmentStrings);
    prefs.setBool('isInteractionDone', _isInteractionDone); // Speichere den Interaktionsstatus
  }

  Future<void> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAppointments = prefs.getStringList('appointments');

    if (savedAppointments != null) {
      _appointments = savedAppointments.map((appointmentString) => Appointment.fromString(appointmentString)).toList();
      notifyListeners();
    }

    _isInteractionDone = prefs.getBool('isInteractionDone') ?? false; // Lade den Interaktionsstatus
  }

  void _updateInteractionStatus(bool isDone) {
    _isInteractionDone = isDone;
    notifyListeners();
  }
}
