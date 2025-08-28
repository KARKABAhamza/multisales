import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import 'firestore_service.dart';
import 'analytics_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final AnalyticsService _analyticsService = AnalyticsService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Suivre l'événement de connexion
      await _analyticsService.logLogin(method: 'email');

      return AuthResult.success(result.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Register with email and password
  Future<AuthResult> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult.success(result.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error registering: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Enhanced sign up with user profile creation
  Future<AuthResult> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      // Create Firebase Auth account
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user != null) {
        // Update display name in Firebase Auth
        String displayName = '';
        if (firstName != null && lastName != null) {
          displayName = '$firstName $lastName';
        } else if (firstName != null) {
          displayName = firstName;
        }

        if (displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
        }

        // Create user profile in Firestore
        await _firestoreService.createUserProfile(
          userId: user.uid,
          userData: {
            'email': email,
            'firstName': firstName ?? '',
            'lastName': lastName ?? '',
            'displayName': displayName,
            'phoneNumber': phoneNumber ?? '',
            'role': 'user', // Default role
            'createdAt': DateTime.now(),
            'isOnboardingComplete': false,
            'profileImageUrl': '',
          },
        );

        // Suivre l'événement d'inscription et définir les propriétés utilisateur
        await _analyticsService.logSignUp(method: 'email');
        await _analyticsService.setUserProperties(
          userId: user.uid,
          userRole: 'user',
        );

        await user.reload();
        return AuthResult.success(user);
      }

      return AuthResult.failure('Account creation failed');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error in enhanced sign up: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error sending password reset: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Alias for resetPassword (for backward compatibility)
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update user display name
  Future<AuthResult> updateDisplayName(String displayName) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.reload();
      return AuthResult.success(currentUser);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating display name: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Update user email
  Future<AuthResult> updateEmail(String newEmail) async {
    try {
      // ignore: deprecated_member_use
      await currentUser?.updateEmail(newEmail);
      await currentUser?.reload();
      return AuthResult.success(currentUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error updating email: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Update password
  Future<AuthResult> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
      return AuthResult.success(currentUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error updating password: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }

  // Delete user account
  Future<AuthResult> deleteUser() async {
    try {
      await currentUser?.delete();
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      return AuthResult.failure(AppMessages.errorGeneral);
    }
  }

  // Private helper method to get user-friendly error messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return AppMessages.errorUserNotFound;
      case 'wrong-password':
        return AppMessages.errorWrongPassword;
      case 'weak-password':
        return AppMessages.errorWeakPassword;
      case 'email-already-in-use':
        return AppMessages.errorEmailInUse;
      case 'invalid-email':
        return AppMessages.errorInvalidEmail;
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'requires-recent-login':
        return 'Please log out and log back in to perform this action.';
      default:
        return AppMessages.errorAuthFailed;
    }
  }
}

// Result wrapper class for authentication operations
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(User? user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}
