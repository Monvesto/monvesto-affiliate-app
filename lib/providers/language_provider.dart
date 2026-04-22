import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('de');

  Locale get locale => _locale;

  // ─── Sprache initialisieren ───
  Future<void> init(String? countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language');

    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    } else if (countryCode != null) {
      _locale = _localeFromCountry(countryCode);
    } else {
      final systemLocale =
          WidgetsBinding.instance.platformDispatcher.locale;
      _locale = systemLocale.languageCode == 'de'
          ? const Locale('de')
          : const Locale('en');
    }
    notifyListeners();
  }

  // ─── Sprache ändern ───
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // ─── Land zu Sprache ───
  Locale _localeFromCountry(String countryCode) {
    switch (countryCode) {
      case 'DE':
      case 'AT':
      case 'CH':
        return const Locale('de');
      default:
        return const Locale('en');
    }
  }

  // ─── Sprache als Text ───
  String get languageName {
    return _locale.languageCode == 'de' ? '🇩🇪 Deutsch' : '🇬🇧 English';
  }
}