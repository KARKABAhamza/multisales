import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/messaging_service.dart';
import '../services/push_config.dart';

class MessagingProvider with ChangeNotifier {
  MessagingProvider({MessagingService? service}) : _service = service ?? MessagingService();

  final MessagingService _service;

  bool _isLoading = false;
  String? _errorMessage;
  String? _fcmToken;
  NotificationSettings? _settings;
  RemoteMessage? _lastMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get fcmToken => _fcmToken;
  NotificationSettings? get settings => _settings;
  RemoteMessage? get lastMessage => _lastMessage;

  /// Initializes push with a permission prompt and token fetch.
  ///
  /// Web: requires a valid VAPID key in [kWebVapidKey].
  Future<void> init({bool requestPermissionIfNeeded = true}) async {
    _setLoading(true);
    try {
      if (requestPermissionIfNeeded) {
        _settings = await _service.requestPermission();
      }

      // Only attempt token retrieval if permission is granted or not determined (some platforms).
      final status = _settings?.authorizationStatus;
      if (status == null ||
          status == AuthorizationStatus.authorized ||
          status == AuthorizationStatus.provisional) {
        final token = await _service.getToken(webVapidKey: kWebVapidKey.isEmpty ? null : kWebVapidKey);
        _fcmToken = token;
      }

      // Foreground message listener
      _service.onMessage.listen((message) {
        _lastMessage = message;
        notifyListeners();
      });

      // Token refresh
      _service.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        notifyListeners();
      });

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _service.subscribeToTopic(topic);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _service.unsubscribeFromTopic(topic);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
