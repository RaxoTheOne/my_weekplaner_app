import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointment {
  DateTime date;
  TimeOfDay time;
  String description;

  Appointment({
    required this.date,
    required this.time,
    required this.description,
  });

  // Methode zum Konvertieren der Daten in einen String
  String toString() {
    return '$date $time $description';
  }

  // Methode zum Erstellen eines Appointment-Objekts aus einem String
  static Appointment fromString(String appointmentString) {
    final parts = appointmentString.split(' ');
    final date = DateTime.parse(parts[0]);
    final time = TimeOfDay(
      hour: int.parse(parts[1]),
      minute: int.parse(parts[2]),
    );
    final description = parts[3];

    return Appointment(
      date: date,
      time: time,
      description: description,
    );
  }
}

class AppointmentModel extends ChangeNotifier {
  List<Appointment> appointments = [];

  // Methode zum Hinzufügen eines Termins
  void addAppointment(Appointment appointment) {
    appointments.add(appointment);
    notifyListeners();
  }

  // Methode zum Entfernen eines einzelnen Termins
  void removeAppointment(Appointment appointment) {
    appointments.remove(appointment);
    notifyListeners();
  }

  // Methode zum Entfernen aller Termine an einem bestimmten Datum
  void removeAppointmentsOnDate(DateTime date) {
    appointments.removeWhere((appointment) => isSameDay(appointment.date, date));
    notifyListeners();
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
      final appointmentModel =
          Provider.of<AppointmentModel>(context, listen: false);

      for (final appointmentString in savedAppointments) {
        final appointment = Appointment.fromString(appointmentString);
        appointmentModel.addAppointment(appointment);
      }
    }
  }

  void _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final appointmentModel =
        Provider.of<AppointmentModel>(context, listen: false);

    final appointmentStrings = appointmentModel.appointments
        .map((appointment) => appointment.toString())
        .toList();
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
      final appointmentModel =
          Provider.of<AppointmentModel>(context, listen: false);
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

  void _removeAppointmentsOnDate(DateTime date) {
    final appointmentModel =
        Provider.of<AppointmentModel>(context, listen: false);
    appointmentModel.removeAppointmentsOnDate(date);
    _saveAppointments();
  }

  void _removeAppointment(Appointment appointment) {
    final appointmentModel =
        Provider.of<AppointmentModel>(context, listen: false);
    appointmentModel.removeAppointment(appointment);
    _saveAppointments();
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
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDay != null) {
                    _removeAppointmentsOnDate(_selectedDay!);
                    setState(() {
                      _selectedDay = null;
                    });
                  }
                },
                child: Text('Termine entfernen'),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (_selectedDay != null)
            Text(
              'Termine am ${DateFormat('yMMMd').format(_selectedDay!)}:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (_selectedDay != null)
            Expanded(
              child: Consumer<AppointmentModel>(
                builder: (context, appointmentModel, child) {
                  final appointmentsOnSelectedDay = appointmentModel.appointments
                      .where((appointment) => isSameDay(appointment.date, _selectedDay))
                      .toList();

                  return appointmentsOnSelectedDay.isEmpty
                      ? Center(
                          child: Text(
                            'Keine Termine an diesem Tag',
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      : ListView(
                          children: appointmentsOnSelectedDay
                              .map(
                                (appointment) => Card(
                                  child: ListTile(
                                    leading: Icon(Icons.event),
                                    title: Text(appointment.description),
                                    subtitle: Text(
                                      '${appointment.time.format(context)}',
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          _removeAppointment(appointment),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                },
              ),
            ),
        ],
      ),
    );
  }
}
