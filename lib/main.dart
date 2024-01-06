import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/apointment_model.dart';
import 'package:my_weekplaner_app/firebase_options.dart';
import 'package:my_weekplaner_app/settingspage.dart';
import 'package:my_weekplaner_app/splashscreen.dart';
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
        ChangeNotifierProvider(create: (context) => AppointmentModel()),
      ],
      child: const MeineApp(),
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
