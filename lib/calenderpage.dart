import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/main.dart';
import 'package:provider/provider.dart';
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          alignment: Alignment.center,
          child: TextField(
            decoration: InputDecoration(labelText: 'Terminbeschreibung'),
            onChanged: (value) {
              setState(() {
                _newAppointmentDescription = value;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.calendar_today),
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
            ),
            Text(
              'Uhrzeit: ${_selectedTime.format(context)}',
              style: TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: Icon(Icons.access_time),
              onPressed: () => _selectTime(context),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addAppointment,
              child: Text('Termin hinzufügen'),
            ),
          ],
        )
      ],
    );
  }
}