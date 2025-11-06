/// Support ticket model for MultiSales app
class SupportTicket {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority; // low, medium, high, urgent
  final String status; // open, in_progress, resolved, closed
  final String userId;
  final String? assignedTo;
  final List<String> attachments;
  final List<TicketMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;

  SupportTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.userId,
    this.assignedTo,
    this.attachments = const [],
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
  });

  /// Create SupportTicket from Firestore document
  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    return SupportTicket(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      priority: map['priority'] ?? 'medium',
      status: map['status'] ?? 'open',
      userId: map['userId'] ?? '',
      assignedTo: map['assignedTo'],
      attachments: List<String>.from(map['attachments'] ?? []),
      messages: (map['messages'] as List<dynamic>? ?? [])
          .map((msg) => TicketMessage.fromMap(msg))
          .toList(),
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      resolvedAt:
          map['resolvedAt'] != null ? DateTime.parse(map['resolvedAt']) : null,
    );
  }

  /// Convert SupportTicket to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'userId': userId,
      'assignedTo': assignedTo,
      'attachments': attachments,
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  SupportTicket copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? userId,
    String? assignedTo,
    List<String>? attachments,
    List<TicketMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      assignedTo: assignedTo ?? this.assignedTo,
      attachments: attachments ?? this.attachments,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  /// Get priority color
  String get priorityColor {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return '#FF5722'; // Deep Orange
      case 'high':
        return '#F44336'; // Red
      case 'medium':
        return '#FF9800'; // Orange
      case 'low':
        return '#4CAF50'; // Green
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Get status color
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'open':
        return '#2196F3'; // Blue
      case 'in_progress':
        return '#FF9800'; // Orange
      case 'resolved':
        return '#4CAF50'; // Green
      case 'closed':
        return '#9E9E9E'; // Grey
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Check if ticket is active
  bool get isActive => status != 'closed' && status != 'resolved';

  /// Get time since creation
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportTicket &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SupportTicket(id: $id, title: $title, status: $status)';
}

/// Ticket message model for chat-like communication
class TicketMessage {
  final String id;
  final String message;
  final bool isFromSupport;
  final DateTime timestamp;
  final String authorName;
  final String? authorAvatar;
  final List<String> attachments;

  TicketMessage({
    required this.id,
    required this.message,
    required this.isFromSupport,
    required this.timestamp,
    required this.authorName,
    this.authorAvatar,
    this.attachments = const [],
  });

  /// Create TicketMessage from Map
  factory TicketMessage.fromMap(Map<String, dynamic> map) {
    return TicketMessage(
      id: map['id'] ?? '',
      message: map['message'] ?? '',
      isFromSupport: map['isFromSupport'] ?? false,
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      authorName: map['authorName'] ?? '',
      authorAvatar: map['authorAvatar'],
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }

  /// Convert TicketMessage to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'isFromSupport': isFromSupport,
      'timestamp': timestamp.toIso8601String(),
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'attachments': attachments,
    };
  }

  /// Get time since message
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() =>
      'TicketMessage(id: $id, from: $authorName, isSupport: $isFromSupport)';
}
