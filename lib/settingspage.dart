import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Deutsch';
  String _selectedDateFormat = 'DD/MM/YYYY';

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
        SwitchListTile(
          title: const Text('Dunkelmodus'),
          value: brightness == Brightness.dark,
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
