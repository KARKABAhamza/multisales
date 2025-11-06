// lib/core/models/cached_data.dart

/// Data wrapper for caching with expiration
class CachedData<T> {
  final T data;
  final DateTime timestamp;
  final Duration timeout;

  CachedData(
    this.data,
    this.timestamp, {
    this.timeout = const Duration(minutes: 5),
  });

  /// Check if cached data has expired
  bool get isExpired {
    return DateTime.now().difference(timestamp) > timeout;
  }

  /// Get age of cached data in milliseconds
  int get ageInMilliseconds {
    return DateTime.now().difference(timestamp).inMilliseconds;
  }

  /// Check if data is still fresh (less than half timeout)
  bool get isFresh {
    return DateTime.now().difference(timestamp) <
        Duration(
          milliseconds: (timeout.inMilliseconds * 0.5).round(),
        );
  }
}
