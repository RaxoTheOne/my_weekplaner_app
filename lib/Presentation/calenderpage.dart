import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weekplaner_app/application/apointment_logic.dart';
import 'package:my_weekplaner_app/data/apointment_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> dropdownData = <String>[];
  String? _selectedCategory; // Variable für die ausgewählte Kategorie

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _loadDropdownData();
    fetchCategoriesFromFirestore();
  }

  void _loadAppointments() async {
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);
    await appointmentModel.loadAppointments();
  }

  Future<void> _loadDropdownData() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('Kategorien').get();

      setState(() {
        dropdownData = querySnapshot.docs
            .map<String>((doc) =>
                (doc['name'] as dynamic)?.toString() ??
                "") // Name des Feldes in Firestore anpassen
            .toList();
      });
    } catch (e) {
      print("Fehler beim Abrufen von Firestore-Daten für Dropdown-Menü: $e");
    }
  }

  void _addAppointment() async {
    final description = _descriptionController.text.trim();
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);

    if (_selectedDay != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        String appointmentDescription;

        // Überprüfe, ob das Textfeld leer ist
        if (description.isNotEmpty) {
          appointmentDescription = description;
        } else if (_selectedCategory != null) {
          appointmentDescription = _selectedCategory!;
        } else {
          appointmentDescription = ''; // Setze die Beschreibung auf leer, wenn beide leer sind
        }

        appointmentModel.addAppointment(Appointment(
          date: _selectedDay!,
          time: selectedTime,
          description: appointmentDescription,
          category: _selectedCategory ?? '', // Verwende die ausgewählte Kategorie oder leer, wenn keine ausgewählt ist
        ));
        _saveAppointments();
        setState(() {
          _descriptionController.text = '';
          _selectedDay = null;
          _selectedCategory = null; // Zurücksetzen der ausgewählten Kategorie nach dem Hinzufügen
        });
      }
    }
  }

  void _removeAppointmentsOnDate(DateTime date) {
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);
    appointmentModel.removeAppointmentsOnDate(date);
    _saveAppointments();
  }

  void _removeAppointment(Appointment appointment) {
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);
    appointmentModel.removeAppointment(appointment);
    _saveAppointments();
  }

  Future<void> _saveAppointments() async {
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);
    await appointmentModel.saveAppointments();
  }

  // Daten aus Firestore abrufen
  void fetchCategoriesFromFirestore() {
    FirebaseFirestore.instance.collection('Kategorien').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        print(
            'Kategorie: ${doc['name']}, Beschreibung: ${doc['beschreibung']}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                // Hier die Größe des Kalenders anpassen
                cellMargin: EdgeInsets.all(0),
                outsideDaysVisible: false,
              ),
              rowHeight: 35,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Event/Terminbeschreibung',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: DropdownButtonFormField<String>(
                value: _selectedCategory, // Hinzugefügt
                items: dropdownData.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? selectedValue) {
                  setState(() {
                    _selectedCategory =
                        selectedValue; // Speichere die ausgewählte Kategorie
                  });
                },
                hint: Text('Wähle eine Kategorie aus'),
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
                  child: Text('Termin entfernen'),
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
              Consumer<AppointmentLogic>(
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
                                (appointment) => Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${appointment.description} um ${appointment.time.format(context)}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            _removeAppointment(appointment),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        );
                },
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
