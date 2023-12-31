import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weekplaner_app/apointment_model.dart';
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
  TextEditingController _descriptionController = TextEditingController();

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

  void _addAppointment() {
    final description = _descriptionController.text.trim();
    if (_selectedDay != null && description.isNotEmpty) {
      final appointmentModel =
          Provider.of<AppointmentModel>(context, listen: false);
      appointmentModel.addAppointment(Appointment(
        date: _selectedDay!,
        description: description,
      ));
      _saveAppointments();
      setState(() {
        _descriptionController.text = '';
        _selectedDay = null;
      });
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
    return SingleChildScrollView(
      // Wrap with SingleChildScrollView
      child: Padding(
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
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Terminbeschreibung',
                border: OutlineInputBorder(),
              ),
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
              Consumer<AppointmentModel>(
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
                      : Column(
                          children: appointmentsOnSelectedDay
                              .map(
                                (appointment) => ListTile(
                                  tileColor: Color.fromARGB(255, 220, 210, 204),
                                  title: Text(
                                    appointment.description,
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color.fromARGB(255, 107, 107,107) // Ändere diese Farbe nach Bedarf
                                          : const Color.fromRGBO(0, 0, 0, 1), // Oder eine andere Farbe für den Light Mode
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? const Color.fromARGB(255,107,107,107) // Dark Mode Farbe hier änderbar nach Bedarf
                                            : const Color.fromARGB(0, 0, 0, 1), // LightMode Farbe hier änderbar nach Bedarf
                                        ),
                                    onPressed: () =>
                                        _removeAppointment(appointment),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                },
              ),
          ],
        ),
      ),
    );
  }
}
