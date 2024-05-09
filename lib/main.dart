import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/application/apointment_logic.dart';
import 'package:my_weekplaner_app/application/settings_logic.dart';
import 'package:my_weekplaner_app/data/firebase_options.dart';
import 'package:my_weekplaner_app/presentation/settingspage.dart';
import 'package:my_weekplaner_app/widgets/splashscreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsLogic()),
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
    return Consumer<SettingsLogic>(
      builder: (context, settingsModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Weekplaner-App',
          theme: _buildThemeData(context, settingsModel),
          home: SplashScreen(),
        );
      },
    );
  }

  ThemeData _buildThemeData(BuildContext context, SettingsLogic settingsModel) {
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
