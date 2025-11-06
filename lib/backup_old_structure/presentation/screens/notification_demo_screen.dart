import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/notification_provider.dart';
import '../../core/services/notification_service.dart';

/// Demo screen showing notification capabilities
class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _loadFCMToken();
    _setupNotificationCallbacks();
  }

  Future<void> _loadFCMToken() async {
    final token = await _notificationService.getFCMToken();
    if (mounted) {
      setState(() {
        _fcmToken = token;
      });
    }
  }

  void _setupNotificationCallbacks() {
    _notificationService.setCallbacks(
      onTokenRefresh: (token) {
        if (mounted) {
          setState(() {
            _fcmToken = token;
          });
        }
      },
      onMessageReceived: (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('📩 New message: ${message.notification?.title}'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      },
      onMessageOpened: (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('🔍 Opened message: ${message.notification?.title}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Status Card
                Card(
                  child: ListTile(
                    leading: Icon(
                      _notificationService.isInitialized
                          ? Icons.check_circle
                          : Icons.error,
                      color: _notificationService.isInitialized
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: const Text('Notification Service'),
                    subtitle: Text(
                      _notificationService.isInitialized
                          ? 'Initialized and ready'
                          : 'Not initialized',
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // FCM Token Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FCM Token',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: double.infinity,
                          child: SelectableText(
                            _fcmToken ?? 'Loading...',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Create Test Notification
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _createTestNotification(notificationProvider),
                    icon: const Icon(Icons.add_alert),
                    label: const Text('Create Test Notification'),
                  ),
                ),

                const SizedBox(height: 8),

                // Request Permissions
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _requestPermissions,
                    icon: const Icon(Icons.security),
                    label: const Text('Request Permissions'),
                  ),
                ),

                const SizedBox(height: 8),

                // Subscribe to Topic
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _subscribeToTopic('test_topic'),
                    icon: const Icon(Icons.subscriptions),
                    label: const Text('Subscribe to Test Topic'),
                  ),
                ),

                const SizedBox(height: 16),

                // Notification Stats
                if (notificationProvider.isInitialized) ...[
                  const Text(
                    'Notification Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildStatRow(
                              'Total',
                              notificationProvider.notificationStats['total'] ??
                                  0),
                          _buildStatRow(
                              'Unread',
                              notificationProvider
                                      .notificationStats['unread'] ??
                                  0),
                          _buildStatRow(
                              'Today',
                              notificationProvider.notificationStats['today'] ??
                                  0),
                          _buildStatRow(
                              'This Week',
                              notificationProvider
                                      .notificationStats['this_week'] ??
                                  0),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Recent Notifications
                if (notificationProvider.notifications.isNotEmpty) ...[
                  const Text(
                    'Recent Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...notificationProvider.notifications.take(3).map(
                        (notification) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: notification.isRead
                                  ? Colors.grey
                                  : Colors.blue,
                              child: Icon(
                                _getNotificationIcon(notification.category),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              notification.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              _formatTime(notification.createdAt),
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () => notificationProvider
                                .markAsRead(notification.id),
                          ),
                        ),
                      ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String category) {
    switch (category) {
      case 'order_updates':
        return Icons.shopping_cart;
      case 'promotions':
        return Icons.local_offer;
      case 'support':
        return Icons.support_agent;
      case 'security':
        return Icons.security;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _createTestNotification(NotificationProvider provider) async {
    await provider.createNotification(
      title: 'Test Notification',
      message:
          'This is a test notification created at ${DateTime.now().toString().substring(11, 19)}',
      category: 'system',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Test notification created!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    final granted = await _notificationService.requestPermissions();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? '✅ Notification permissions granted'
                : '❌ Notification permissions denied',
          ),
          backgroundColor: granted ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    await _notificationService.subscribeToTopic(topic);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Subscribed to topic: $topic'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
