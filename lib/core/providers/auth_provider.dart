import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../../data/models/user_model.dart';
import '../constants/app_constants.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get hasCompletedOnboarding => _userModel?.isOnboardingComplete ?? false;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        _loadUserModel(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

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

  // Load user model from Firestore
  Future<void> _loadUserModel(String uid) async {
    try {
      final result = await _firestoreService.getUser(uid);
      if (result.isSuccess) {
        _userModel = result.data;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user model: $e');
      }
    }
    notifyListeners();
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.signInWithEmailAndPassword(
        email,
        password,
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

  // Register
  Future<bool> register(String email, String password, String role) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await _authService.registerWithEmailAndPassword(
        email,
        password,
      );

      if (result.isSuccess && result.user != null) {
        // Create user model in Firestore
        final userModel = UserModel.fromFirebaseUser(
          uid: result.user!.uid,
          email: result.user!.email!,
          displayName: result.user!.displayName,
          role: role,
        );

        final createResult = await _firestoreService.createUser(userModel);
        if (createResult.isSuccess) {
          _userModel = userModel;
          _setLoading(false);
          return true;
        } else {
          _setError(createResult.errorMessage);
          _setLoading(false);
          return false;
        }
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

  // Send password reset email
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

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _userModel = null;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
    _setLoading(false);
  }
}
