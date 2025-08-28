// lib/core/providers/optimized_auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/optimized_auth_service.dart';
import '../services/performance_monitor.dart';
import '../../data/models/user_model.dart';

/// Optimized Authentication Provider with Performance Enhancements
class OptimizedAuthProvider with ChangeNotifier {
  final OptimizedAuthService _authService = OptimizedAuthService();

  // Authentication state
  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  // Performance tracking
  final Map<String, DateTime> _operationTimestamps = {};

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;

  /// Initialize the provider
  Future<void> initialize() async {
    await _authService.initialize();

    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _firebaseUser = user;
      if (user == null) {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  /// Optimized sign-in with performance tracking
  Future<bool> signIn(String email, String password) async {
    return await PerformanceMonitor.trackAuthFlow(
      'sign_in',
      () => _performSignIn(email, password),
      customAttributes: {
        'email_domain': email.split('@').last,
        'has_cached_profile': _userModel != null,
      },
    );
  }

  /// Internal sign-in implementation
  Future<bool> _performSignIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final result =
          await _authService.signInWithEmailAndPassword(email, password);

      if (result.isSuccess && result.user != null) {
        _firebaseUser = result.user;

        // Load user profile in background
        _loadUserProfileInBackground(result.user!.uid);

        // Track successful sign-in
        await PerformanceMonitor.trackUserExperience(
          screen: 'sign_in',
          loadTimeMs: _getOperationDuration('sign_in'),
          successful: true,
        );

        return true;
      } else {
        _setError(result.errorMessage ?? 'Sign-in failed');

        // Track failed sign-in
        await PerformanceMonitor.trackUserExperience(
          screen: 'sign_in',
          loadTimeMs: _getOperationDuration('sign_in'),
          successful: false,
          context: {'error': result.errorMessage},
        );

        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Load user profile in background
  Future<void> _loadUserProfileInBackground(String userId) async {
    try {
      final profileData = await _authService.getUserProfile(userId);

      if (profileData != null) {
        _userModel = UserModel.fromJson(profileData);
        notifyListeners();

        // Track memory usage after profile load
        await PerformanceMonitor.trackMemoryUsage('profile_loaded');
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  /// Optimized registration
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? role,
  }) async {
    return await PerformanceMonitor.trackAuthFlow(
      'register',
      () => _performRegistration(email, password, firstName, lastName, role),
    );
  }

  /// Internal registration implementation
  Future<bool> _performRegistration(
    String email,
    String password,
    String firstName,
    String lastName,
    String? role,
  ) async {
    _setLoading(true);
    _setError(null);

    try {
      // Track registration phases
      await PerformanceMonitor.trackAuthPhases(
        validation: () async {
          // Validate inputs
          if (email.isEmpty || password.isEmpty) {
            throw Exception('Email and password are required');
          }
        },
        authentication: () async {
          // Create Firebase user
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          _firebaseUser = credential.user;
        },
        profileLoad: () async {
          // Create user profile
          if (_firebaseUser != null) {
            final userData = {
              'id': _firebaseUser!.uid,
              'email': email,
              'firstName': firstName,
              'lastName': lastName,
              'role': role ?? 'user',
              'createdAt': DateTime.now().toIso8601String(),
              'isOnboardingComplete': false,
            };

            _userModel = UserModel.fromJson(userData);
          }
        },
        securityChecks: () async {
          // Send verification email
          if (_firebaseUser != null) {
            await _firebaseUser!.sendEmailVerification();
          }
        },
      );

      return true;
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Fast sign-out with cleanup
  Future<void> signOut() async {
    await PerformanceMonitor.trackAuthFlow(
      'sign_out',
      () async {
        await FirebaseAuth.instance.signOut();

        // Clear local state
        _firebaseUser = null;
        _userModel = null;
        _setError(null);

        // Clear performance data
        _operationTimestamps.clear();
      },
    );
  }

  /// Reset password with tracking
  Future<bool> resetPassword(String email) async {
    return await PerformanceMonitor.trackAuthFlow(
      'reset_password',
      () async {
        _setLoading(true);
        _setError(null);

        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          return true;
        } catch (e) {
          _setError('Failed to send reset email: ${e.toString()}');
          return false;
        } finally {
          _setLoading(false);
        }
      },
    );
  }

  /// Get performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'operation_timestamps': Map.from(_operationTimestamps),
      'current_state': {
        'is_authenticated': isAuthenticated,
        'is_loading': isLoading,
        'has_error': errorMessage != null,
        'user_loaded': _userModel != null,
      },
      'firebase_performance': PerformanceMonitor.getPerformanceSummary(),
    };
  }

  /// Track operation start time
  void _startOperation(String operation) {
    _operationTimestamps[operation] = DateTime.now();
  }

  /// Get operation duration
  int _getOperationDuration(String operation) {
    final startTime = _operationTimestamps[operation];
    if (startTime != null) {
      return DateTime.now().difference(startTime).inMilliseconds;
    }
    return 0;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    if (loading) {
      _startOperation('current');
    }
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _setError(null);
  }

  /// Check if operation is in progress
  bool isOperationInProgress(String operation) {
    return _operationTimestamps.containsKey(operation);
  }

  /// Prefetch user data for better UX
  Future<void> prefetchUserData() async {
    if (_firebaseUser != null && _userModel == null) {
      await _loadUserProfileInBackground(_firebaseUser!.uid);
    }
  }

  /// Optimize memory usage
  void optimizeMemory() {
    // Clear old operation timestamps
    final now = DateTime.now();
    _operationTimestamps.removeWhere((key, timestamp) =>
        now.difference(timestamp) > const Duration(hours: 1));

    // Clear performance cache
    PerformanceMonitor.clearPerformanceData();

    notifyListeners();
  }

  @override
  void dispose() {
    _authService.dispose();
    _operationTimestamps.clear();
    super.dispose();
  }
}
