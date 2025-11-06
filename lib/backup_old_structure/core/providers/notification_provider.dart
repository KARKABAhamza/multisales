import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/notification_model.dart';

/// Notification provider for MultiSales app
/// Manages push notifications, in-app alerts, and notification preferences
class NotificationProvider with ChangeNotifier {
  final FirestoreService _firestoreService;

  // Notifications
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _unreadNotifications = [];

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Notification preferences
  bool _isPushEnabled = true;
  bool _isEmailEnabled = true;
  bool _isSmsEnabled = false;
  Map<String, bool> _categoryPreferences = {};

  // Filters
  String _selectedCategory = 'all';
  bool _showOnlyUnread = false;

  NotificationProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  bool get isPushEnabled => _isPushEnabled;
  bool get isEmailEnabled => _isEmailEnabled;
  bool get isSmsEnabled => _isSmsEnabled;
  Map<String, bool> get categoryPreferences => _categoryPreferences;

  String get selectedCategory => _selectedCategory;
  bool get showOnlyUnread => _showOnlyUnread;

  // Computed getters
  int get unreadCount => _unreadNotifications.length;
  bool get hasUnreadNotifications => _unreadNotifications.isNotEmpty;

  List<NotificationModel> get filteredNotifications {
    var filtered = _notifications;

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered =
          filtered.where((n) => n.category == _selectedCategory).toList();
    }

    // Filter by read status
    if (_showOnlyUnread) {
      filtered = filtered.where((n) => !n.isRead).toList();
    }

