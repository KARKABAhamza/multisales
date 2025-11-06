// Minimal stub for AnalyticsService for public-only app
class AnalyticsService {
  // Stub observer for GoRouter analytics integration
  Object get observer => Object();

  // Stub event logging methods
  Future<void> logCustomEvent({required String eventName, Map<String, dynamic>? parameters}) async {}
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}
  Future<void> logPageView({required String pageName, String? pageClass, Map<String, Object>? parameters}) async {}
  Future<void> setUserProperties({String? userId, String? userRole, String? department, String? location}) async {}
  Future<void> resetAnalyticsData() async {}
}
