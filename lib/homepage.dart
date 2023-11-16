import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weekplaner_app/main.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentModel>(
      builder: (context, appointmentModel, child) {
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