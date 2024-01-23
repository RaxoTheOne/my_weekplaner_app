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
            value: settingsModel.selectedThemeModeOption,
            onChanged: (ThemeModeOption? newValue) {
              setState(() {
                settingsModel.setThemeModeOption(newValue!);
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
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Sprache'),
          trailing: DropdownButton<String>(
            value: settingsModel.selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                settingsModel.setSelectedLanguage(newValue!);
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
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Datumsformat'),
          trailing: DropdownButton<String>(
            value: settingsModel.selectedDateFormat,
            onChanged: (String? newValue) {
              setState(() {
                settingsModel.setSelectedDateFormat(newValue!);
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
                        ? Colors.black
                        : Colors.white,
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
}

class SettingsModel extends ChangeNotifier {
  bool _notificationsOn = false;
  bool _darkModeOn = false;
  ThemeModeOption _selectedThemeModeOption = ThemeModeOption.System;
  String _selectedLanguage = 'Deutsch';
  String _selectedDateFormat = 'DD/MM/YYYY';

  bool get notificationsOn => _notificationsOn;
  bool get darkModeOn => _darkModeOn;
  ThemeModeOption get selectedThemeModeOption => _selectedThemeModeOption;
  String get selectedLanguage => _selectedLanguage;
  String get selectedDateFormat => _selectedDateFormat;

  void setNotificationsOn(bool value) {
    _notificationsOn = value;
    notifyListeners();
  }

  void setDarkModeOn(bool value) {
    _darkModeOn = value;
    _selectedThemeModeOption = value
        ? ThemeModeOption.Dark
        : ThemeModeOption.Light;
    notifyListeners();
  }

  void setThemeModeOption(ThemeModeOption option) {
    _selectedThemeModeOption = option;
    notifyListeners();
  }

  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setSelectedDateFormat(String dateFormat) {
    _selectedDateFormat = dateFormat;
    notifyListeners();
  }
}
