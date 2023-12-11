import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/main.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointment {
  DateTime date;
  TimeOfDay time;
  String description;

  Appointment({required this.date, required this.time, required this.description});

  String toString() {
    return '$date#${time.hour}:${time.minute}#$description';
  }

  static Appointment fromString(String appointmentString) {
    final parts = appointmentString.split('#');
    final date = DateTime.parse(parts[0]);
    final timeParts = parts[1].split(':');
    final time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    final description = parts[2];

    return Appointment(date: date, time: time, description: description);
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _newAppointmentDescription = '';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAppointments = prefs.getStringList('appointments');

    if (savedAppointments != null) {
      final appointmentModel = Provider.of<AppointmentModel>(context, listen: false);

      for (final appointmentString in savedAppointments) {
        final appointment = Appointment.fromString(appointmentString);
        appointmentModel.addAppointment(appointment);
      }
    }
  }

  void _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final appointmentModel = Provider.of<AppointmentModel>(context, listen: false);

    final appointmentStrings = appointmentModel.appointments.map((appointment) => appointment.toString()).toList();
    prefs.setStringList('appointments', appointmentStrings);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addAppointment() {
    if (_selectedDay != null && _newAppointmentDescription.isNotEmpty) {
      final appointmentModel = Provider.of<AppointmentModel>(context, listen: false);
      appointmentModel.addAppointment(Appointment(
        date: _selectedDay!,
        time: _selectedTime,
        description: _newAppointmentDescription,
      ));
      setState(() {
        _newAppointmentDescription = '';
        _selectedTime = TimeOfDay.now();
        _selectedDay = null;
      });
      _saveAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Terminbeschreibung',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _newAppointmentDescription = value;
              });
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDay ?? DateTime.now(),
                    firstDate: DateTime(2010, 10, 16),
                    lastDate: DateTime(2030, 3, 14),
                  );

                  if (picked != null && picked != _selectedDay) {
                    setState(() {
                      _selectedDay = picked;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text('Datum auswählen'),
              ),
              ElevatedButton.icon(
                onPressed: () => _selectTime(context),
                icon: Icon(Icons.access_time),
                label: Text('Uhrzeit auswählen'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addAppointment,
                child: Text('Termin hinzufügen'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
