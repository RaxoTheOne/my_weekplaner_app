import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/Application/settings_logic.dart';
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
    final settingsModel = Provider.of<SettingsLogic>(context);
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