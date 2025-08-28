import 'package:flutter/material.dart';
import '../services/oauth_service.dart';

class OAuthProvider with ChangeNotifier {
  final OAuthService _oauthService = OAuthService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _mfaRequired = false;
  bool _verifyingMfa = false;
  String? _mfaError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get mfaRequired => _mfaRequired;
  bool get verifyingMfa => _verifyingMfa;
  String? get mfaError => _mfaError;

  Future<void> signIn() async {
    _setLoading(true);
    try {
      // Simulate OAuth2 sign-in
      final result = await _oauthService.signInWithOAuth();
      // Simulate MFA required (replace with real check)
      if (result != null /* && result.requiresMfa */) {
        _mfaRequired = true;
        notifyListeners();
      } else {
        _setError(null);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyMfaCode(String code) async {
    _verifyingMfa = true;
    _mfaError = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    if (code == '123456') {
      // Replace with real verification
      _mfaRequired = false;
      _mfaError = null;
    } else {
      _mfaError = 'Invalid MFA code.';
    }
    _verifyingMfa = false;
    notifyListeners();
  }

  // Token refresh implementation
  Future<void> refreshToken(String refreshToken) async {
    _setLoading(true);
    try {
      await _oauthService.refreshToken(refreshToken: refreshToken);
      // Store or use tokenResponse as needed (e.g., update access token)
      _setError(null);
      // Optionally notifyListeners();
    } catch (e) {
      _setError('Token refresh failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}
