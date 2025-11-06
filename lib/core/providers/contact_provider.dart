import 'package:flutter/foundation.dart';
import '../services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  ContactProvider({ContactService? service}) : _service = service ?? ContactService();

  final ContactService _service;

  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    if (_errorMessage == msg) return;
    _errorMessage = msg;
    notifyListeners();
  }

  Future<bool> submit({required String name, required String email, required String message}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.submitContact(name: name, email: email, message: message);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
