import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsModel()),
        ChangeNotifierProvider(create: (context) => AppointmentModel()),
      ],
      child: MaterialApp(
        home: const MeineApp(),
      ),
    ),
  );
}

class MeineApp extends StatelessWidget {
  const MeineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settingsModel, child) {
        return MaterialApp(
          title: 'Meine Wochenplaner-App',
          theme: ThemeData(
            brightness:
                settingsModel.darkModeOn ? Brightness.dark : Brightness.light,
          ),
          home: const MeinHomebildschirm(),
        );
      },
    );
  }
}

class MeinHomebildschirm extends StatefulWidget {
  const MeinHomebildschirm({Key? key}) : super(key: key);

  @override
  _MeinHomebildschirmState createState() => _MeinHomebildschirmState();
}

class _MeinHomebildschirmState extends State<MeinHomebildschirm> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CalendarPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Wochenplaner-App'),
        backgroundColor: Colors.orange,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentModel>(
      builder: (context, appointmentModel, child) {
        if (appointmentModel.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final upcomingAppointments = appointmentModel.appointments.where(
          (appointment) =>
              appointment.date.isAfter(DateTime.now()) &&
              appointment.date.isBefore(DateTime.now().add(Duration(days: 7))),
        );

        return ListView(
          children: upcomingAppointments.map((appointment) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text(appointment.description),
                subtitle: Text(
                  '${DateFormat('yMMMd').format(appointment.date)} ${appointment.time.format(context)}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      appointmentModel.removeAppointment(appointment),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
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

  void _selectTime(BuildContext context) async {
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

  void _addAppointment() async {
    if (_selectedDay != null && _newAppointmentDescription.isNotEmpty) {
      final appointmentModel =
          Provider.of<AppointmentModel>(context, listen: false);

      // Zeige den Ladeanzeiger an
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false,
      );

      try {
        // Simuliere eine asynchrone Aufgabe (ersetze dies durch deine tatsächliche Logik)
        await Future.delayed(Duration(seconds: 2));

        // Füge den Termin hinzu
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
      } finally {
        // Schließe den Ladeanzeiger unabhängig vom Erfolg oder Fehler
        Navigator.of(context).pop();
      }
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

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Deutsch';

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    return ListView(
      children: <Widget>[
        SwitchListTile(
          title: const Text('Benachrichtigungen'),
          value: settingsModel.notificationsOn,
          onChanged: (bool value) {
            settingsModel.setNotificationsOn(value);
          },
        ),
        SwitchListTile(
          title: const Text('Dunkelmodus'),
          value: settingsModel.darkModeOn,
          onChanged: (bool value) {
            settingsModel.setDarkModeOn(value);
          },
        ),
        ListTile(
          title: const Text('Sprache'),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items: <String>['English', 'Deutsch', 'Español', 'Français']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class Appointment {
  final DateTime date;
  final TimeOfDay time;
  final String description;

  Appointment({
    required this.date,
    required this.time,
    required this.description,
  });
}

class AppointmentModel extends ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  void loadAppointments() async {
    _isLoading = true;
    notifyListeners();

    // Simuliere eine Datenladefunktion (ersetze dies durch deine tatsächliche Logik)
    await Future.delayed(Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(Appointment appointment) {
    if (_appointments.contains(appointment)) {
      _appointments.remove(appointment);
      notifyListeners();
    }
  }
}

class SettingsModel extends ChangeNotifier {
  bool _notificationsOn = false;
  bool _darkModeOn = false;

  bool get notificationsOn => _notificationsOn;
  bool get darkModeOn => _darkModeOn;

  void setNotificationsOn(bool value) {
    _notificationsOn = value;
    notifyListeners();
  }

  void setDarkModeOn(bool value) {
    _darkModeOn = value;
    notifyListeners();
  }
}