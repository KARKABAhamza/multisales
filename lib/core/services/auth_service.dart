import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'network_service.dart';

/// Simple Auth service following the app's Service Layer conventions.
/// Replace mock logic with Firebase Auth or OAuth implementation later.
class AuthService {
  final _network = NetworkService();
  /// Basic email/password sign in via Firebase Auth
  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Credentials required');
    }
    try {
      await _network.ensureOnline();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 15));
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    } on NetworkException catch (e) {
      throw AuthException(e.message);
    } on TimeoutException {
      throw AuthException('Network timeout, please try again');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Simple role check based on email domain.
  /// Treat any authenticated user with a `@multisales.com` email as admin.
  bool isAdminEmail() {
    try {
      if (Firebase.apps.isEmpty) return false;
    } catch (_) {
      return false;
    }
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return false;
    return email.toLowerCase().endsWith('@multisales.com');
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
