import 'package:flutter/material.dart';

class ContactProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _success = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get success => _success;

  Future<void> sendContactMessage(String name, String email, String message) async {
    _isLoading = true;
    _errorMessage = null;
    _success = false;
    notifyListeners();
    try {
      // Simule l'envoi (remplacer par appel service réel)
      await Future.delayed(const Duration(seconds: 1));
      _success = true;
    } catch (e) {
        _errorMessage = "Erreur lors de l'envoi du message."; // Using _errorMessage to avoid unused field error
    }
    _isLoading = false;
    notifyListeners();
  }
}
