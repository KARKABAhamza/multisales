import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

/// Minimal Auth provider following project conventions
class OptimizedAuthProvider with ChangeNotifier {
  OptimizedAuthProvider({AuthService? authService}) : _authService = authService ?? AuthService();

  final AuthService _authService;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setAuthenticated(bool value) {
    if (_isAuthenticated == value) return;
    _isAuthenticated = value;
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

  Future<bool> login(String email, String password) async {
    setLoading(true);
    setError(null);
    try {
      await _authService.signIn(email, password);
      setAuthenticated(true);
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  void logout() {
    _authService.signOut();
    setAuthenticated(false);
  }
}
