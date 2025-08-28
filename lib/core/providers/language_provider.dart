import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('fr', 'FR'), // French
    Locale('ar', 'SA'), // Arabic
    Locale('es', 'ES'), // Spanish
    Locale('de', 'DE'), // German
  ];

  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'fr': 'Français',
    'ar': 'العربية',
    'es': 'Español',
    'de': 'Deutsch',
  };

  LanguageProvider() {
    _loadSavedLanguage();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      _setError('Language not supported: ${locale.languageCode}');
      return;
    }

    _setLoading(true);

    try {
      _currentLocale = locale;
      await _saveLanguagePreference(locale);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to change language: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Change language by language code
  Future<void> changeLanguageByCode(String languageCode) async {
    final locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en', 'US'),
    );

    await changeLanguage(locale);
  }

  // Get language name for display
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode.toUpperCase();
  }

  // Get current language name
  String get currentLanguageName =>
      getLanguageName(_currentLocale.languageCode);

  // Check if locale is supported
  bool isLocaleSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  // Reset to default language
  Future<void> resetToDefault() async {
    await changeLanguage(const Locale('en', 'US'));
  }

  // Load saved language preference
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('selected_language');

      if (savedLanguageCode != null) {
        await changeLanguageByCode(savedLanguageCode);
      }
    } catch (e) {
      _setError('Failed to load language preference: ${e.toString()}');
    }
  }

  // Save language preference
  Future<void> _saveLanguagePreference(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', locale.languageCode);
    } catch (e) {
      _setError('Failed to save language preference: ${e.toString()}');
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get locale from device
  Locale getDeviceLocale() {
    final deviceLocales = ui.PlatformDispatcher.instance.locales;

    if (deviceLocales.isNotEmpty) {
      // Find first supported locale from device locales
      for (final deviceLocale in deviceLocales) {
        final matchingLocale = supportedLocales
            .where(
              (supportedLocale) =>
                  supportedLocale.languageCode == deviceLocale.languageCode,
            )
            .firstOrNull;

        if (matchingLocale != null) {
          return matchingLocale;
        }
      }
    }

    // Fallback to default if no supported locale found
    return const Locale('en', 'US');
  }

  // Auto-detect and set language from device
  Future<void> autoDetectLanguage() async {
    final deviceLocale = getDeviceLocale();
    if (isLocaleSupported(deviceLocale)) {
      await changeLanguage(deviceLocale);
    }
  }
}
