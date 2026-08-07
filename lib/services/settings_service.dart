import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _vibrationKey = 'noor_setting_vibration';
  static const String _soundKey = 'noor_setting_sound';
  static const String _reminderKey = 'noor_setting_reminder';
  static const String _themeKey = 'noor_setting_theme_style'; // 'emerald', 'amoled', 'navy'

  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  bool _dailyReminders = true;
  String _themeStyle = 'emerald'; // Default Emerald Green & Gold

  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get dailyReminders => _dailyReminders;
  String get themeStyle => _themeStyle;

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
    _soundEnabled = prefs.getBool(_soundKey) ?? true;
    _dailyReminders = prefs.getBool(_reminderKey) ?? true;
    _themeStyle = prefs.getString(_themeKey) ?? 'emerald';
    notifyListeners();
  }

  Future<void> setVibration(bool val) async {
    _vibrationEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, val);
    notifyListeners();
  }

  Future<void> setSound(bool val) async {
    _soundEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, val);
    notifyListeners();
  }

  Future<void> setDailyReminders(bool val) async {
    _dailyReminders = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderKey, val);
    notifyListeners();
  }

  Future<void> setThemeStyle(String style) async {
    _themeStyle = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, style);
    notifyListeners();
  }
}
