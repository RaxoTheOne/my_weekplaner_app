import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/Data/apointment_model.dart';
import 'package:my_weekplaner_app/Data/firebase_options.dart';
import 'package:my_weekplaner_app/Presentation/settingspage.dart';
import 'package:my_weekplaner_app/Widgets/splashscreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
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
        ChangeNotifierProvider(create: (context) => AppointmentLogic()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settingsModel, child) {
        return MaterialApp(
          title: 'My Weekplaner-App',
          theme: _buildThemeData(context, settingsModel),
          home: SplashScreen(),
        );
      },
    );
  }

  ThemeData _buildThemeData(BuildContext context, SettingsModel settingsModel) {
    // Aktuellen Brightness-Modus abrufen (Dark oder Light)
    final brightness = MediaQuery.of(context).platformBrightness;

    // Überprüfen, ob der Dunkelmodus basierend auf den Systemeinstellungen aktiviert werden soll
    if (settingsModel.selectedThemeModeOption == ThemeModeOption.System) {
      return ThemeData(
        brightness: brightness,
      );
    } else {
      // Andernfalls, basierend auf den Einstellungen des Benutzers
      return ThemeData(
        brightness:
            settingsModel.selectedThemeModeOption == ThemeModeOption.Dark
                ? Brightness.dark
                : Brightness.light,
      );
    }
  }
}
