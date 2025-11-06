/// Notification model for MultiSales app
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String category;
  final NotificationPriority priority;
  final String userId;
  final bool isRead;
  final DateTime? readAt;
  final Map<String, dynamic> data;
  final String? imageUrl;
  final String? actionUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    this.priority = NotificationPriority.medium,
    required this.userId,
    this.isRead = false,
    this.readAt,
    this.data = const {},
    this.imageUrl,
    this.actionUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create NotificationModel from Firestore document
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      category: map['category'] ?? '',
      priority: NotificationPriority.values.firstWhere(
        (p) => p.toString().split('.').last == map['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      userId: map['userId'] ?? '',
      isRead: map['isRead'] ?? false,
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      imageUrl: map['imageUrl'],
      actionUrl: map['actionUrl'],
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert NotificationModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'category': category,
      'priority': priority.toString().split('.').last,
      'userId': userId,
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'data': data,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? category,
    NotificationPriority? priority,
    String? userId,
    bool? isRead,
    DateTime? readAt,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get priority color
  String get priorityColor {
    switch (priority) {
      case NotificationPriority.urgent:
        return '#FF5722'; // Deep Orange
      case NotificationPriority.high:
        return '#F44336'; // Red
      case NotificationPriority.medium:
        return '#FF9800'; // Orange
      case NotificationPriority.low:
        return '#4CAF50'; // Green
    }
  }

  /// Get priority icon
  String get priorityIcon {
    switch (priority) {
      case NotificationPriority.urgent:
        return 'error';
      case NotificationPriority.high:
        return 'warning';
      case NotificationPriority.medium:
        return 'info';
      case NotificationPriority.low:
        return 'check_circle';
    }
  }

  /// Get category icon
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'order_updates':
        return 'shopping_cart';
      case 'promotions':
        return 'local_offer';
      case 'support':
        return 'support_agent';
      case 'system':
        return 'settings';
      case 'security':
        return 'security';
      case 'billing':
        return 'payment';
      case 'maintenance':
        return 'build';
      default:
        return 'notifications';
    }
  }

  /// Get category display name
  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'order_updates':
        return 'Order Updates';
      case 'promotions':
        return 'Promotions';
      case 'support':
        return 'Support';
      case 'system':
        return 'System';
      case 'security':
        return 'Security';
      case 'billing':
        return 'Billing';
      case 'maintenance':
        return 'Maintenance';
      default:
        return category;
    }
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} week${difference.inDays > 13 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if notification has action
  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;

  /// Check if notification has image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Check if notification is recent (within last hour)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 1;
  }

  /// Check if notification is urgent or high priority
  bool get isImportant {
    return priority == NotificationPriority.urgent ||
        priority == NotificationPriority.high;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationModel(id: $id, title: $title, category: $category)';
}

/// Notification priority levels
enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

/// Extension for NotificationPriority
extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.medium:
        return 'Medium';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  int get value {
    switch (this) {
      case NotificationPriority.low:
        return 1;
      case NotificationPriority.medium:
        return 2;
      case NotificationPriority.high:
        return 3;
      case NotificationPriority.urgent:
        return 4;
    }
  }
}

/// Notification category helpers
class NotificationCategory {
  static const String orderUpdates = 'order_updates';
  static const String promotions = 'promotions';
  static const String support = 'support';
  static const String system = 'system';
  static const String security = 'security';
  static const String billing = 'billing';
  static const String maintenance = 'maintenance';

  static List<String> get all => [
        orderUpdates,
        promotions,
        support,
        system,
        security,
        billing,
        maintenance,
      ];

  static String getDisplayName(String category) {
    switch (category.toLowerCase()) {
      case orderUpdates:
        return 'Order Updates';
      case promotions:
        return 'Promotions';
      case support:
        return 'Support';
      case system:
        return 'System';
      case security:
        return 'Security';
      case billing:
        return 'Billing';
      case maintenance:
        return 'Maintenance';
      default:
        return category;
    }
  }
}
