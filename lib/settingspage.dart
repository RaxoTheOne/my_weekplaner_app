import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ThemeModeOption {
  Dark,
  Light,
  System,
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Deutsch';
  String _selectedDateFormat = 'DD/MM/YYYY';
  ThemeModeOption _selectedThemeModeOption = ThemeModeOption.System;

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    final brightness = Theme.of(context).brightness;

    return ListView(
      children: <Widget>[
        SwitchListTile(
          title: const Text('Benachrichtigungen'),
          value: settingsModel.notificationsOn,
          onChanged: (bool value) {
            settingsModel.setNotificationsOn(value);
          },
        ),
        ListTile(
          title: const Text('Dunkelmodus'),
          trailing: DropdownButton<ThemeModeOption>(
            value: _selectedThemeModeOption,
            onChanged: (ThemeModeOption? newValue) {
              setState(() {
                _selectedThemeModeOption = newValue!;
                _updateThemeMode(settingsModel);
              });
            },
            items: ThemeModeOption.values
                .map<DropdownMenuItem<ThemeModeOption>>(
                    (ThemeModeOption value) {
              return DropdownMenuItem<ThemeModeOption>(
                value: value,
                child: Text(
                  _themeModeOptionToString(value),
                  style: TextStyle(
                    color: brightness == Brightness.light
                        ? Colors.black // Hellmodus
                        : Colors.white, // Dunkelmodus
                  ),
                ),
              );
            }).toList(),
          ),
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
                child: Text(
                  value,
                  style: TextStyle(
                    color: brightness == Brightness.light
                        ? Colors.black // Hellmodus
                        : Colors.white, // Dunkelmodus
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Datumsformat'),
          trailing: DropdownButton<String>(
            value: _selectedDateFormat,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDateFormat = newValue!;
              });
            },
            items: <String>['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: brightness == Brightness.light
                        ? Colors.black // Hellmodus
                        : Colors.white, // Dunkelmodus
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _themeModeOptionToString(ThemeModeOption themeModeOption) {
    switch (themeModeOption) {
      case ThemeModeOption.Dark:
        return 'Dark';
      case ThemeModeOption.Light:
        return 'Light';
      case ThemeModeOption.System:
        return 'System';
    }
  }

  void _updateThemeMode(SettingsModel settingsModel) {
    switch (_selectedThemeModeOption) {
      case ThemeModeOption.Dark:
        settingsModel.setDarkModeOn(true);
        break;
      case ThemeModeOption.Light:
        settingsModel.setDarkModeOn(false);
        break;
      case ThemeModeOption.System:
        // Implementiere hier die Logik, um den Dunkelmodus an das System zu binden
        // Du kannst hier den vorigen Code verwenden, um den Dunkelmodus an das System anzupassen
        // Achte darauf, die Helligkeitsänderungen auch im `initState` oder `didChangePlatformBrightness` zu überwachen.
        break;
    }
  }
}

class SettingsModel extends ChangeNotifier {
  bool _notificationsOn = false;
  bool _darkModeOn = false;
  ThemeModeOption _selectedThemeModeOption = ThemeModeOption.System;

  bool get notificationsOn => _notificationsOn;
  bool get darkModeOn => _darkModeOn;
  ThemeModeOption get selectedThemeModeOption => _selectedThemeModeOption;

  void setNotificationsOn(bool value) {
    _notificationsOn = value;
    notifyListeners();
  }

  void setDarkModeOn(bool value) {
    _darkModeOn = value;
    _selectedThemeModeOption = value
        ? ThemeModeOption.Dark
        : ThemeModeOption.Light; // Aktualisiere die ausgewählte Dunkelmodus-Option
    notifyListeners();
  }
}
