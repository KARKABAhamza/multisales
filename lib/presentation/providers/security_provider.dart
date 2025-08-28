// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/foundation.dart';

/// Security Provider for MultiSales Client App
/// Handles enhanced security features, authentication, and account protection
class SecurityProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Security Status
  Map<String, dynamic>? _securityStatus;
  List<Map<String, dynamic>> _securityAlerts = [];
  List<Map<String, dynamic>> _loginHistory = [];
  List<Map<String, dynamic>> _activeDevices = [];
  List<Map<String, dynamic>> _trustedDevices = [];

  // Security Settings
  bool _twoFactorEnabled = false;
  final bool _biometricEnabled = false;
  final bool _emailVerificationEnabled = true;
  final bool _smsVerificationEnabled = false;
  final int _maxLoginAttempts = 5;
  final int _lockoutDuration = 30; // minutes

  // Password Security
  Map<String, dynamic>? _passwordPolicy;
  DateTime? _lastPasswordChange;
  bool _passwordExpirySoon = false;

  // Security Score
  double _securityScore = 0.0;
  final List<Map<String, dynamic>> _securityRecommendations = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get securityStatus => _securityStatus;
  List<Map<String, dynamic>> get securityAlerts => _securityAlerts;
  List<Map<String, dynamic>> get loginHistory => _loginHistory;
  List<Map<String, dynamic>> get activeDevices => _activeDevices;
  List<Map<String, dynamic>> get trustedDevices => _trustedDevices;
  bool get twoFactorEnabled => _twoFactorEnabled;
  bool get biometricEnabled => _biometricEnabled;
  bool get emailVerificationEnabled => _emailVerificationEnabled;
  bool get smsVerificationEnabled => _smsVerificationEnabled;
  int get maxLoginAttempts => _maxLoginAttempts;
  int get lockoutDuration => _lockoutDuration;
  Map<String, dynamic>? get passwordPolicy => _passwordPolicy;
  DateTime? get lastPasswordChange => _lastPasswordChange;
  bool get passwordExpirySoon => _passwordExpirySoon;
  double get securityScore => _securityScore;
  List<Map<String, dynamic>> get securityRecommendations =>
      _securityRecommendations;

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

  // Initialize Security System
  Future<bool> initializeSecurity(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      await Future.wait([
        _loadSecurityStatus(clientId),
        _loadSecurityAlerts(clientId),
        _loadLoginHistory(clientId),
        _loadActiveDevices(clientId),
        _loadTrustedDevices(clientId),
        _loadPasswordPolicy(),
        _calculateSecurityScore(),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize security system: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Security Status
  Future<bool> _loadSecurityStatus(String clientId) async {
    try {
      _securityStatus = {
        'clientId': clientId,
        'accountStatus': 'active',
        'lastSecurityCheck':
            DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        'riskLevel': 'low', // low, medium, high, critical
        'threatCount': 0,
        'vulnerabilityCount': 2,
        'complianceScore': 85.0,
        'features': {
          'twoFactor': _twoFactorEnabled,
          'biometric': _biometricEnabled,
          'emailVerification': _emailVerificationEnabled,
          'smsVerification': _smsVerificationEnabled,
          'deviceTracking': true,
          'encryptedStorage': true,
          'secureTransmission': true,
          'auditLogging': true,
        },
        'lastUpdate': DateTime.now().toIso8601String(),
      };

      return true;
    } catch (e) {
      _setError('Failed to load security status: $e');
      return false;
    }
  }

  // Load Security Alerts
  Future<bool> _loadSecurityAlerts(String clientId) async {
    try {
      _securityAlerts = [
        {
          'id': 'alert_001',
          'type': 'login_attempt',
          'severity': 'medium',
          'title': 'New Login from Unknown Device',
          'description':
              'A login attempt was made from a new device in Rabat, Morocco',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 3))
              .toIso8601String(),
          'location': 'Rabat, Morocco',
          'ipAddress': '196.200.217.45',
          'deviceInfo': 'Samsung Galaxy S21 - Chrome Mobile',
          'action': 'blocked',
          'isRead': false,
          'isResolved': false,
        },
        {
          'id': 'alert_002',
          'type': 'password_expiry',
          'severity': 'low',
          'title': 'Password Expiring Soon',
          'description':
              'Your password will expire in 15 days. Please update it to maintain security.',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'location': null,
          'ipAddress': null,
          'deviceInfo': null,
          'action': 'reminder',
          'isRead': false,
          'isResolved': false,
          'expiryDate':
              DateTime.now().add(const Duration(days: 15)).toIso8601String(),
        },
        {
          'id': 'alert_003',
          'type': 'security_update',
          'severity': 'info',
          'title': 'Security Feature Updated',
          'description':
              'Two-factor authentication settings have been updated successfully.',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'location': null,
          'ipAddress': null,
          'deviceInfo': null,
          'action': 'updated',
          'isRead': true,
          'isResolved': true,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load security alerts: $e');
      return false;
    }
  }

  // Load Login History
  Future<bool> _loadLoginHistory(String clientId) async {
    try {
      _loginHistory = [
        {
          'id': 'login_001',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'location': 'Casablanca, Morocco',
          'ipAddress': '41.248.100.23',
          'deviceInfo': 'iPhone 14 Pro - Safari',
          'status': 'success',
          'method': 'password',
          'userAgent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)',
          'sessionDuration': '2h 15m',
          'isCurrentSession': true,
        },
        {
          'id': 'login_002',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 8))
              .toIso8601String(),
          'location': 'Casablanca, Morocco',
          'ipAddress': '41.248.100.23',
          'deviceInfo': 'iPhone 14 Pro - Safari',
          'status': 'success',
          'method': 'biometric',
          'userAgent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)',
          'sessionDuration': '4h 30m',
          'isCurrentSession': false,
        },
        {
          'id': 'login_003',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'location': 'Casablanca, Morocco',
          'ipAddress': '41.248.100.23',
          'deviceInfo': 'Windows PC - Chrome',
          'status': 'success',
          'method': 'password + 2FA',
          'userAgent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'sessionDuration': '6h 45m',
          'isCurrentSession': false,
        },
        {
          'id': 'login_004',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'location': 'Rabat, Morocco',
          'ipAddress': '196.200.217.45',
          'deviceInfo': 'Samsung Galaxy S21 - Chrome Mobile',
          'status': 'failed',
          'method': 'password',
          'userAgent': 'Mozilla/5.0 (Linux; Android 12; SM-G991B)',
          'sessionDuration': null,
          'isCurrentSession': false,
          'failureReason': 'incorrect_password',
        },
        {
          'id': 'login_005',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'location': 'Casablanca, Morocco',
          'ipAddress': '41.248.100.23',
          'deviceInfo': 'iPhone 14 Pro - MultiSales App',
          'status': 'success',
          'method': 'biometric',
          'userAgent': 'MultiSales-iOS/1.0.0',
          'sessionDuration': '3h 20m',
          'isCurrentSession': false,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load login history: $e');
      return false;
    }
  }

  // Load Active Devices
  Future<bool> _loadActiveDevices(String clientId) async {
    try {
      _activeDevices = [
        {
          'id': 'device_001',
          'name': 'iPhone 14 Pro',
          'type': 'mobile',
          'os': 'iOS 16.0',
          'browser': 'Safari',
          'location': 'Casablanca, Morocco',
          'ipAddress': '41.248.100.23',
          'lastActive': DateTime.now()
              .subtract(const Duration(minutes: 5))
              .toIso8601String(),
          'firstSeen': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'isCurrentDevice': true,
          'isTrusted': true,
          'loginCount': 45,
          'sessionId': 'sess_current_001',
        },
        {
          'id': 'device_002',
          'name': 'Windows PC',
          'type': 'desktop',
          'os': 'Windows 11',
          'browser': 'Chrome 115',
          'location': 'Casablanca, Morocco',
          'ipAddress': '41.248.100.23',
          'lastActive': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'firstSeen': DateTime.now()
              .subtract(const Duration(days: 60))
              .toIso8601String(),
          'isCurrentDevice': false,
          'isTrusted': true,
          'loginCount': 23,
          'sessionId': null,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load active devices: $e');
      return false;
    }
  }

  // Load Trusted Devices
  Future<bool> _loadTrustedDevices(String clientId) async {
    try {
      _trustedDevices = [
        {
          'id': 'trusted_001',
          'deviceId': 'device_001',
          'name': 'iPhone 14 Pro',
          'fingerprint': 'fp_abc123def456',
          'dateAdded': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'lastUsed': DateTime.now()
              .subtract(const Duration(minutes: 5))
              .toIso8601String(),
          'isActive': true,
        },
        {
          'id': 'trusted_002',
          'deviceId': 'device_002',
          'name': 'Windows PC',
          'fingerprint': 'fp_xyz789uvw012',
          'dateAdded': DateTime.now()
              .subtract(const Duration(days: 60))
              .toIso8601String(),
          'lastUsed': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'isActive': true,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load trusted devices: $e');
      return false;
    }
  }

  // Load Password Policy
  Future<bool> _loadPasswordPolicy() async {
    try {
      _passwordPolicy = {
        'minLength': 8,
        'maxLength': 128,
        'requireUppercase': true,
        'requireLowercase': true,
        'requireNumbers': true,
        'requireSpecialChars': true,
        'preventCommonPasswords': true,
        'preventPersonalInfo': true,
        'expiryDays': 90,
        'historyCount': 5,
        'complexity': 'medium', // low, medium, high
      };

      _lastPasswordChange = DateTime.now().subtract(const Duration(days: 75));
      _passwordExpirySoon =
          DateTime.now().difference(_lastPasswordChange!).inDays > 75;

      return true;
    } catch (e) {
      _setError('Failed to load password policy: $e');
      return false;
    }
  }

  // Calculate Security Score
  Future<bool> _calculateSecurityScore() async {
    try {
      double score = 0.0;

      // Base security features (40 points)
      if (_emailVerificationEnabled) score += 10;
      if (_twoFactorEnabled) score += 15;
      if (_biometricEnabled) score += 10;
      if (_trustedDevices.isNotEmpty) score += 5;

      // Password security (25 points)
      if (_lastPasswordChange != null) {
        final daysSinceChange =
            DateTime.now().difference(_lastPasswordChange!).inDays;
        if (daysSinceChange < 30) {
          score += 15;
        } else if (daysSinceChange < 60)
          score += 10;
        else if (daysSinceChange < 90) score += 5;
      }
      score += 10; // Strong password policy

      // Account activity (20 points)
      final recentLogins = _loginHistory.where((login) {
        final loginDate = DateTime.parse(login['timestamp']);
        return DateTime.now().difference(loginDate).inDays <= 30;
      }).length;

      if (recentLogins > 0 && recentLogins <= 10)
        score += 15;
      else if (recentLogins <= 20)
        score += 10;
      else
        score += 5;

      score += 5; // Regular security checks

      // Risk factors (15 points)
      final failedLogins =
          _loginHistory.where((login) => login['status'] == 'failed').length;
      if (failedLogins == 0)
        score += 10;
      else if (failedLogins <= 2) score += 5;

      if (_securityAlerts
          .where((alert) => alert['severity'] == 'high' && !alert['isResolved'])
          .isEmpty) {
        score += 5;
      }

      _securityScore = score.clamp(0.0, 100.0);

      // Generate recommendations
      _generateSecurityRecommendations();

      return true;
    } catch (e) {
      _setError('Failed to calculate security score: $e');
      return false;
    }
  }

  // Generate Security Recommendations
  void _generateSecurityRecommendations() {
    _securityRecommendations.clear();

    if (!_twoFactorEnabled) {
      _securityRecommendations.add({
        'id': 'rec_2fa',
        'title': 'Enable Two-Factor Authentication',
        'description': 'Add an extra layer of security to your account',
        'priority': 'high',
        'impact': 15,
        'action': 'enable_2fa',
      });
    }

    if (!_biometricEnabled && _securityScore < 80) {
      _securityRecommendations.add({
        'id': 'rec_biometric',
        'title': 'Enable Biometric Authentication',
        'description':
            'Use fingerprint or face recognition for quick, secure access',
        'priority': 'medium',
        'impact': 10,
        'action': 'enable_biometric',
      });
    }

    if (_passwordExpirySoon) {
      _securityRecommendations.add({
        'id': 'rec_password',
        'title': 'Update Your Password',
        'description':
            'Your password is expiring soon. Update it to maintain security',
        'priority': 'high',
        'impact': 10,
        'action': 'change_password',
      });
    }

    final untrustedDevices =
        _activeDevices.where((device) => !device['isTrusted']).length;
    if (untrustedDevices > 0) {
      _securityRecommendations.add({
        'id': 'rec_devices',
        'title': 'Review Device Access',
        'description':
            'You have $untrustedDevices untrusted device(s) with access',
        'priority': 'medium',
        'impact': 8,
        'action': 'review_devices',
      });
    }

    final unresolvedAlerts =
        _securityAlerts.where((alert) => !alert['isResolved']).length;
    if (unresolvedAlerts > 0) {
      _securityRecommendations.add({
        'id': 'rec_alerts',
        'title': 'Resolve Security Alerts',
        'description':
            'You have $unresolvedAlerts unresolved security alert(s)',
        'priority': 'high',
        'impact': 12,
        'action': 'resolve_alerts',
      });
    }
  }

  // Enable Two-Factor Authentication
  Future<bool> enableTwoFactor(String method, String verificationCode) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      // Simulate verification
      if (verificationCode != '123456') {
        _setError('Invalid verification code');
        _setLoading(false);
        return false;
      }

      _twoFactorEnabled = true;

      // Add security alert
      _securityAlerts.insert(0, {
        'id': 'alert_${DateTime.now().millisecondsSinceEpoch}',
        'type': 'security_update',
        'severity': 'info',
        'title': 'Two-Factor Authentication Enabled',
        'description':
            'Two-factor authentication has been successfully enabled for your account',
        'timestamp': DateTime.now().toIso8601String(),
        'location': null,
        'ipAddress': null,
        'deviceInfo': null,
        'action': 'enabled',
        'isRead': false,
        'isResolved': true,
      });

      // Recalculate security score
      await _calculateSecurityScore();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to enable two-factor authentication: $e');
      _setLoading(false);
      return false;
    }
  }

  // Disable Two-Factor Authentication
  Future<bool> disableTwoFactor(String password) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate password verification
      if (password.isEmpty) {
        _setError('Password is required to disable 2FA');
        _setLoading(false);
        return false;
      }

      _twoFactorEnabled = false;

      // Add security alert
      _securityAlerts.insert(0, {
        'id': 'alert_${DateTime.now().millisecondsSinceEpoch}',
        'type': 'security_update',
        'severity': 'warning',
        'title': 'Two-Factor Authentication Disabled',
        'description':
            'Two-factor authentication has been disabled for your account',
        'timestamp': DateTime.now().toIso8601String(),
        'location': null,
        'ipAddress': null,
        'deviceInfo': null,
        'action': 'disabled',
        'isRead': false,
        'isResolved': true,
      });

      // Recalculate security score
      await _calculateSecurityScore();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to disable two-factor authentication: $e');
      _setLoading(false);
      return false;
    }
  }

  // Add Trusted Device
  Future<bool> addTrustedDevice(String deviceId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final device = _activeDevices.firstWhere(
        (d) => d['id'] == deviceId,
        orElse: () => {},
      );

      if (device.isEmpty) {
        _setError('Device not found');
        _setLoading(false);
        return false;
      }

      // Check if already trusted
      if (_trustedDevices.any((td) => td['deviceId'] == deviceId)) {
        _setError('Device is already trusted');
        _setLoading(false);
        return false;
      }

      _trustedDevices.add({
        'id': 'trusted_${DateTime.now().millisecondsSinceEpoch}',
        'deviceId': deviceId,
        'name': device['name'],
        'fingerprint': 'fp_${DateTime.now().millisecondsSinceEpoch}',
        'dateAdded': DateTime.now().toIso8601String(),
        'lastUsed': DateTime.now().toIso8601String(),
        'isActive': true,
      });

      // Update device status
      final deviceIndex = _activeDevices.indexWhere((d) => d['id'] == deviceId);
      if (deviceIndex != -1) {
        _activeDevices[deviceIndex]['isTrusted'] = true;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to add trusted device: $e');
      _setLoading(false);
      return false;
    }
  }

  // Remove Trusted Device
  Future<bool> removeTrustedDevice(String trustedDeviceId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final trustedDeviceIndex =
          _trustedDevices.indexWhere((td) => td['id'] == trustedDeviceId);

      if (trustedDeviceIndex == -1) {
        _setError('Trusted device not found');
        _setLoading(false);
        return false;
      }

      final deviceId = _trustedDevices[trustedDeviceIndex]['deviceId'];
      _trustedDevices.removeAt(trustedDeviceIndex);

      // Update device status
      final deviceIndex = _activeDevices.indexWhere((d) => d['id'] == deviceId);
      if (deviceIndex != -1) {
        _activeDevices[deviceIndex]['isTrusted'] = false;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to remove trusted device: $e');
      _setLoading(false);
      return false;
    }
  }

  // Revoke Device Access
  Future<bool> revokeDeviceAccess(String deviceId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Remove from active devices
      _activeDevices.removeWhere((device) => device['id'] == deviceId);

      // Remove from trusted devices
      _trustedDevices.removeWhere((trusted) => trusted['deviceId'] == deviceId);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to revoke device access: $e');
      _setLoading(false);
      return false;
    }
  }

  // Mark Security Alert as Read
  void markAlertAsRead(String alertId) {
    final alertIndex =
        _securityAlerts.indexWhere((alert) => alert['id'] == alertId);
    if (alertIndex != -1) {
      _securityAlerts[alertIndex]['isRead'] = true;
      notifyListeners();
    }
  }

  // Resolve Security Alert
  Future<bool> resolveSecurityAlert(String alertId) async {
    try {
      final alertIndex =
          _securityAlerts.indexWhere((alert) => alert['id'] == alertId);
      if (alertIndex != -1) {
        _securityAlerts[alertIndex]['isResolved'] = true;
        _securityAlerts[alertIndex]['isRead'] = true;
        notifyListeners();

        // Recalculate security score
        await _calculateSecurityScore();
      }
      return true;
    } catch (e) {
      _setError('Failed to resolve security alert: $e');
      return false;
    }
  }

  // Get Security Summary
  Map<String, dynamic> getSecuritySummary() {
    return {
      'score': _securityScore,
      'level': _getSecurityLevel(_securityScore),
      'twoFactorEnabled': _twoFactorEnabled,
      'biometricEnabled': _biometricEnabled,
      'trustedDevices': _trustedDevices.length,
      'activeDevices': _activeDevices.length,
      'unresolvedAlerts':
          _securityAlerts.where((alert) => !alert['isResolved']).length,
      'recommendations': _securityRecommendations.length,
      'lastPasswordChange': _lastPasswordChange?.toIso8601String(),
      'passwordExpirySoon': _passwordExpirySoon,
    };
  }

  // Get Security Level
  String _getSecurityLevel(double score) {
    if (score >= 90) return 'excellent';
    if (score >= 75) return 'good';
    if (score >= 60) return 'fair';
    if (score >= 40) return 'poor';
    return 'critical';
  }

  // Get Unread Alerts Count
  int getUnreadAlertsCount() {
    return _securityAlerts.where((alert) => !alert['isRead']).length;
  }

  // Get High Priority Recommendations
  List<Map<String, dynamic>> getHighPriorityRecommendations() {
    return _securityRecommendations
        .where((rec) => rec['priority'] == 'high')
        .toList();
  }

  // Check Device Trust Status
  bool isDeviceTrusted(String deviceId) {
    return _trustedDevices.any(
        (trusted) => trusted['deviceId'] == deviceId && trusted['isActive']);
  }

  // Get Recent Login Activity (last 7 days)
  List<Map<String, dynamic>> getRecentLoginActivity() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return _loginHistory.where((login) {
      final loginDate = DateTime.parse(login['timestamp']);
      return loginDate.isAfter(sevenDaysAgo);
    }).toList();
  }
}
