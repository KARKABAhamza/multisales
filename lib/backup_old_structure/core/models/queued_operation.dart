// lib/core/models/queued_operation.dart

/// Represents an operation queued for background processing
class QueuedOperation {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  final int maxRetries;

  QueuedOperation({
    required this.type,
    required this.data,
    DateTime? timestamp,
    this.retryCount = 0,
    this.maxRetries = 3,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create a copy with incremented retry count
  QueuedOperation withRetry() {
    return QueuedOperation(
      type: type,
      data: data,
      timestamp: timestamp,
      retryCount: retryCount + 1,
      maxRetries: maxRetries,
    );
  }

  /// Check if operation has exceeded max retries
  bool get hasExceededMaxRetries => retryCount >= maxRetries;

  /// Check if operation is stale (older than 1 hour)
  bool get isStale {
    return DateTime.now().difference(timestamp) > const Duration(hours: 1);
  }

  /// Get priority based on operation type and age
  int get priority {
    final ageMinutes = DateTime.now().difference(timestamp).inMinutes;

    switch (type) {
      case 'security_event':
        return 1 + ageMinutes; // Higher priority for security events
      case 'session_update':
        return 5 + ageMinutes;
      case 'profile_update':
        return 10 + ageMinutes;
      default:
        return 20 + ageMinutes;
    }
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'retryCount': retryCount,
      'maxRetries': maxRetries,
    };
  }

  /// Create from JSON
  factory QueuedOperation.fromJson(Map<String, dynamic> json) {
    return QueuedOperation(
      type: json['type'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      timestamp: DateTime.parse(json['timestamp'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
      maxRetries: json['maxRetries'] as int? ?? 3,
    );
  }
}