    return filtered;
  }

  List<String> get availableCategories {
    final categories = _notifications.map((n) => n.category).toSet().toList();
    categories.sort();
    return ['all', ...categories];
  }

  Map<String, int> get notificationStats {
    return {
      'total': _notifications.length,
      'unread': _unreadNotifications.length,
      'today': _notifications.where((n) => _isToday(n.createdAt)).length,
      'this_week': _notifications.where((n) => _isThisWeek(n.createdAt)).length,
    };
  }

  /// Initialize notification provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _setLoading(true);
      _clearError();

      await Future.wait([
        _loadNotifications(),
        _loadPreferences(),
        _initializeCategoryPreferences(),
      ]);

      _isInitialized = true;
    } catch (e) {
      _setError('Failed to initialize notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load notifications from Firestore
  Future<void> _loadNotifications() async {
    try {
      // Load from Firestore with error handling
      final result = await _firestoreService.getCollection(
        collection: 'notifications',
      );

      if (result['success'] == true && result['data'] != null) {
        final List<Map<String, dynamic>> notificationDocs =
            List<Map<String, dynamic>>.from(result['data']);
        _notifications = notificationDocs
            .map((doc) => NotificationModel.fromMap(doc))
            .toList();
        _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        // Fallback to mock data if Firestore fails
        _notifications = _generateMockNotifications();
      }

      _updateUnreadNotifications();
      notifyListeners();
    } catch (e) {
      // Fallback to mock data on any error
      _notifications = _generateMockNotifications();
      _updateUnreadNotifications();
      notifyListeners();
    }
  }

  /// Load notification preferences
  Future<void> _loadPreferences() async {
    try {
      // Load from Firestore or SharedPreferences (implementation)
      // For now, use defaults
      _isPushEnabled = true;
      _isEmailEnabled = true;
      _isSmsEnabled = false;
    } catch (e) {
      throw Exception('Failed to load preferences: $e');
    }
  }

  /// Initialize category preferences
  Future<void> _initializeCategoryPreferences() async {
    final categories = [
      'order_updates',
      'promotions',
      'support',
      'system',
      'security'
    ];
    _categoryPreferences = {
      for (String category in categories) category: true,
    };
  }

  /// Create a new notification
  Future<void> createNotification({
    required String title,
    required String message,
    required String category,
    String? userId,
    Map<String, dynamic>? data,
    NotificationPriority priority = NotificationPriority.medium,
  }) async {
    try {
      final now = DateTime.now();
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        category: category,
        priority: priority,
        userId: userId ?? 'current_user_id',
        data: data ?? {},
        createdAt: now,
        updatedAt: now,
      );

      // Save to Firestore
      final result = await _firestoreService.createDocument(
        collection: 'notifications',
        documentId: notification.id,
        data: notification.toMap(),
      );

      if (result['success'] == true) {
        // Add to local list only if Firestore save succeeded
        _notifications.insert(0, notification);
        _updateUnreadNotifications();
        notifyListeners();
      } else {
        _setError('Failed to save notification: ${result['error']}');
      }
    } catch (e) {
      _setError('Failed to create notification: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        final updatedNotification = _notifications[index].copyWith(
          isRead: true,
          readAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Update in Firestore first
        final result = await _firestoreService.updateDocument(
          collection: 'notifications',
          documentId: notificationId,
          data: updatedNotification.toMap(),
        );

        if (result['success'] == true) {
          // Update local state only if Firestore update succeeded
          _notifications[index] = updatedNotification;
          _updateUnreadNotifications();
          notifyListeners();
        } else {
          _setError('Failed to update notification: ${result['error']}');
        }
      }
    } catch (e) {
      _setError('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final now = DateTime.now();
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(
            isRead: true,
            readAt: now,
            updatedAt: now,
          );
        }
      }

      _updateUnreadNotifications();
      notifyListeners();

      // Batch update in Firestore (implementation)
    } catch (e) {
      _setError('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      // Delete from Firestore first
      final result = await _firestoreService.deleteDocument(
        collection: 'notifications',
        documentId: notificationId,
      );

      if (result['success'] == true) {
        // Remove from local list only if Firestore delete succeeded
        _notifications.removeWhere((n) => n.id == notificationId);
        _updateUnreadNotifications();
        notifyListeners();
      } else {
        _setError('Failed to delete notification: ${result['error']}');
      }
    } catch (e) {
      _setError('Failed to delete notification: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      _notifications.clear();
      _unreadNotifications.clear();

      // Clear from Firestore (implementation)

      notifyListeners();
    } catch (e) {
      _setError('Failed to clear notifications: $e');
    }
  }

  /// Update notification preferences
  Future<void> updatePreferences({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    Map<String, bool>? categoryPreferences,
  }) async {
    try {
      if (pushEnabled != null) _isPushEnabled = pushEnabled;
      if (emailEnabled != null) _isEmailEnabled = emailEnabled;
      if (smsEnabled != null) _isSmsEnabled = smsEnabled;
      if (categoryPreferences != null) {
        _categoryPreferences.addAll(categoryPreferences);
      }

      // Save to Firestore (implementation)

      notifyListeners();
    } catch (e) {
      _setError('Failed to update preferences: $e');
    }
  }

  /// Set category filter
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Toggle show only unread
  void toggleShowOnlyUnread() {
    _showOnlyUnread = !_showOnlyUnread;
    notifyListeners();
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await _loadNotifications();
  }

  /// Private helper methods
  void _updateUnreadNotifications() {
    _unreadNotifications = _notifications.where((n) => !n.isRead).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return date.isAfter(startOfWeek);
  }

  /// Generate mock notifications for development
  List<NotificationModel> _generateMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        title: 'Order Confirmed',
        message: 'Your order #12345 has been confirmed and is being processed.',
        category: 'order_updates',
        priority: NotificationPriority.high,
        userId: 'user1',
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
      NotificationModel(
        id: '2',
        title: 'Special Promotion',
        message: '🎉 Get 20% off on all fiber internet plans this month!',
        category: 'promotions',
        priority: NotificationPriority.medium,
        userId: 'user1',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '3',
        title: 'Support Ticket Updated',
        message: 'Your support ticket #001 has been resolved.',
        category: 'support',
        priority: NotificationPriority.medium,
        userId: 'user1',
        isRead: true,
        readAt: now.subtract(const Duration(hours: 1)),
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: '4',
        title: 'Security Alert',
        message: 'New login detected from a different device.',
        category: 'security',
        priority: NotificationPriority.urgent,
        userId: 'user1',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  void dispose() {
    _notifications.clear();
    _unreadNotifications.clear();
    _categoryPreferences.clear();
    super.dispose();
  }
}
