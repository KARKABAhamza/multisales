import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../constants/app_constants.dart';
import 'firestore_service.dart';
import 'analytics_service.dart';

/// Enhanced Authentication Service with comprehensive security features
class EnhancedAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirestoreService _firestoreService = FirestoreService();
  final AnalyticsService _analyticsService = AnalyticsService();

  // Session management
  static const String _lastActivityKey = 'last_activity';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _sessionTokenKey = 'session_token';
  static const Duration _sessionTimeout = Duration(minutes: 30);

  // Security configuration
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 15);

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Initialize authentication service
  Future<void> initialize() async {
    await _setupAuthStateListener();
    await _checkSessionTimeout();
  }

  /// Setup authentication state listener with security enhancements
  Future<void> _setupAuthStateListener() async {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _updateLastActivity();
        await _logSecurityEvent('auth_state_changed', {
          'user_id': user.uid,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  /// Enhanced sign in with comprehensive security
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password, {
    bool requireBiometric = false,
  }) async {
    try {
      // Check for account lockout
      final lockoutResult = await _checkAccountLockout(email);
      if (!lockoutResult.isSuccess) {
        return lockoutResult;
      }

      // Validate credentials format
      final validationResult = _validateCredentials(email, password);
      if (!validationResult.isSuccess) {
        return validationResult;
      }

      // Attempt Firebase authentication
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return AuthResult.failure('Authentication failed');
      }

      // Check if user is verified
      if (!user.emailVerified) {
        await _auth.signOut();
        return AuthResult.failure(
          'Please verify your email address before signing in',
        );
      }

      // Biometric authentication if required
      if (requireBiometric) {
        final biometricResult = await _authenticateWithBiometrics();
        if (!biometricResult.isSuccess) {
          await _auth.signOut();
          return biometricResult;
        }
      }

      // Reset failed attempts on successful login
      await _resetFailedAttempts(email);

      // Update user security information
      await _updateUserSecurityInfo(user);

      // Generate and store session token
      await _generateSessionToken(user.uid);

      // Log successful authentication
      await _analyticsService.logLogin(method: 'email');
      await _logSecurityEvent('successful_login', {
        'user_id': user.uid,
        'method': 'email_password',
        'timestamp': DateTime.now().toIso8601String(),
        'device_info': await _getDeviceInfo(),
      });

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      await _handleFailedLoginAttempt(email);
      await _logSecurityEvent('failed_login', {
        'email': email,
        'error_code': e.code,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Enhanced Auth Error: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  /// Enhanced user registration with security validations
  Future<AuthResult> registerWithEmailAndPassword(
    String email,
    String password, {
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String role = 'client',
  }) async {
    try {
      // Comprehensive validation
      final validationResult = _validateRegistrationData(
        email,
        password,
        firstName,
        lastName,
      );
      if (!validationResult.isSuccess) {
        return validationResult;
      }

      // Check password strength
      final passwordStrength = _validatePasswordStrength(password);
      if (passwordStrength.score < 3) {
        return AuthResult.failure(
          'Password is too weak. ${passwordStrength.feedback.join(' ')}',
        );
      }

      // Create Firebase account
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) {
        return AuthResult.failure('Registration failed');
      }

      // Update display name
      await user.updateDisplayName('$firstName $lastName');

      // Send email verification
      await user.sendEmailVerification();

      // Create comprehensive user profile
      await _createUserProfile(user, {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'role': role,
        'registrationTimestamp': DateTime.now().toIso8601String(),
        'securitySettings': {
          'passwordStrength': passwordStrength.score,
          'twoFactorEnabled': false,
          'biometricEnabled': false,
          'lastPasswordChange': DateTime.now().toIso8601String(),
        },
      });

      // Log registration event
      await _analyticsService.logSignUp(method: 'email');
      await _logSecurityEvent('user_registered', {
        'user_id': user.uid,
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Registration Error: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  /// Biometric authentication
  Future<AuthResult> authenticateWithBiometrics() async {
    return _authenticateWithBiometrics();
  }

  Future<AuthResult> _authenticateWithBiometrics() async {
    try {
      // Check if biometrics are available
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        return AuthResult.failure('Biometric authentication not available');
      }

      // Get available biometric types
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return AuthResult.failure('No biometric methods enrolled');
      }

      // Perform biometric authentication
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        await _logSecurityEvent('biometric_auth_success', {
          'timestamp': DateTime.now().toIso8601String(),
          'available_methods': availableBiometrics.map((b) => b.name).toList(),
        });
        return AuthResult.success(null);
      } else {
        await _logSecurityEvent('biometric_auth_failed', {
          'timestamp': DateTime.now().toIso8601String(),
        });
        return AuthResult.failure('Biometric authentication failed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Biometric Auth Error: $e');
      }
      return AuthResult.failure('Biometric authentication error');
    }
  }

  /// Check biometric availability
  Future<BiometricStatus> checkBiometricAvailability() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        return BiometricStatus.notAvailable;
      }

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return BiometricStatus.notEnrolled;
      }

      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return BiometricStatus.fingerprint;
      } else if (availableBiometrics.contains(BiometricType.face)) {
        return BiometricStatus.face;
      } else {
        return BiometricStatus.available;
      }
    } catch (e) {
      return BiometricStatus.error;
    }
  }

  /// Enable/disable biometric authentication
  Future<bool> setBiometricEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnabledKey, enabled);

      if (currentUser != null) {
        await _updateUserSecuritySetting('biometricEnabled', enabled);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Password strength validation
  PasswordStrength _validatePasswordStrength(String password) {
    final feedback = <String>[];
    int score = 0;

    // Length check
    if (password.length >= 8) {
      score++;
    } else {
      feedback.add('Use at least 8 characters.');
    }

    // Uppercase check
    if (password.contains(RegExp(r'[A-Z]'))) {
      score++;
    } else {
      feedback.add('Include uppercase letters.');
    }

    // Lowercase check
    if (password.contains(RegExp(r'[a-z]'))) {
      score++;
    } else {
      feedback.add('Include lowercase letters.');
    }

    // Number check
    if (password.contains(RegExp(r'[0-9]'))) {
      score++;
    } else {
      feedback.add('Include numbers.');
    }

    // Special character check
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++;
    } else {
      feedback.add('Include special characters.');
    }

    return PasswordStrength(score: score, feedback: feedback);
  }

  /// Session management
  Future<void> _updateLastActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          _lastActivityKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating last activity: $e');
      }
    }
  }

  Future<void> _checkSessionTimeout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastActivity = prefs.getInt(_lastActivityKey);

      if (lastActivity != null) {
        final lastActivityTime =
            DateTime.fromMillisecondsSinceEpoch(lastActivity);
        final timeDifference = DateTime.now().difference(lastActivityTime);

        if (timeDifference > _sessionTimeout && currentUser != null) {
          await signOut(reason: 'Session timeout');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking session timeout: $e');
      }
    }
  }

  /// Account security
  Future<AuthResult> _checkAccountLockout(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsKey = 'failed_attempts_$email';
      final lockoutKey = 'lockout_until_$email';

      final lockoutUntil = prefs.getInt(lockoutKey);
      if (lockoutUntil != null) {
        final lockoutTime = DateTime.fromMillisecondsSinceEpoch(lockoutUntil);
        if (DateTime.now().isBefore(lockoutTime)) {
          final remainingMinutes =
              lockoutTime.difference(DateTime.now()).inMinutes;
          return AuthResult.failure(
            'Account temporarily locked. Try again in $remainingMinutes minutes.',
          );
        } else {
          // Lockout expired, reset attempts
          await prefs.remove(attemptsKey);
          await prefs.remove(lockoutKey);
        }
      }

      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.success(null); // Allow login attempt if check fails
    }
  }

  Future<void> _handleFailedLoginAttempt(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsKey = 'failed_attempts_$email';
      final lockoutKey = 'lockout_until_$email';

      final currentAttempts = prefs.getInt(attemptsKey) ?? 0;
      final newAttempts = currentAttempts + 1;

      await prefs.setInt(attemptsKey, newAttempts);

      if (newAttempts >= _maxFailedAttempts) {
        final lockoutUntil = DateTime.now().add(_lockoutDuration);
        await prefs.setInt(lockoutKey, lockoutUntil.millisecondsSinceEpoch);

        await _logSecurityEvent('account_locked', {
          'email': email,
          'attempts': newAttempts,
          'lockout_until': lockoutUntil.toIso8601String(),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling failed login attempt: $e');
      }
    }
  }

  Future<void> _resetFailedAttempts(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('failed_attempts_$email');
      await prefs.remove('lockout_until_$email');
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting failed attempts: $e');
      }
    }
  }

  /// Validation methods
  AuthResult _validateCredentials(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Email and password are required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return AuthResult.failure('Please enter a valid email address');
    }

    return AuthResult.success(null);
  }

  AuthResult _validateRegistrationData(
    String email,
    String password,
    String firstName,
    String lastName,
  ) {
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      return AuthResult.failure('All fields are required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return AuthResult.failure('Please enter a valid email address');
    }

    if (firstName.length < 2) {
      return AuthResult.failure('First name must be at least 2 characters');
    }

    if (lastName.length < 2) {
      return AuthResult.failure('Last name must be at least 2 characters');
    }

    return AuthResult.success(null);
  }

  /// Utility methods
  Future<void> _generateSessionToken(String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final tokenData = '$userId:$timestamp';
      final bytes = utf8.encode(tokenData);
      final token = sha256.convert(bytes).toString();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionTokenKey, token);
    } catch (e) {
      if (kDebugMode) {
        print('Error generating session token: $e');
      }
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'hostname': Platform.localHostname,
    };
  }

  Future<void> _logSecurityEvent(
      String event, Map<String, dynamic> data) async {
    try {
      // Use updateDocument to create a security log entry
      await _firestoreService.updateDocument(
        collection: 'security_logs',
        documentId: '${DateTime.now().millisecondsSinceEpoch}',
        data: {
          'event': event,
          'timestamp': DateTime.now().toIso8601String(),
          ...data,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error logging security event: $e');
      }
    }
  }

  Future<void> _createUserProfile(
      User user, Map<String, dynamic> userData) async {
    try {
      await _firestoreService.createUserProfile(
        userId: user.uid,
        userData: {
          ...userData,
          'email': user.email,
          'uid': user.uid,
          'createdAt': DateTime.now().toIso8601String(),
          'lastLoginAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user profile: $e');
      }
    }
  }

  Future<void> _updateUserSecurityInfo(User user) async {
    try {
      await _firestoreService.updateDocument(
        collection: 'users',
        documentId: user.uid,
        data: {
          'lastLoginAt': DateTime.now().toIso8601String(),
          'lastLoginIP': await _getCurrentIP(),
          'deviceInfo': await _getDeviceInfo(),
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user security info: $e');
      }
    }
  }

  Future<void> _updateUserSecuritySetting(String setting, dynamic value) async {
    try {
      if (currentUser != null) {
        await _firestoreService.updateDocument(
          collection: 'users',
          documentId: currentUser!.uid,
          data: {
            'securitySettings.$setting': value,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user security setting: $e');
      }
    }
  }

  Future<String> _getCurrentIP() async {
    // In a real implementation, you would get the actual IP
    return 'unknown';
  }

  /// Password reset with enhanced security
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult.failure('Please enter a valid email address');
      }

      await _auth.sendPasswordResetEmail(email: email);

      await _logSecurityEvent('password_reset_requested', {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  /// Enhanced sign out with cleanup
  Future<void> signOut({String? reason}) async {
    try {
      final userId = currentUser?.uid;

      await _auth.signOut();

      // Clear local session data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_lastActivityKey);

      // Log sign out event
      if (userId != null) {
        await _logSecurityEvent('user_signed_out', {
          'user_id': userId,
          'reason': reason ?? 'manual',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }

  /// Error message mapping
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'invalid-credential':
        return 'Invalid login credentials';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

/// Enhanced authentication result with detailed information
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.metadata,
  });

  factory AuthResult.success(User? user, {Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      metadata: metadata,
    );
  }

  factory AuthResult.failure(String errorMessage,
      {Map<String, dynamic>? metadata}) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: errorMessage,
      metadata: metadata,
    );
  }
}

/// Password strength assessment
class PasswordStrength {
  final int score; // 0-5 scale
  final List<String> feedback;

  PasswordStrength({required this.score, required this.feedback});

  String get level {
    switch (score) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (score) {
      case 0:
      case 1:
        return const Color(0xFFE53E3E); // Red
      case 2:
        return const Color(0xFFDD6B20); // Orange
      case 3:
        return const Color(0xFFD69E2E); // Yellow
      case 4:
        return const Color(0xFF38A169); // Green
      case 5:
        return const Color(0xFF0F7B0F); // Dark Green
      default:
        return const Color(0xFF718096); // Gray
    }
  }
}

/// Biometric authentication status
enum BiometricStatus {
  notAvailable,
  notEnrolled,
  available,
  fingerprint,
  face,
  error,
}
