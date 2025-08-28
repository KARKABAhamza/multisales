import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/enhanced_auth_service.dart';
import '../services/firestore_service.dart';
import '../../data/models/user_model.dart';
import '../constants/app_constants.dart';

/// Enhanced Authentication Provider with comprehensive security features
class EnhancedAuthProvider with ChangeNotifier {
  final EnhancedAuthService _authService = EnhancedAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Authentication state
  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  // Security state
  bool _isBiometricEnabled = false;
  BiometricStatus _biometricStatus = BiometricStatus.notAvailable;
  bool _isSessionActive = false;
  DateTime? _lastActivity;

  // Security preferences
  bool _biometricOnlyMode = false;
  int _sessionTimeoutMinutes = 30;
  List<SessionInfo> _activeSessions = [];

  // Password validation
  PasswordStrength? _passwordStrength;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  UserModel? get user => _userModel; // Alias for userModel
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null && _isSessionActive;
  bool get hasCompletedOnboarding => _userModel?.isOnboardingComplete ?? false;

  // Security getters
  bool get isBiometricEnabled => _isBiometricEnabled;
  BiometricStatus get biometricStatus => _biometricStatus;
  bool get isSessionActive => _isSessionActive;
  DateTime? get lastActivity => _lastActivity;
  PasswordStrength? get passwordStrength => _passwordStrength;

  // Security preferences getters
  bool get biometricOnlyMode => _biometricOnlyMode;
  int get sessionTimeoutMinutes => _sessionTimeoutMinutes;
  List<SessionInfo> get activeSessions => List.unmodifiable(_activeSessions);

  // Security score calculation
  int get securityScore {
    double score = 0.0;

    if (_firebaseUser?.emailVerified == true) score += 20;
    if (_isBiometricEnabled) score += 30;
    if (_userModel?.isPhoneVerified == true) score += 20;
    if (_passwordStrength != null && _passwordStrength!.score >= 4) score += 30;

    return score.round().clamp(0, 100);
  }

  // Security recommendations
  List<String> get securityRecommendations {
    final recommendations = <String>[];

    if (_firebaseUser?.emailVerified != true) {
      recommendations.add('Verify your email address for enhanced security');
    }

    if (!_isBiometricEnabled &&
        _biometricStatus != BiometricStatus.notAvailable) {
      recommendations.add('Enable biometric authentication for quick access');
    }

    if (_passwordStrength != null && _passwordStrength!.score < 4) {
      recommendations.add('Use a stronger password with mixed characters');
    }

    if (_userModel?.isPhoneVerified != true) {
      recommendations.add('Add and verify your phone number for 2FA');
    }

    return recommendations;
  }

  EnhancedAuthProvider() {
    _initialize();
  }

