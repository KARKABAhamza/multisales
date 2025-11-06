import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';

/// A thin wrapper around Firebase Cloud Messaging (FCM)
/// to manage permissions, tokens, and foreground message handling.
class MessagingService {
  MessagingService();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Requests notification permission from the user.
  /// Returns the [NotificationSettings] describing the authorization status.
  Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    return settings;
  }

  /// Retrieves the FCM registration token.
  /// For Web, supply a [webVapidKey]. For mobile/desktop, leave null.
  Future<String?> getToken({String? webVapidKey}) async {
    if (kIsWeb) {
      return _messaging.getToken(vapidKey: webVapidKey);
    }
    return _messaging.getToken();
  }

  /// Listen to foreground messages.
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Listen to token refresh events.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Optional topic subscription helpers.
  Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);
  Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
}
