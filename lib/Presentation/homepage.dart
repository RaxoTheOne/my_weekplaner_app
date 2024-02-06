import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weekplaner_app/application/apointment_logic.dart';
import 'package:my_weekplaner_app/data/apointment_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() async {
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);
    await appointmentModel.loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentLogic>(
      builder: (context, appointmentModel, child) {
        List<Appointment> upcomingAppointments = appointmentModel.appointments
            .where(
              (appointment) =>
                  appointment.date.month == _selectedDate.month &&
                  appointment.date.year == _selectedDate.year,
            )
            .toList();

        // Sortiere die Termine nach Datum und Uhrzeit
        upcomingAppointments.sort((a, b) {
          final dateComparison = a.date.compareTo(b.date);
          if (dateComparison != 0) {
            return dateComparison;
          }
          return a.time.hour * 60 +
              a.time.minute -
              (b.time.hour * 60 + b.time.minute);
        });

        final brightness = Theme.of(context).brightness;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text('Übersicht'),
          ),
          body: Column(
            children: [
              if (upcomingAppointments.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Keine bevorstehenden Termine',
                      style: TextStyle(
                        fontSize: 17,
                        color: brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: upcomingAppointments.map((appointment) {
                      return Card(
                        color: brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          leading: Icon(Icons.event),
                          title: Text(
                            '${appointment.description} um ${appointment.time.format(context)}',
                            style: TextStyle(
                              color: brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${DateFormat('yMMMd').format(appointment.date)}',
                            style: TextStyle(
                              color: brightness == Brightness.light
                                  ? Colors.black54
                                  : Colors.white70,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              appointmentModel.removeAppointment(appointment);
                              _updateInteractionStatus(context);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateInteractionStatus(BuildContext context) async {
    final appointmentModel =
        Provider.of<AppointmentLogic>(context, listen: false);
    await appointmentModel.saveAppointments();
  }
}
