import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppointmentModel(),
      child: const MeineApp(),
    ),
  );
}

class MeineApp extends StatelessWidget {
  const MeineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Meine Wochenplaner-App',
      home: MeinHomebildschirm(),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
        final upcomingAppointments = appointmentModel.appointments.where((appointment) =>
            appointment.date.isAfter(DateTime.now()) &&
            appointment.date.isBefore(DateTime.now().add(Duration(days: 7))));

        return ListView(
          children: upcomingAppointments.map((appointment) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text(appointment.description),
                subtitle: Text(DateFormat('yMMMd').format(appointment.date)),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => appointmentModel.removeAppointment(appointment),
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

  void _addAppointment() {
    if (_selectedDay != null) {
      final appointmentModel = Provider.of<AppointmentModel>(context, listen: false);
      appointmentModel.addAppointment(Appointment(
        date: _selectedDay!,
        description: 'Neuer Termin',
      ));
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
            _addAppointment();
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
  bool _notificationsOn = false;
  bool _darkModeOn = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SwitchListTile(
          title: const Text('Benachrichtigungen'),
          value: _notificationsOn,
          onChanged: (bool value) {
            setState(() {
              _notificationsOn = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Dunkelmodus'),
          value: _darkModeOn,
          onChanged: (bool value) {
            setState(() {
              _darkModeOn = value;
            });
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
  final String description;

  Appointment({
    required this.date,
    required this.description,
  });
}

class AppointmentModel extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

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
