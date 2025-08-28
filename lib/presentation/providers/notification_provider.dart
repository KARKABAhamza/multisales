import 'package:flutter/foundation.dart';

/// Notification Provider for MultiSales Client App
/// Handles push notifications, in-app notifications, and notification preferences
class NotificationProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _notifications = [];
  Map<String, bool> _notificationPreferences = {};
  int _unreadCount = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get notifications => _notifications;
  List<Map<String, dynamic>> get unreadNotifications =>
      _notifications.where((n) => !n['isRead']).toList();
  Map<String, bool> get notificationPreferences => _notificationPreferences;
  int get unreadCount => _unreadCount;

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

  // Initialize Notification Preferences
  Future<bool> initializeNotificationPreferences(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _notificationPreferences = {
        'orderUpdates': true,
        'paymentReminders': true,
        'serviceAlerts': true,
        'maintenanceNotices': true,
        'promotionalOffers': false,
        'appointmentReminders': true,
        'supportTicketUpdates': true,
        'securityAlerts': true,
        'newsletterUpdates': false,
      };

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize notification preferences: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Client Notifications
  Future<bool> loadClientNotifications(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      _notifications = [
        {
          'id': 'notif_001',
          'type': 'order_update',
          'title': 'Order Confirmation',
          'message':
              'Your order #MS12345 has been confirmed and is being processed.',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'isRead': false,
          'priority': 'medium',
          'actionUrl': '/orders/MS12345',
          'iconType': 'order',
          'data': {'orderId': 'MS12345', 'status': 'confirmed'},
        },
        {
          'id': 'notif_002',
          'type': 'service_alert',
          'title': 'Maintenance Schedule',
          'message':
              'Scheduled maintenance on Aug 5, 2025, from 2:00 AM to 4:00 AM. Service may be interrupted.',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
          'isRead': false,
          'priority': 'high',
          'actionUrl': '/service-status',
          'iconType': 'maintenance',
          'data': {'maintenanceDate': '2025-08-05', 'duration': '2 hours'},
        },
        {
          'id': 'notif_003',
          'type': 'payment_reminder',
          'title': 'Payment Due',
          'message':
              'Your invoice #MS-2025-002 of 899 MAD is due on August 31, 2025.',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'isRead': true,
          'priority': 'medium',
          'actionUrl': '/invoices/MS-2025-002',
          'iconType': 'payment',
          'data': {
            'invoiceId': 'MS-2025-002',
            'amount': 899.0,
            'dueDate': '2025-08-31'
          },
        },
        {
          'id': 'notif_004',
          'type': 'appointment_reminder',
          'title': 'Appointment Tomorrow',
          'message':
              'Technical appointment with Ahmed Benali scheduled for Aug 1, 2025, at 2:00 PM.',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 12))
              .toIso8601String(),
          'isRead': false,
          'priority': 'high',
          'actionUrl': '/appointments/apt_1722345600000',
          'iconType': 'appointment',
          'data': {
            'appointmentId': 'apt_1722345600000',
            'technicianName': 'Ahmed Benali'
          },
        },
        {
          'id': 'notif_005',
          'type': 'promotional_offer',
          'title': 'Special Offer: 20% Off',
          'message':
              'Upgrade your internet plan and get 20% off for the first 3 months!',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'isRead': true,
          'priority': 'low',
          'actionUrl': '/offers/summer2025',
          'iconType': 'offer',
          'data': {'offerCode': 'SUMMER20', 'validUntil': '2025-08-31'},
        },
        {
          'id': 'notif_006',
          'type': 'support_ticket_update',
          'title': 'Support Ticket Update',
          'message':
              'Your support ticket #TKT_123 has been resolved. Please check the solution.',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 18))
              .toIso8601String(),
          'isRead': false,
          'priority': 'medium',
          'actionUrl': '/support/tickets/TKT_123',
          'iconType': 'support',
          'data': {'ticketId': 'TKT_123', 'status': 'resolved'},
        },
        {
          'id': 'notif_007',
          'type': 'security_alert',
          'title': 'New Login Detected',
          'message':
              'A new login to your account was detected from Rabat. If this wasn\'t you, please secure your account.',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'isRead': true,
          'priority': 'urgent',
          'actionUrl': '/security/activity',
          'iconType': 'security',
          'data': {'location': 'Rabat', 'device': 'Mobile App'},
        },
      ];

      _updateUnreadCount();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load notifications: $e');
      _setLoading(false);
      return false;
    }
  }

  // Mark Notification as Read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final notificationIndex =
          _notifications.indexWhere((n) => n['id'] == notificationId);

      if (notificationIndex != -1) {
        _notifications[notificationIndex]['isRead'] = true;
        _notifications[notificationIndex]['readAt'] =
            DateTime.now().toIso8601String();
        _updateUnreadCount();
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError('Failed to mark notification as read: $e');
      return false;
    }
  }

  // Mark All Notifications as Read
  Future<bool> markAllAsRead() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      for (var notification in _notifications) {
        if (!notification['isRead']) {
          notification['isRead'] = true;
          notification['readAt'] = DateTime.now().toIso8601String();
        }
      }

      _updateUnreadCount();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to mark all notifications as read: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete Notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      _notifications.removeWhere((n) => n['id'] == notificationId);
      _updateUnreadCount();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete notification: $e');
      return false;
    }
  }

  // Update Notification Preferences
  Future<bool> updateNotificationPreferences(
      Map<String, bool> newPreferences) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _notificationPreferences = {
        ..._notificationPreferences,
        ...newPreferences
      };
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update notification preferences: $e');
      _setLoading(false);
      return false;
    }
  }

  // Send Push Notification (for testing purposes)
  Future<bool> sendTestNotification({
    required String type,
    required String title,
    required String message,
    String priority = 'medium',
    Map<String, dynamic>? data,
  }) async {
    try {
      final newNotification = {
        'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
        'type': type,
        'title': title,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
        'priority': priority,
        'actionUrl': null,
        'iconType': type.split('_')[0],
        'data': data ?? {},
      };

      _notifications.insert(0, newNotification);
      _updateUnreadCount();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to send test notification: $e');
      return false;
    }
  }

  // Clear All Notifications
  Future<bool> clearAllNotifications() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _notifications.clear();
      _unreadCount = 0;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to clear all notifications: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get Notifications by Type
  List<Map<String, dynamic>> getNotificationsByType(String type) {
    return _notifications.where((n) => n['type'] == type).toList();
  }

  // Get Notifications by Priority
  List<Map<String, dynamic>> getNotificationsByPriority(String priority) {
    return _notifications.where((n) => n['priority'] == priority).toList();
  }

  // Get Recent Notifications (last 7 days)
  List<Map<String, dynamic>> getRecentNotifications() {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));

    return _notifications.where((n) {
      final notificationDate = DateTime.parse(n['timestamp']);
      return notificationDate.isAfter(oneWeekAgo);
    }).toList();
  }

  // Private method to update unread count
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n['isRead']).length;
  }

  // Get notification icon based on type
  String getNotificationIcon(String type) {
    switch (type) {
      case 'order_update':
      case 'order':
        return '📦';
      case 'service_alert':
      case 'maintenance':
        return '🔧';
      case 'payment_reminder':
      case 'payment':
        return '💳';
      case 'appointment_reminder':
      case 'appointment':
        return '📅';
      case 'promotional_offer':
      case 'offer':
        return '🎁';
      case 'support_ticket_update':
      case 'support':
        return '🎫';
      case 'security_alert':
      case 'security':
        return '🔒';
      default:
        return '📢';
    }
  }

  // Get notification color based on priority
  String getNotificationColor(String priority) {
    switch (priority) {
      case 'urgent':
        return '#FF5252'; // Red
      case 'high':
        return '#FF9800'; // Orange
      case 'medium':
        return '#2196F3'; // Blue
      case 'low':
        return '#4CAF50'; // Green
      default:
        return '#757575'; // Grey
    }
  }
}
