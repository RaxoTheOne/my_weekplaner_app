import 'package:flutter/material.dart';
import 'package:my_weekplaner_app/presentation/settingspage.dart';

class SettingsLogic extends ChangeNotifier {
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