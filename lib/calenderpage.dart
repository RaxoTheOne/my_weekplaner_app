import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/apointment_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
    final appointmentModel =
        Provider.of<AppointmentModel>(context, listen: false);
    await appointmentModel.loadAppointments();
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

  Future<void> _saveAppointments() async {
    final appointmentModel =
        Provider.of<AppointmentModel>(context, listen: false);
    await appointmentModel.saveAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
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
          SizedBox(height: 10),
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _selectTime(context),
                icon: Icon(Icons.access_time),
                label: Text('Uhrzeit auswählen'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addAppointment,
                child: Text('Termin hinzufügen'),
              ),
              SizedBox(width: 10),
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
          SizedBox(height: 10),
          if (_selectedDay != null)
            Text(
              'Termine am ${DateFormat('MMMM d, y').format(_selectedDay!)}:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (_selectedDay != null)
            Expanded(
              child: Consumer<AppointmentModel>(
                builder: (context, appointmentModel, child) {
                  final appointmentsOnSelectedDay = appointmentModel
                      .appointments
                      .where((appointment) =>
                          isSameDay(appointment.date, _selectedDay))
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
                                (appointment) => ListTile(
                                  tileColor: Colors.grey[200],
                                  title: Text(appointment.description),
                                  subtitle: Text(
                                    '${DateFormat('HH:mm').format(DateTime(2023, 1, 1, appointment.time.hour, appointment.time.minute))}',
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _removeAppointment(appointment),
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
