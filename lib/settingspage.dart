import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/main.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Deutsch';
  String _selectedDateFormat = 'DD/MM/YYYY';
  String _selectedTimeFormat = '12-Stunden';
  String _selectedFirstDay = 'Sonntag';

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    return ListView(
      children: <Widget>[
        SwitchListTile(
          title: const Text('Benachrichtigungen'),
          value: settingsModel.notificationsOn,
          onChanged: (bool value) {
            settingsModel.setNotificationsOn(value);
          },
        ),
        SwitchListTile(
          title: const Text('Dunkelmodus'),
          value: settingsModel.darkModeOn,
          onChanged: (bool value) {
            settingsModel.setDarkModeOn(value);
          },
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
                child: Text(value),
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
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Zeitformat'),
          trailing: DropdownButton<String>(
            value: _selectedTimeFormat,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTimeFormat = newValue!;
              });
            },
            items: <String>['12-Stunden', '24-Stunden']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Erster Tag der Woche'),
          trailing: DropdownButton<String>(
            value: _selectedFirstDay,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFirstDay = newValue!;
              });
            },
            items: <String>['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Erinnerungseinstellungen'),
          // Hier können weitere UI-Komponenten für Erinnerungseinstellungen hinzugefügt werden
        ),
      ],
    );
  }
}
