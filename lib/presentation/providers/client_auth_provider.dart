import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../data/models/user_model.dart';
import '../../core/constants/app_constants.dart';

/// Client Authentication Provider for MultiSales App
/// Handles user authentication, registration, and profile management
class ClientAuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _clientProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get clientProfile => _clientProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isProfileComplete => _clientProfile?.isOnboardingComplete ?? false;

  ClientAuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        _loadClientProfile(user.uid);
      } else {
        _clientProfile = null;
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

  // Load client profile from Firestore
  Future<void> _loadClientProfile(String uid) async {
    try {
      final result = await _firestoreService.getUser(uid);
      if (result.isSuccess) {
        _clientProfile = result.data;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading client profile: $e');
      }
    }
    notifyListeners();
  }

  // Client Sign In
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final result =
          await _authService.signInWithEmailAndPassword(email, password);

      if (result.isSuccess) {
        _setLoading(false);
        return true;
      } else {
        _setError(result.errorMessage ?? 'Failed to sign in');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(AppMessages.errorGeneral);
      _setLoading(false);
      return false;
    }
  }

  // Client Registration
  Future<bool> registerClient({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? company,
    String? address,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result =
          await _authService.registerWithEmailAndPassword(email, password);

      if (result.isSuccess && result.user != null) {
        // Create client profile in Firestore
        final clientProfile = UserModel(
          id: result.user!.uid,
          email: result.user!.email!,
          firstName: firstName,
          lastName: lastName,
          phone: phoneNumber,
          role: 'client', // Client role
          accountType: 'basic',
          createdAt: DateTime.now(),
          isOnboardingComplete: false,
          address: address,
          city: company, // Using company as city for now
          preferences: {
            'clientType': 'individual', // or 'business'
            'serviceStatus': 'active',
            'subscriptions': [],
          },
        );

        final createResult = await _firestoreService.createUser(clientProfile);
        if (createResult.isSuccess) {
          _clientProfile = clientProfile;
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

  // Update Client Profile
  Future<bool> updateClientProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? company,
    String? address,
    String? profileImageUrl,
  }) async {
    if (_firebaseUser == null || _clientProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      Map<String, dynamic> updateData = {
        'updatedAt': Timestamp.now(),
      };

      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (company != null) updateData['department'] = company;
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      if (address != null) {
        updateData['customFields.address'] = address;
      }

      final result = await _firestoreService.updateUserData(
          _firebaseUser!.uid, updateData);

      if (result['success'] == true) {
        // Update local profile
        _clientProfile = _clientProfile!.copyWith(
          firstName: firstName ?? _clientProfile!.firstName,
          lastName: lastName ?? _clientProfile!.lastName,
          phone: phoneNumber ?? _clientProfile!.phone,
          profileImageUrl: profileImageUrl ?? _clientProfile!.profileImageUrl,
        );
        _setLoading(false);
        return true;
      } else {
        _setError(result['error'] as String? ?? 'Failed to update profile');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(AppMessages.errorGeneral);
      _setLoading(false);
      return false;
    }
  }

  // Complete Profile Setup
  Future<bool> completeProfileSetup() async {
    if (_firebaseUser == null || _clientProfile == null) return false;

    _setLoading(true);
    _setError(null);

    try {
      final result = await _firestoreService.updateUserData(
        _firebaseUser!.uid,
        {
          'isOnboardingComplete': true,
        },
      );

      if (result['success'] == true) {
        _clientProfile = _clientProfile!.copyWith(
          isOnboardingComplete: true,
        );
        _setLoading(false);
        return true;
      } else {
        _setError(result['error'] ?? 'Failed to complete onboarding');
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
        _setError(result.errorMessage ?? 'Failed to send password reset email');
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
      _clientProfile = null;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
    _setLoading(false);
  }
}
