import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weekplaner_app/apointment_model.dart';
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
        Provider.of<AppointmentModel>(context, listen: false);
    await appointmentModel.loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentModel>(
      builder: (context, appointmentModel, child) {
        List<Appointment> bevorstehendeTermine = appointmentModel.appointments
            .where(
              (appointment) =>
                  appointment.date.month == _selectedDate.month &&
                  appointment.date.year == _selectedDate.year,
            )
            .toList();

        // Sortiere die Termine nach Datum
        bevorstehendeTermine.sort((a, b) => a.date.compareTo(b.date));

        final brightness = Theme.of(context).brightness;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text('Overview'),
          ),
          body: Column(
            children: [
              if (bevorstehendeTermine.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Keine bevorstehenden Termine',
                      style: TextStyle(
                        fontSize: 17,
                        color: brightness == Brightness.light
                            ? Colors.black // Hellmodus
                            : Colors.white, // Dunkelmodus
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: bevorstehendeTermine.map((appointment) {
                      return Card(
                        color: brightness == Brightness.light
                            ? Colors.white // Hellmodus
                            : Colors.grey[800], // Dunkelmodus
                        child: ListTile(
                          leading: Icon(Icons.event),
                          title: Text(
                            appointment.description,
                            style: TextStyle(
                              color: brightness == Brightness.light
                                  ? Colors.black // Hellmodus
                                  : Colors.white, // Dunkelmodus
                            ),
                          ),
                          subtitle: Text(
                            '${DateFormat('yMMMd').format(appointment.date)}',
                            style: TextStyle(
                              color: brightness == Brightness.light
                                  ? Colors.black54 // Hellmodus
                                  : Colors.white70, // Dunkelmodus
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              appointmentModel.removeAppointment(appointment);
                              _updateInteraktionsstatus(context);
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

  Future<void> _updateInteraktionsstatus(BuildContext context) async {
    final appointmentModel =
        Provider.of<AppointmentModel>(context, listen: false);
    await appointmentModel.saveAppointments();
  }
}
