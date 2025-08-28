import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Comprehensive notification service for MultiSales app
/// Handles Firebase push notifications and system notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isInitialized = false;
  String? _fcmToken;

  // Notification callbacks
  Function(String)? onTokenRefresh;
  Function(RemoteMessage)? onMessageReceived;
  Function(RemoteMessage)? onMessageOpened;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request notification permissions
      final NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('✅ Notification permissions granted');
        }

        // Get FCM token
        _fcmToken = await _firebaseMessaging.getToken();
        if (kDebugMode) {
          print('📱 FCM Token: $_fcmToken');
        }

        // Configure Firebase Messaging
        await _configureFirebaseMessaging();

        // Subscribe to default topic
        await _firebaseMessaging.subscribeToTopic('multisales_all');

        _isInitialized = true;
        if (kDebugMode) {
          print('🔔 NotificationService initialized successfully');
        }
      } else {
        if (kDebugMode) {
          print('❌ Notification permissions denied');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize NotificationService: $e');
      }
    }
  }

  /// Configure Firebase Messaging handlers
  Future<void> _configureFirebaseMessaging() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📩 Foreground message received: ${message.notification?.title}');
      }
      onMessageReceived?.call(message);
      _showInAppNotification(message);
    });

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print(
            '🔍 Message opened from background: ${message.notification?.title}');
      }
      onMessageOpened?.call(message);
    });

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      _fcmToken = token;
      if (kDebugMode) {
        print('🔄 FCM Token refreshed: $token');
      }
      onTokenRefresh?.call(token);
    });

    // Check if app was opened from terminated state
    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print('🚀 App opened from terminated state via notification');
      }
      onMessageOpened?.call(initialMessage);
    }
  }

  /// Show in-app notification (simple implementation)
  void _showInAppNotification(RemoteMessage message) {
    // This would typically show a banner/snackbar in the UI
    // For now, we'll just log it
    if (kDebugMode) {
      print(
          '🔔 In-app notification: ${message.notification?.title} - ${message.notification?.body}');
    }
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Get current FCM token
  String? get fcmToken => _fcmToken;

  /// Send local notification (system notification)
  Future<void> showLocalNotification({
    required String title,
    required String message,
    String? payload,
  }) async {
    if (!_isInitialized) {
      if (kDebugMode) {
        print('⚠️ NotificationService not initialized');
      }
      return;
    }

    // For web/desktop, we can use browser notifications
    // For mobile, this would require flutter_local_notifications package
    if (kDebugMode) {
      print('🔔 Local Notification: $title - $message');
    }

    // Platform-specific local notifications implementation pending
    // Requires flutter_local_notifications package for full functionality
    // Current implementation provides debug logging as placeholder
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      final NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      if (kDebugMode) {
        print(
            '🔐 Notification permissions: ${isAuthorized ? "granted" : "denied"}');
      }

      return isAuthorized;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to request permissions: $e');
      }
      return false;
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      if (_fcmToken != null) return _fcmToken;

      _fcmToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print('📱 Retrieved FCM Token: $_fcmToken');
      }
      return _fcmToken;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get FCM token: $e');
      }
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('📢 Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to subscribe to topic $topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('📢 Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to unsubscribe from topic $topic: $e');
      }
    }
  }

  /// Set notification callbacks
  void setCallbacks({
    Function(String)? onTokenRefresh,
    Function(RemoteMessage)? onMessageReceived,
    Function(RemoteMessage)? onMessageOpened,
  }) {
    this.onTokenRefresh = onTokenRefresh;
    this.onMessageReceived = onMessageReceived;
    this.onMessageOpened = onMessageOpened;
  }

  /// Delete FCM token (for logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      if (kDebugMode) {
        print('🗑️ FCM Token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to delete FCM token: $e');
      }
    }
  }

  /// Get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// Handle background message (static method for main.dart)
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('🔔 Background message: ${message.notification?.title}');
    }
  }
}
