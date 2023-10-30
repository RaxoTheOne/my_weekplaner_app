import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MeineApp());
}

class MeineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine Wochenplaner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeinHomebildschirm(title: 'Home'),
    );
  }
}

class MeinHomebildschirm extends StatefulWidget {
  MeinHomebildschirm({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MeinHomebildschirmState createState() => _MeinHomebildschirmState();
}

class _MeinHomebildschirmState extends State<MeinHomebildschirm> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hintergrund.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: TableCalendar(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NeuerTerminSeite()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NeuerTerminSeite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neuer Termin'),
      ),
      body: Center(
        child: Text('Hier können Benutzer Details zu ihrem neuen Termin eingeben.'),
      ),
    );
  }
}
