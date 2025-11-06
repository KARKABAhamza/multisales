import 'package:flutter/foundation.dart';

/// Simple error handler for MultiSales app
/// Handles and logs application errors globally
class ErrorHandler {
  static bool _isInitialized = false;
  static final List<AppError> _errorLog = [];

  /// Initialize error handling
  static void initialize() {
    if (_isInitialized) return;

    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      logError('Flutter Error', details.exception, details.stack);

      // In debug mode, show the error
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    _isInitialized = true;
  }

  /// Log an error
  static void logError(String message, dynamic error,
      [StackTrace? stackTrace]) {
    final appError = AppError(
      message: message,
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    _errorLog.add(appError);

    // Keep only last 100 errors
    if (_errorLog.length > 100) {
      _errorLog.removeAt(0);
    }

    // Print to console in debug mode
    if (kDebugMode) {
      print('ERROR: $message');
      print('Details: $error');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }

    // Crash reporting service integration pending for production
    // Will integrate with Firebase Crashlytics or similar service
    // Currently using local logging for development and testing
  }

  /// Get error log
  static List<AppError> get errorLog => List.unmodifiable(_errorLog);

  /// Clear error log
  static void clearErrorLog() {
    _errorLog.clear();
  }

  /// Handle and log exception
  static T? handleException<T>(String context, T Function() operation) {
    try {
      return operation();
    } catch (e, stackTrace) {
      logError('Exception in $context', e, stackTrace);
      return null;
    }
  }

  /// Handle and log async exception
  static Future<T?> handleAsyncException<T>(
      String context, Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      logError('Async exception in $context', e, stackTrace);
      return null;
    }
  }
}

/// Application error model
class AppError {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppError({
    required this.message,
    required this.error,
    this.stackTrace,
    required this.timestamp,
  });

  String get formattedMessage => '$message: $error';

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
