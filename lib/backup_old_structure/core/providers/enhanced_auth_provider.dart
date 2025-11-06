// This file is now empty. All authentication logic has been removed for public-only app.

/// Enhanced Authentication Provider with comprehensive security features
// Public-only app: authentication logic removed. This class is now a stub.
class EnhancedAuthProvider {
  bool get isLoading => false;
  // No authentication logic required for public-only app.
}

/// Session information model
class SessionInfo {
  final String id;
  final String deviceName;
  final String location;
  final DateTime lastActivity;
  final bool isCurrent;

  SessionInfo({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActivity,
    required this.isCurrent,
  });
}

/// Security recommendation model
class SecurityRecommendation {
  final String title;
  final String description;
  final SecurityPriority priority;
  final String action;

  SecurityRecommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.action,
  });
}

enum SecurityPriority { low, medium, high }
