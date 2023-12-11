import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/firebase_options.dart';
import 'package:my_weekplaner_app/splashscreen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }
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
  DateTime date;
  TimeOfDay time;
  String description;

  Appointment({required this.date, required this.time, required this.description});

  String toString() {
    return '$date#${time.hour}:${time.minute}#$description';
  }

  static Appointment fromString(String appointmentString) {
    final parts = appointmentString.split('#');
    final date = DateTime.parse(parts[0]);
    final timeParts = parts[1].split(':');
    final time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    final description = parts[2];

    return Appointment(date: date, time: time, description: description);
  }
}

class AppointmentModel extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(Appointment appointment) {
    _appointments.remove(appointment);
    notifyListeners();
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
