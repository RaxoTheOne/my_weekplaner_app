import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/splashscreen.dart';
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
          home: SplashScreen(),
        );
      },
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
