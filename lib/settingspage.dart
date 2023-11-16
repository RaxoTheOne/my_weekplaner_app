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
      ],
    );
  }
}