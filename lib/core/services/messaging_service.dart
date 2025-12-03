import 'dart:async';

/// A thin wrapper around Firebase Cloud Messaging (FCM)
/// to manage permissions, tokens, and foreground message handling.
class MessagingService {
  MessagingService();
  // Messaging is currently disabled (firebase_messaging not included).
  // Provide no-op implementations to keep the app compiling.

  /// Requests notification permission from the user.
  /// Returns the [NotificationSettings] describing the authorization status.
  Future<Map<String, dynamic>> requestPermission() async {
    // Return a minimal permission structure compatible with provider checks.
    return {
      'authorizationStatus': 'authorized',
    };
  }

  /// Retrieves the FCM registration token.
  /// For Web, supply a [webVapidKey]. For mobile/desktop, leave null.
  Future<String?> getToken({String? webVapidKey}) async {
    // No real token without firebase_messaging; return null for now.
    return null;
  }

  /// Listen to foreground messages.
  Stream<Map<String, dynamic>> get onMessage => const Stream.empty();

  /// Listen to token refresh events.
  Stream<String> get onTokenRefresh => const Stream.empty();

  /// Optional topic subscription helpers.
  Future<void> subscribeToTopic(String topic) async {}
  Future<void> unsubscribeFromTopic(String topic) async {}
}