  /// Initialize the provider
  Future<void> _initialize() async {
    await _authService.initialize();
    await _checkBiometricCapability();
    await _loadBiometricSettings();

    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _firebaseUser = user;
      _isSessionActive = user != null;

      if (user != null) {
        _loadUserModel(user.uid);
        _updateLastActivity();
      } else {
        _userModel = null;
        _isSessionActive = false;
      }
      notifyListeners();
    });
  }

  /// State management helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _updateLastActivity() {
    _lastActivity = DateTime.now();
    notifyListeners();
  }

  /// Load user model from Firestore
  Future<void> _loadUserModel(String uid) async {
    try {
      final result = await _firestoreService.getUser(uid);
      if (result.isSuccess) {
        _userModel = result.data;
        await _loadSecurityPreferences();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user model: $e');
      }
    }
    notifyListeners();
  }

  /// Enhanced sign in with security options
  Future<bool> signIn(
    String email,
    String password, {
    bool requireBiometric = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.signInWithEmailAndPassword(
        email,
        password,
        requireBiometric: requireBiometric,
      );

      if (result.isSuccess) {
        _isSessionActive = true;
        _updateLastActivity();
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(AppMessages.errorGeneral);
      _setLoading(false);
      return false;
    }
  }

  /// Biometric sign in
  Future<bool> signInWithBiometrics() async {
    if (!_isBiometricEnabled ||
        _biometricStatus == BiometricStatus.notAvailable) {
      _setError('Biometric authentication is not available');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.authenticateWithBiometrics();

      if (result.isSuccess) {
        _isSessionActive = true;
        _updateLastActivity();
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage ?? 'Biometric authentication failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Biometric authentication error');
      _setLoading(false);
      return false;
    }
  }

  /// Enhanced registration
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String role = 'client',
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Validate password strength first
      _passwordStrength = _validatePasswordStrength(password);
      notifyListeners();

      final result = await _authService.registerWithEmailAndPassword(
        email,
        password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        role: role,
      );

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(AppMessages.errorGeneral);
      _setLoading(false);
      return false;
    }
  }

  /// Validate password strength
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

  /// Password validation for forms
  void validatePassword(String password) {
    _passwordStrength = _validatePasswordStrength(password);
    notifyListeners();
  }

  /// Biometric authentication methods
  Future<void> _checkBiometricCapability() async {
    _biometricStatus = await _authService.checkBiometricAvailability();
    notifyListeners();
  }

  Future<void> _loadBiometricSettings() async {
    _isBiometricEnabled = await _authService.isBiometricEnabled();
    notifyListeners();
  }

  Future<bool> enableBiometric() async {
    if (_biometricStatus == BiometricStatus.notAvailable) {
      _setError('Biometric authentication is not available on this device');
      return false;
    }

    if (_biometricStatus == BiometricStatus.notEnrolled) {
      _setError(
          'Please enroll biometric authentication in device settings first');
      return false;
    }

    _setLoading(true);

    try {
      // Test biometric authentication first
      final authResult = await _authService.authenticateWithBiometrics();
      if (!authResult.isSuccess) {
        _setError(authResult.errorMessage ?? 'Biometric authentication failed');
        _setLoading(false);
        return false;
      }

      // Enable biometric in settings
      final success = await _authService.setBiometricEnabled(true);
      if (success) {
        _isBiometricEnabled = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to enable biometric authentication');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error enabling biometric authentication');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> disableBiometric() async {
    _setLoading(true);

    try {
      final success = await _authService.setBiometricEnabled(false);
      if (success) {
        _isBiometricEnabled = false;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to disable biometric authentication');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error disabling biometric authentication');
      _setLoading(false);
      return false;
    }
  }

  /// Password reset
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.sendPasswordResetEmail(email);

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(AppMessages.errorGeneral);
      _setLoading(false);
      return false;
    }
  }

  /// Session management
  Future<void> refreshSession() async {
    if (_firebaseUser != null) {
      await _firebaseUser!.reload();
      _updateLastActivity();
    }
  }

  Future<void> extendSession() async {
    _updateLastActivity();
  }

  /// Account security actions
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    if (_firebaseUser == null) {
      _setError('User not authenticated');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Validate new password strength
      final strength = _validatePasswordStrength(newPassword);
      if (strength.score < 3) {
        _setError('New password is too weak. ${strength.feedback.join(' ')}');
        _setLoading(false);
        return false;
      }

      // Re-authenticate with current password
      final credential = EmailAuthProvider.credential(
        email: _firebaseUser!.email!,
        password: currentPassword,
      );

      await _firebaseUser!.reauthenticateWithCredential(credential);

      // Update password
      await _firebaseUser!.updatePassword(newPassword);

      // Update password strength in user profile
      await _firestoreService.updateDocument(
        collection: 'users',
        documentId: _firebaseUser!.uid,
        data: {
          'securitySettings.lastPasswordChange':
              DateTime.now().toIso8601String(),
          'securitySettings.passwordStrength': strength.score,
        },
      );

      _passwordStrength = strength;
      _setLoading(false);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _setError('Current password is incorrect');
      } else {
        _setError('Failed to change password: ${e.message}');
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Error changing password');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    if (_firebaseUser == null) {
      _setError('User not authenticated');
      return false;
    }

    if (_firebaseUser!.emailVerified) {
      _setError('Email is already verified');
      return false;
    }

    _setLoading(true);

    try {
      await _firebaseUser!.sendEmailVerification();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to send verification email');
      _setLoading(false);
      return false;
    }
  }

  Future<void> checkEmailVerification() async {
    if (_firebaseUser != null) {
      await _firebaseUser!.reload();
      _firebaseUser = _authService.currentUser;

      if (_userModel != null && _firebaseUser!.emailVerified) {
        // Update user model if email becomes verified
        await _firestoreService.updateDocument(
          collection: 'users',
          documentId: _firebaseUser!.uid,
          data: {
            'isEmailVerified': true,
          },
        );
        _userModel = _userModel!.copyWith(isEmailVerified: true);
      }
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    if (_firebaseUser == null) {
      _setError('User not authenticated');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      final result = await _firestoreService.updateUser(updatedUser);

      if (result.isSuccess) {
        _userModel = result.data;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result.errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to update profile');
      _setLoading(false);
      return false;
    }
  }

  /// Enhanced sign out with cleanup
  Future<void> signOut({String? reason}) async {
    _setLoading(true);

    try {
      await _authService.signOut(reason: reason);

      // Reset all state
      _firebaseUser = null;
      _userModel = null;
      _isSessionActive = false;
      _lastActivity = null;
      _passwordStrength = null;

      _setLoading(false);
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      _setLoading(false);
    }
  }

  /// Account deletion with confirmation
  Future<bool> deleteAccount(String password) async {
    if (_firebaseUser == null) {
      _setError('User not authenticated');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Re-authenticate before deletion
      final credential = EmailAuthProvider.credential(
        email: _firebaseUser!.email!,
        password: password,
      );

      await _firebaseUser!.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await _firestoreService.deleteDocument(
        collection: 'users',
        documentId: _firebaseUser!.uid,
      );

      // Delete Firebase Auth account
      await _firebaseUser!.delete();

      // Reset state
      _firebaseUser = null;
      _userModel = null;
      _isSessionActive = false;
      _isBiometricEnabled = false;

      _setLoading(false);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _setError('Password is incorrect');
      } else {
        _setError('Failed to delete account: ${e.message}');
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Error deleting account');
      _setLoading(false);
      return false;
    }
  }

  /// Security recommendations
  List<SecurityRecommendation> getSecurityRecommendations() {
    final recommendations = <SecurityRecommendation>[];

    if (_firebaseUser?.emailVerified != true) {
      recommendations.add(SecurityRecommendation(
        title: 'Verify your email address',
        description:
            'Email verification adds an extra layer of security to your account.',
        priority: SecurityPriority.high,
        action: 'Verify Email',
      ));
    }

    if (!_isBiometricEnabled &&
        _biometricStatus != BiometricStatus.notAvailable) {
      recommendations.add(SecurityRecommendation(
        title: 'Enable biometric authentication',
        description: 'Use fingerprint or face ID for quick and secure access.',
        priority: SecurityPriority.medium,
        action: 'Enable Biometric',
      ));
    }

    if (_passwordStrength != null && _passwordStrength!.score < 4) {
      recommendations.add(SecurityRecommendation(
        title: 'Strengthen your password',
        description:
            'Use a stronger password with mix of characters, numbers, and symbols.',
        priority: SecurityPriority.high,
        action: 'Change Password',
      ));
    }

    if (_userModel?.isPhoneVerified != true) {
      recommendations.add(SecurityRecommendation(
        title: 'Add phone number verification',
        description:
            'Phone verification helps secure your account and enables SMS recovery.',
        priority: SecurityPriority.low,
        action: 'Add Phone',
      ));
    }

    return recommendations;
  }

  /// Set biometric-only mode
  Future<void> setBiometricOnlyMode(bool enabled) async {
    _biometricOnlyMode = enabled;
    await _saveSecurityPreferences();
    notifyListeners();
  }

  /// Set session timeout
  Future<void> setSessionTimeout(int minutes) async {
    _sessionTimeoutMinutes = minutes;
    await _saveSecurityPreferences();
    notifyListeners();
  }

  /// Get active sessions
  Future<void> loadActiveSessions() async {
    // Simulate loading active sessions
    _activeSessions = [
      SessionInfo(
        id: 'current',
        deviceName: 'Current Device',
        location: 'Current Location',
        lastActivity: DateTime.now(),
        isCurrent: true,
      ),
    ];
    notifyListeners();
  }

  /// Sign out from other devices
  Future<bool> signOutOtherDevices() async {
    try {
      _setLoading(true);

      // Remove all non-current sessions
      _activeSessions.removeWhere((session) => !session.isCurrent);

      // In a real implementation, this would call Firebase Auth to revoke other sessions
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign out other devices');
      _setLoading(false);
      return false;
    }
  }

  /// Add phone number
  Future<bool> addPhoneNumber(String phoneNumber) async {
    try {
      _setLoading(true);

      // In a real implementation, this would verify the phone number
      if (_userModel != null) {
        final updatedUser = _userModel!.copyWith(
          phone: phoneNumber,
          isPhoneVerified: false, // Would be verified through SMS
        );

        await _firestoreService.updateDocument(
          collection: 'users',
          documentId: _userModel!.id,
          data: updatedUser.toJson(),
        );

        _userModel = updatedUser;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add phone number');
      _setLoading(false);
      return false;
    }
  }

  /// Save security preferences
  Future<void> _saveSecurityPreferences() async {
    if (_userModel != null) {
      final preferences = {
        'biometricOnlyMode': _biometricOnlyMode,
        'sessionTimeoutMinutes': _sessionTimeoutMinutes,
      };

      final updatedUser = _userModel!.copyWith(preferences: preferences);

      await _firestoreService.updateDocument(
        collection: 'users',
        documentId: _userModel!.id,
        data: updatedUser.toJson(),
      );

      _userModel = updatedUser;
    }
  }

  /// Load security preferences
  Future<void> _loadSecurityPreferences() async {
    if (_userModel?.preferences != null) {
      _biometricOnlyMode =
          _userModel!.preferences!['biometricOnlyMode'] ?? false;
      _sessionTimeoutMinutes =
          _userModel!.preferences!['sessionTimeoutMinutes'] ?? 30;
    }
  }
}

/// Session information model
class SessionInfo {
  final String id;
  final String deviceName;
  final String location;
  final DateTime lastActivity;
  final bool isCurrent;

  SessionInfo({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActivity,
    required this.isCurrent,
  });
}

/// Security recommendation model
class SecurityRecommendation {
  final String title;
  final String description;
  final SecurityPriority priority;
  final String action;

  SecurityRecommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.action,
  });
}

enum SecurityPriority { low, medium, high }
