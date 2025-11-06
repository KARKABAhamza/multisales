// lib/core/models/auth_result.dart
import 'package:firebase_auth/firebase_auth.dart';

/// Result wrapper for authentication operations
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;
  final AuthErrorCode? errorCode;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.errorCode,
  });

  factory AuthResult.success(User user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.failure(String errorMessage, [AuthErrorCode? errorCode]) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }

  /// Check if error is recoverable
  bool get isRecoverableError {
    if (errorCode == null) return false;

    switch (errorCode!) {
      case AuthErrorCode.networkRequestFailed:
      case AuthErrorCode.tooManyRequests:
        return true;
      default:
        return false;
    }
  }

  /// Get retry delay for recoverable errors
  Duration? get retryDelay {
    if (!isRecoverableError) return null;

    switch (errorCode!) {
      case AuthErrorCode.networkRequestFailed:
        return const Duration(seconds: 2);
      case AuthErrorCode.tooManyRequests:
        return const Duration(minutes: 1);
      default:
        return null;
    }
  }
}

/// Enhanced error codes for better error handling
enum AuthErrorCode {
  userNotFound,
  wrongPassword,
  userDisabled,
  tooManyRequests,
  operationNotAllowed,
  invalidEmail,
  weakPassword,
  emailAlreadyInUse,
  networkRequestFailed,
  unknown,
}

/// Convert Firebase Auth exception codes to AuthErrorCode
AuthErrorCode authErrorCodeFromString(String code) {
  switch (code) {
    case 'user-not-found':
      return AuthErrorCode.userNotFound;
    case 'wrong-password':
      return AuthErrorCode.wrongPassword;
    case 'user-disabled':
      return AuthErrorCode.userDisabled;
    case 'too-many-requests':
      return AuthErrorCode.tooManyRequests;
    case 'operation-not-allowed':
      return AuthErrorCode.operationNotAllowed;
    case 'invalid-email':
      return AuthErrorCode.invalidEmail;
    case 'weak-password':
      return AuthErrorCode.weakPassword;
    case 'email-already-in-use':
      return AuthErrorCode.emailAlreadyInUse;
    case 'network-request-failed':
      return AuthErrorCode.networkRequestFailed;
    default:
      return AuthErrorCode.unknown;
  }
}
