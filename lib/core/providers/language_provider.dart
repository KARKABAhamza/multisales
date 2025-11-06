// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Minimal LanguageProvider following project conventions
class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  bool _isLoading = false;
  String? _errorMessage;

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void changeLanguage(Locale locale) {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    notifyListeners();
  }

  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    if (_errorMessage == message) return;
    _errorMessage = message;
    notifyListeners();
  }
}
