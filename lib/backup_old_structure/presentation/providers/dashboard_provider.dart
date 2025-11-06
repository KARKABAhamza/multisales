import 'package:flutter/foundation.dart';

/// Dashboard Provider for MultiSales Client App
/// Handles client dashboard, analytics, usage statistics, and performance metrics
class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _usageStatistics;
  List<Map<String, dynamic>> _activityTimeline = [];
  Map<String, List<Map<String, dynamic>>> _chartData = {};
  Map<String, dynamic>? _accountSummary;
  List<Map<String, dynamic>> _quickActions = [];

  String _selectedPeriod = 'monthly'; // daily, weekly, monthly, yearly
  DateTime _selectedDate = DateTime.now();

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get dashboardData => _dashboardData;
  Map<String, dynamic>? get usageStatistics => _usageStatistics;
  List<Map<String, dynamic>> get activityTimeline => _activityTimeline;
  Map<String, List<Map<String, dynamic>>> get chartData => _chartData;
  Map<String, dynamic>? get accountSummary => _accountSummary;
  List<Map<String, dynamic>> get quickActions => _quickActions;
  String get selectedPeriod => _selectedPeriod;
  DateTime get selectedDate => _selectedDate;

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

  // Initialize Dashboard
  Future<bool> initializeDashboard(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      await Future.wait([
        _loadDashboardData(clientId),
        _loadUsageStatistics(clientId),
        _loadActivityTimeline(clientId),
        _loadChartData(clientId),
        _loadAccountSummary(clientId),
        _loadQuickActions(),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize dashboard: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Dashboard Data
  Future<bool> _loadDashboardData(String clientId) async {
    try {
      _dashboardData = {
        'welcomeMessage': 'Welcome back, Ahmed!',
        'lastLoginDate':
            DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        'currentPlan': {
          'name': 'Fiber Pro 500 Mbps',
          'price': 299.0,
          'currency': 'MAD',
          'renewalDate':
              DateTime.now().add(const Duration(days: 24)).toIso8601String(),
          'status': 'active',
        },
        'accountHealth': {
          'score': 92, // out of 100
          'status': 'excellent',
          'factors': {
            'payment_history': 95,
            'service_usage': 88,
            'support_interactions': 94,
            'app_engagement': 91,
          },
        },
        'monthlySpending': {
          'current': 345.0,
          'previous': 298.0,
          'budget': 400.0,
          'currency': 'MAD',
        },
        'serviceStatus': {
          'internet': {
            'status': 'active',
            'uptime': 99.8,
            'speed': 487.5, // Mbps
            'lastCheck': DateTime.now()
                .subtract(const Duration(minutes: 15))
                .toIso8601String(),
          },
          'mobile': {
            'status': 'active',
            'dataUsed': 12.3, // GB
            'dataLimit': 50.0, // GB
            'renewsOn':
                DateTime.now().add(const Duration(days: 18)).toIso8601String(),
          },
          'tv': {
            'status': 'inactive',
            'channels': 0,
            'lastWatched': null,
          },
        },
        'alerts': [
          {
            'type': 'info',
            'message':
                'Your internet speed has been automatically upgraded to 500 Mbps',
            'date': DateTime.now()
                .subtract(const Duration(days: 2))
                .toIso8601String(),
            'isRead': false,
          },
          {
            'type': 'warning',
            'message': 'Bill payment due in 5 days (Invoice #MS-2025-003)',
            'date': DateTime.now()
                .subtract(const Duration(hours: 12))
                .toIso8601String(),
            'isRead': false,
          },
        ],
        'recommendations': [
          {
            'type': 'upgrade',
            'title': 'Mobile Data Add-on',
            'description': 'Add 20GB extra data for just 99 MAD',
            'savingPercent': 25,
            'validUntil':
                DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          },
          {
            'type': 'bundle',
            'title': 'TV Package Bundle',
            'description': 'Add premium TV channels and save 150 MAD monthly',
            'savingPercent': 35,
            'validUntil':
                DateTime.now().add(const Duration(days: 14)).toIso8601String(),
          },
        ],
      };

      return true;
    } catch (e) {
      _setError('Failed to load dashboard data: $e');
      return false;
    }
  }

  // Load Usage Statistics
  Future<bool> _loadUsageStatistics(String clientId) async {
    try {
      _usageStatistics = {
        'internet': {
          'totalUsage': 450.7, // GB
          'previousMonth': 389.2, // GB
          'dailyAverage': 15.2, // GB
          'peakUsageTime': '21:00-23:00',
          'topApplications': [
            {'name': 'Video Streaming', 'usage': 145.3, 'percentage': 32.2},
            {'name': 'Video Calls', 'usage': 89.7, 'percentage': 19.9},
            {'name': 'Web Browsing', 'usage': 78.4, 'percentage': 17.4},
            {'name': 'Social Media', 'usage': 67.2, 'percentage': 14.9},
            {'name': 'Gaming', 'usage': 45.6, 'percentage': 10.1},
            {'name': 'Others', 'usage': 24.5, 'percentage': 5.4},
          ],
          'monthlyTrend': [
            {'month': 'Jan', 'usage': 312.4},
            {'month': 'Feb', 'usage': 289.7},
            {'month': 'Mar', 'usage': 356.8},
            {'month': 'Apr', 'usage': 389.2},
            {'month': 'May', 'usage': 450.7},
          ],
        },
        'mobile': {
          'dataUsage': 12.3, // GB used
          'dataLimit': 50.0, // GB limit
          'voiceMinutes': 145, // minutes used
          'voiceLimit': 1000, // minutes limit
          'smsCount': 23, // SMS sent
          'smsLimit': 500, // SMS limit
          'remainingDays': 18,
          'averageDailyUsage': 0.85, // GB
          'topUsageCategories': [
            {'category': 'Social Media', 'usage': 4.2, 'percentage': 34.1},
            {'category': 'Video Streaming', 'usage': 3.1, 'percentage': 25.2},
            {'category': 'Maps & Navigation', 'usage': 2.4, 'percentage': 19.5},
            {'category': 'Web Browsing', 'usage': 1.8, 'percentage': 14.6},
            {'category': 'Others', 'usage': 0.8, 'percentage': 6.5},
          ],
        },
        'performance': {
          'internetSpeed': {
            'current': 487.5, // Mbps
            'promised': 500.0, // Mbps
            'percentage': 97.5,
            'trend': 'stable',
          },
          'latency': {
            'current': 12, // ms
            'average': 15, // ms
            'trend': 'improving',
          },
          'uptime': {
            'current': 99.8, // percentage
            'target': 99.5, // percentage
            'trend': 'excellent',
          },
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load usage statistics: $e');
      return false;
    }
  }

  // Load Activity Timeline
  Future<bool> _loadActivityTimeline(String clientId) async {
    try {
      _activityTimeline = [
        {
          'id': 'activity_001',
          'type': 'payment',
          'title': 'Payment Processed',
          'description':
              'Monthly bill payment of 299 MAD completed successfully',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'icon': 'payment',
          'status': 'completed',
          'amount': 299.0,
        },
        {
          'id': 'activity_002',
          'type': 'service_change',
          'title': 'Internet Speed Upgraded',
          'description':
              'Your connection has been automatically upgraded to 500 Mbps',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'icon': 'upgrade',
          'status': 'completed',
          'details': {'from': '300 Mbps', 'to': '500 Mbps'},
        },
        {
          'id': 'activity_003',
          'type': 'support',
          'title': 'Support Ticket Resolved',
          'description':
              'Technical issue with router connectivity has been resolved',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'icon': 'support',
          'status': 'completed',
          'ticketId': 'TKT_123',
        },
        {
          'id': 'activity_004',
          'type': 'appointment',
          'title': 'Technician Visit Completed',
          'description':
              'Installation and setup of new router completed successfully',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 7))
              .toIso8601String(),
          'icon': 'technician',
          'status': 'completed',
          'technicianName': 'Ahmed Benali',
        },
        {
          'id': 'activity_005',
          'type': 'account',
          'title': 'Profile Updated',
          'description': 'Contact information and preferences updated',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 12))
              .toIso8601String(),
          'icon': 'account',
          'status': 'completed',
        },
        {
          'id': 'activity_006',
          'type': 'promotion',
          'title': 'Promo Code Applied',
          'description': 'SUMMER50 promo code applied for 50% discount',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'icon': 'promotion',
          'status': 'completed',
          'savings': 149.5,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load activity timeline: $e');
      return false;
    }
  }

  // Load Chart Data
  Future<bool> _loadChartData(String clientId) async {
    try {
      _chartData = {
        'usage_trend': [
          {'date': '2025-07-25', 'internet': 12.5, 'mobile': 0.8},
          {'date': '2025-07-26', 'internet': 18.3, 'mobile': 1.2},
          {'date': '2025-07-27', 'internet': 22.1, 'mobile': 0.6},
          {'date': '2025-07-28', 'internet': 15.7, 'mobile': 0.9},
          {'date': '2025-07-29', 'internet': 19.4, 'mobile': 1.1},
          {'date': '2025-07-30', 'internet': 16.8, 'mobile': 0.7},
          {'date': '2025-07-31', 'internet': 21.2, 'mobile': 1.0},
        ],
        'speed_performance': [
          {'time': '00:00', 'speed': 498.2},
          {'time': '04:00', 'speed': 499.1},
          {'time': '08:00', 'speed': 485.7},
          {'time': '12:00', 'speed': 478.3},
          {'time': '16:00', 'speed': 471.8},
          {'time': '20:00', 'speed': 465.2},
          {'time': '23:59', 'speed': 489.6},
        ],
        'monthly_spending': [
          {'month': 'Jan', 'amount': 289.0},
          {'month': 'Feb', 'amount': 299.0},
          {'month': 'Mar', 'amount': 312.0},
          {'month': 'Apr', 'amount': 298.0},
          {'month': 'May', 'amount': 345.0},
        ],
        'service_distribution': [
          {'service': 'Internet', 'cost': 199.0, 'percentage': 57.7},
          {'service': 'Mobile', 'cost': 89.0, 'percentage': 25.8},
          {'service': 'Additional Services', 'cost': 57.0, 'percentage': 16.5},
        ],
      };

      return true;
    } catch (e) {
      _setError('Failed to load chart data: $e');
      return false;
    }
  }

  // Load Account Summary
  Future<bool> _loadAccountSummary(String clientId) async {
    try {
      _accountSummary = {
        'clientId': clientId,
        'accountNumber': 'MS2025789012',
        'memberSince': DateTime(2023, 3, 15).toIso8601String(),
        'loyaltyTier': 'Gold',
        'totalServices': 2,
        'activeServices': 2,
        'totalSpent': 8967.0,
        'currency': 'MAD',
        'paymentMethod': {
          'type': 'credit_card',
          'lastFour': '4532',
          'expiryMonth': 12,
          'expiryYear': 2026,
          'isDefault': true,
        },
        'nextBillDate':
            DateTime.now().add(const Duration(days: 24)).toIso8601String(),
        'nextBillAmount': 299.0,
        'autoPayEnabled': true,
        'paperlessBilling': true,
        'contactPreferences': {
          'email': true,
          'sms': true,
          'push': true,
          'whatsapp': false,
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load account summary: $e');
      return false;
    }
  }

  // Load Quick Actions
  Future<bool> _loadQuickActions() async {
    try {
      _quickActions = [
        {
          'id': 'pay_bill',
          'title': 'Pay Bill',
          'description': 'Pay your monthly bill quickly',
          'icon': 'payment',
          'action': 'navigate_to_billing',
          'badgeCount': 1, // Indicates pending bill
          'isEnabled': true,
          'priority': 'high',
        },
        {
          'id': 'speed_test',
          'title': 'Speed Test',
          'description': 'Test your internet connection speed',
          'icon': 'speed',
          'action': 'run_speed_test',
          'badgeCount': null,
          'isEnabled': true,
          'priority': 'medium',
        },
        {
          'id': 'support_chat',
          'title': 'Chat Support',
          'description': 'Get help from our support team',
          'icon': 'chat',
          'action': 'open_support_chat',
          'badgeCount': null,
          'isEnabled': true,
          'priority': 'medium',
        },
        {
          'id': 'usage_details',
          'title': 'Usage Details',
          'description': 'View detailed usage statistics',
          'icon': 'analytics',
          'action': 'navigate_to_usage',
          'badgeCount': null,
          'isEnabled': true,
          'priority': 'low',
        },
        {
          'id': 'manage_services',
          'title': 'Manage Services',
          'description': 'Add, remove, or modify services',
          'icon': 'services',
          'action': 'navigate_to_services',
          'badgeCount': null,
          'isEnabled': true,
          'priority': 'medium',
        },
        {
          'id': 'appointments',
          'title': 'Book Appointment',
          'description': 'Schedule technician visit',
          'icon': 'calendar',
          'action': 'navigate_to_appointments',
          'badgeCount': null,
          'isEnabled': true,
          'priority': 'low',
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load quick actions: $e');
      return false;
    }
  }

  // Refresh Dashboard Data
  Future<bool> refreshDashboard(String clientId) async {
    return await initializeDashboard(clientId);
  }

  // Update Selected Period
  Future<bool> updateSelectedPeriod(String period) async {
    if (!['daily', 'weekly', 'monthly', 'yearly'].contains(period)) {
      _setError('Invalid period selected');
      return false;
    }

    _selectedPeriod = period;
    notifyListeners();

    // Reload chart data for the new period
    await _loadChartData('client_123');
    return true;
  }

  // Update Selected Date
  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Run Speed Test
  Future<Map<String, dynamic>?> runSpeedTest() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(
          const Duration(seconds: 3)); // Simulate speed test duration

      final speedTestResult = {
        'downloadSpeed': 487.5 +
            (10 -
                20 *
                    (DateTime.now().millisecond /
                        1000)), // Simulate slight variations
        'uploadSpeed': 98.3 + (5 - 10 * (DateTime.now().second / 60)),
        'latency': 12 + (3 - 6 * (DateTime.now().minute / 60)),
        'jitter': 2.1,
        'testDate': DateTime.now().toIso8601String(),
        'serverId': 'casablanca-01',
        'serverLocation': 'Casablanca, Morocco',
      };

      // Update dashboard data with new speed
      if (_dashboardData != null) {
        _dashboardData!['serviceStatus']['internet']['speed'] =
            speedTestResult['downloadSpeed'];
        _dashboardData!['serviceStatus']['internet']['lastCheck'] =
            speedTestResult['testDate'];
      }

      _setLoading(false);
      return speedTestResult;
    } catch (e) {
      _setError('Failed to run speed test: $e');
      _setLoading(false);
      return null;
    }
  }

  // Get Usage Summary for Period
  Map<String, dynamic> getUsageSummary(String period) {
    if (_usageStatistics == null) return {};

    switch (period) {
      case 'daily':
        return {
          'internet': _usageStatistics!['internet']['dailyAverage'],
          'mobile': _usageStatistics!['mobile']['averageDailyUsage'],
        };
      case 'weekly':
        return {
          'internet':
              (_usageStatistics!['internet']['dailyAverage'] as double) * 7,
          'mobile':
              (_usageStatistics!['mobile']['averageDailyUsage'] as double) * 7,
        };
      case 'monthly':
        return {
          'internet': _usageStatistics!['internet']['totalUsage'],
          'mobile': _usageStatistics!['mobile']['dataUsage'],
        };
      default:
        return {};
    }
  }

  // Get Activity by Type
  List<Map<String, dynamic>> getActivityByType(String type) {
    return _activityTimeline
        .where((activity) => activity['type'] == type)
        .toList();
  }

  // Get Recent Activity (last 7 days)
  List<Map<String, dynamic>> getRecentActivity() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return _activityTimeline.where((activity) {
      final activityDate = DateTime.parse(activity['timestamp']);
      return activityDate.isAfter(sevenDaysAgo);
    }).toList();
  }

  // Mark Alert as Read
  void markAlertAsRead(int index) {
    if (_dashboardData != null &&
        _dashboardData!['alerts'] != null &&
        index < _dashboardData!['alerts'].length) {
      _dashboardData!['alerts'][index]['isRead'] = true;
      notifyListeners();
    }
  }

  // Get Unread Alerts Count
  int getUnreadAlertsCount() {
    if (_dashboardData == null || _dashboardData!['alerts'] == null) return 0;

    return (_dashboardData!['alerts'] as List)
        .where((alert) => !alert['isRead'])
        .length;
  }

  // Get Performance Score
  double getPerformanceScore() {
    if (_dashboardData == null) return 0.0;

    return (_dashboardData!['accountHealth']['score'] as int).toDouble();
  }

  // Get Savings Opportunities
  List<Map<String, dynamic>> getSavingsOpportunities() {
    if (_dashboardData == null) return [];

    return (_dashboardData!['recommendations'] as List<Map<String, dynamic>>)
        .where((rec) => rec['savingPercent'] != null)
        .toList();
  }

  // Calculate Month-over-Month Growth
  double calculateUsageGrowth() {
    if (_usageStatistics == null) return 0.0;

    final current = _usageStatistics!['internet']['totalUsage'] as double;
    final previous = _usageStatistics!['internet']['previousMonth'] as double;

    if (previous == 0) return 0.0;

    return ((current - previous) / previous) * 100;
  }
}
