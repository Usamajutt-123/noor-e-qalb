import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _langKey = 'noor_app_language_code';
  static const String _onboardingKey = 'noor_onboarding_completed';

  bool _isUrdu = true; // Default Urdu for Pakistan / South Asia
  bool _isOnboardingCompleted = false;

  bool get isUrdu => _isUrdu;
  bool get isOnboardingCompleted => _isOnboardingCompleted;

  LanguageService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_langKey) ?? 'ur';
    _isUrdu = (code == 'ur');
    _isOnboardingCompleted = prefs.getBool(_onboardingKey) ?? false;
    notifyListeners();
  }

  Future<void> setLanguage(bool urdu) async {
    _isUrdu = urdu;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, urdu ? 'ur' : 'en');
    notifyListeners();
  }

  Future<void> completeOnboarding(bool urdu) async {
    _isUrdu = urdu;
    _isOnboardingCompleted = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, urdu ? 'ur' : 'en');
    await prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  // Helper translation dictionary
  String t(String urduText, String englishText) {
    return _isUrdu ? urduText : englishText;
  }
}
