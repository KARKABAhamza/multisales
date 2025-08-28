import 'package:flutter/foundation.dart';

/// Settings Provider for MultiSales Client App
/// Handles app settings, preferences, and configuration
class SettingsProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // App Settings
  Map<String, dynamic> _appSettings = {};
  Map<String, dynamic> _userPreferences = {};
  Map<String, dynamic> _notificationSettings = {};
  Map<String, dynamic> _privacySettings = {};
  Map<String, dynamic> _accessibilitySettings = {};
  Map<String, dynamic> _dataUsageSettings = {};

  // Theme and Display
  String _selectedTheme = 'system'; // light, dark, system
  String _selectedLanguage = 'en'; // en, fr, ar, es, de
  double _fontSize = 16.0;
  bool _highContrastMode = false;

  // Security Settings
  bool _biometricEnabled = false;
  bool _pinEnabled = false;
  int _sessionTimeout = 30; // minutes
  bool _twoFactorEnabled = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get appSettings => _appSettings;
  Map<String, dynamic> get userPreferences => _userPreferences;
  Map<String, dynamic> get notificationSettings => _notificationSettings;
  Map<String, dynamic> get privacySettings => _privacySettings;
  Map<String, dynamic> get accessibilitySettings => _accessibilitySettings;
  Map<String, dynamic> get dataUsageSettings => _dataUsageSettings;
  String get selectedTheme => _selectedTheme;
  String get selectedLanguage => _selectedLanguage;
  double get fontSize => _fontSize;
  bool get highContrastMode => _highContrastMode;
  bool get biometricEnabled => _biometricEnabled;
  bool get pinEnabled => _pinEnabled;
  int get sessionTimeout => _sessionTimeout;
  bool get twoFactorEnabled => _twoFactorEnabled;

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

  // Initialize Settings
  Future<bool> initializeSettings(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      await Future.wait([
        _loadAppSettings(),
        _loadUserPreferences(clientId),
        _loadNotificationSettings(),
        _loadPrivacySettings(),
        _loadAccessibilitySettings(),
        _loadDataUsageSettings(),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize settings: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load App Settings
  Future<bool> _loadAppSettings() async {
    try {
      _appSettings = {
        'appVersion': '1.0.0',
        'buildNumber': '1',
        'lastUpdated':
            DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'autoUpdate': true,
        'crashReporting': true,
        'analyticsEnabled': true,
        'debugMode': false,
        'serverUrl': 'https://api.multisales.ma',
        'apiVersion': 'v1',
        'supportedLanguages': ['en', 'fr', 'ar', 'es', 'de'],
        'defaultTheme': 'system',
        'maxFileUploadSize': 10485760, // 10MB
        'sessionTimeoutOptions': [15, 30, 60, 120], // minutes
        'supportEmail': 'support@multisales.ma',
        'supportPhone': '+212522123456',
        'termsOfServiceUrl': 'https://multisales.ma/terms',
        'privacyPolicyUrl': 'https://multisales.ma/privacy',
      };

      return true;
    } catch (e) {
      _setError('Failed to load app settings: $e');
      return false;
    }
  }

  // Load User Preferences
  Future<bool> _loadUserPreferences(String clientId) async {
    try {
      _userPreferences = {
        'clientId': clientId,
        'defaultDashboardView': 'overview', // overview, detailed, minimal
        'quickActionsEnabled': true,
        'showTutorialTips': true,
        'rememberLastScreen': true,
        'autoSaveFormData': true,
        'confirmBeforeDelete': true,
        'showConfirmationDialogs': true,
        'enableHapticFeedback': true,
        'soundEffectsEnabled': false,
        'animationsEnabled': true,
        'dateFormat': 'dd/MM/yyyy',
        'timeFormat': '24h', // 12h, 24h
        'currency': 'MAD',
        'numberFormat': 'european', // american, european
        'firstDayOfWeek': 'monday', // sunday, monday
        'weekendDays': ['saturday', 'sunday'],
        'workingHours': {
          'start': '08:00',
          'end': '18:00',
        },
        'shortcuts': {
          'quickPay': true,
          'speedTest': true,
          'supportChat': true,
          'usageCheck': false,
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load user preferences: $e');
      return false;
    }
  }

  // Load Notification Settings
  Future<bool> _loadNotificationSettings() async {
    try {
      _notificationSettings = {
        'pushNotifications': true,
        'emailNotifications': true,
        'smsNotifications': false,
        'whatsappNotifications': false,
        'inAppNotifications': true,
        'soundEnabled': true,
        'vibrationEnabled': true,
        'ledEnabled': false,
        'quietHoursEnabled': true,
        'weekendQuietMode': false,
        'groupNotifications': true,
        'priorityNotifications': true,
        'quietHours': {
          'start': '22:00',
          'end': '08:00',
        },
        'categories': {
          'billing': true,
          'technical': true,
          'promotional': false,
          'security': true,
          'appointments': true,
          'service_updates': true,
          'maintenance': true,
          'news': false,
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load notification settings: $e');
      return false;
    }
  }

  // Load Privacy Settings
  Future<bool> _loadPrivacySettings() async {
    try {
      _privacySettings = {
        'dataCollection': {
          'analytics': true,
          'crashReports': true,
          'usageStatistics': true,
          'personalizedAds': false,
          'locationTracking': false,
          'performanceData': true,
        },
        'dataSharing': {
          'thirdPartyAnalytics': false,
          'marketingPartners': false,
          'technicalSupport': true,
          'legalRequirements': true,
        },
        'dataRetention': {
          'accountData': 'until_deletion',
          'usageData': '2_years',
          'supportData': '1_year',
          'analyticsData': '6_months',
        },
        'cookies': {
          'essential': true,
          'analytics': true,
          'marketing': false,
          'preferences': true,
        },
        'profileVisibility': {
          'name': 'private',
          'email': 'private',
          'phone': 'private',
          'usageStats': 'private',
        },
        'contactPermissions': {
          'supportContact': true,
          'marketingContact': false,
          'surveyContact': true,
          'emergencyContact': true,
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load privacy settings: $e');
      return false;
    }
  }

  // Load Accessibility Settings
  Future<bool> _loadAccessibilitySettings() async {
    try {
      _accessibilitySettings = {
        'fontSize': _fontSize,
        'fontWeight': 'normal', // normal, bold
        'highContrast': _highContrastMode,
        'screenReader': false,
        'voiceOver': false,
        'largeButtons': false,
        'reducedMotion': false,
        'colorBlindSupport': false,
        'keyboardNavigation': false,
        'magnification': 1.0,
        'textToSpeech': false,
        'speechToText': false,
        'gestureAssistance': false,
        'autoScroll': false,
        'simplifiedInterface': false,
        'alternativeInputMethods': [],
      };

      return true;
    } catch (e) {
      _setError('Failed to load accessibility settings: $e');
      return false;
    }
  }

  // Load Data Usage Settings
  Future<bool> _loadDataUsageSettings() async {
    try {
      _dataUsageSettings = {
        'wifiOnlyUpdates': false,
        'autoDownloadImages': true,
        'autoDownloadVideos': false,
        'compressImages': true,
        'offlineMode': false,
        'syncFrequency': 'real_time', // real_time, hourly, daily, manual
        'backgroundSync': true,
        'dataWarningThreshold': 80, // percentage
        'dataSavingMode': false,
        'preloadContent': false,
        'cacheSize': 100, // MB
        'clearCacheOnExit': false,
        'downloadOnWifiOnly': true,
        'qualitySettings': {
          'images': 'high', // low, medium, high
          'videos': 'medium',
          'audio': 'high',
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load data usage settings: $e');
      return false;
    }
  }

  // Update Theme Setting
  Future<bool> updateTheme(String theme) async {
    if (!['light', 'dark', 'system'].contains(theme)) {
      _setError('Invalid theme selection');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _selectedTheme = theme;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update theme: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update Language Setting
  Future<bool> updateLanguage(String language) async {
    final supportedLanguages =
        _appSettings['supportedLanguages'] as List<String>;

    if (!supportedLanguages.contains(language)) {
      _setError('Language not supported');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _selectedLanguage = language;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update language: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update Font Size
  Future<bool> updateFontSize(double fontSize) async {
    if (fontSize < 12.0 || fontSize > 24.0) {
      _setError('Font size must be between 12 and 24');
      return false;
    }

    _fontSize = fontSize;
    _accessibilitySettings['fontSize'] = fontSize;
    notifyListeners();
    return true;
  }

  // Toggle High Contrast Mode
  Future<bool> toggleHighContrast(bool enabled) async {
    _highContrastMode = enabled;
    _accessibilitySettings['highContrast'] = enabled;
    notifyListeners();
    return true;
  }

  // Update Notification Settings
  Future<bool> updateNotificationSettings(Map<String, dynamic> settings) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      _notificationSettings = {..._notificationSettings, ...settings};
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update notification settings: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update Privacy Settings
  Future<bool> updatePrivacySettings(Map<String, dynamic> settings) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      _privacySettings = {..._privacySettings, ...settings};
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update privacy settings: $e');
      _setLoading(false);
      return false;
    }
  }

  // Enable/Disable Biometric Authentication
  Future<bool> toggleBiometric(bool enabled) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // In real implementation, check device biometric capability
      _biometricEnabled = enabled;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update biometric setting: $e');
      _setLoading(false);
      return false;
    }
  }

  // Enable/Disable PIN Authentication
  Future<bool> togglePin(bool enabled) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _pinEnabled = enabled;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update PIN setting: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update Session Timeout
  Future<bool> updateSessionTimeout(int minutes) async {
    final timeoutOptions = _appSettings['sessionTimeoutOptions'] as List<int>;

    if (!timeoutOptions.contains(minutes)) {
      _setError('Invalid session timeout value');
      return false;
    }

    _sessionTimeout = minutes;
    notifyListeners();
    return true;
  }

  // Toggle Two-Factor Authentication
  Future<bool> toggleTwoFactor(bool enabled) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      _twoFactorEnabled = enabled;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update two-factor authentication: $e');
      _setLoading(false);
      return false;
    }
  }

  // Reset Settings to Default
  Future<bool> resetToDefaults(String category) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      switch (category) {
        case 'all':
          await initializeSettings('client_123');
          break;
        case 'notifications':
          await _loadNotificationSettings();
          break;
        case 'privacy':
          await _loadPrivacySettings();
          break;
        case 'accessibility':
          await _loadAccessibilitySettings();
          break;
        case 'data_usage':
          await _loadDataUsageSettings();
          break;
        default:
          _setError('Invalid category for reset');
          _setLoading(false);
          return false;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to reset settings: $e');
      _setLoading(false);
      return false;
    }
  }

  // Export Settings
  Map<String, dynamic> exportSettings() {
    return {
      'appSettings': _appSettings,
      'userPreferences': _userPreferences,
      'notificationSettings': _notificationSettings,
      'privacySettings': _privacySettings,
      'accessibilitySettings': _accessibilitySettings,
      'dataUsageSettings': _dataUsageSettings,
      'theme': _selectedTheme,
      'language': _selectedLanguage,
      'fontSize': _fontSize,
      'highContrast': _highContrastMode,
      'biometric': _biometricEnabled,
      'pin': _pinEnabled,
      'sessionTimeout': _sessionTimeout,
      'twoFactor': _twoFactorEnabled,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Import Settings
  Future<bool> importSettings(Map<String, dynamic> settings) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      if (settings.containsKey('userPreferences')) {
        _userPreferences = settings['userPreferences'];
      }
      if (settings.containsKey('notificationSettings')) {
        _notificationSettings =
            Map<String, bool>.from(settings['notificationSettings']);
      }
      if (settings.containsKey('privacySettings')) {
        _privacySettings = settings['privacySettings'];
      }
      if (settings.containsKey('accessibilitySettings')) {
        _accessibilitySettings = settings['accessibilitySettings'];
      }
      if (settings.containsKey('dataUsageSettings')) {
        _dataUsageSettings = settings['dataUsageSettings'];
      }
      if (settings.containsKey('theme')) _selectedTheme = settings['theme'];
      if (settings.containsKey('language')) {
        _selectedLanguage = settings['language'];
      }
      if (settings.containsKey('fontSize')) _fontSize = settings['fontSize'];
      if (settings.containsKey('highContrast')) {
        _highContrastMode = settings['highContrast'];
      }
      if (settings.containsKey('biometric')) {
        _biometricEnabled = settings['biometric'];
      }
      if (settings.containsKey('pin')) _pinEnabled = settings['pin'];
      if (settings.containsKey('sessionTimeout')) {
        _sessionTimeout = settings['sessionTimeout'];
      }
      if (settings.containsKey('twoFactor')) {
        _twoFactorEnabled = settings['twoFactor'];
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to import settings: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get Settings Summary
  Map<String, dynamic> getSettingsSummary() {
    return {
      'theme': _selectedTheme,
      'language': _selectedLanguage,
      'notifications': _notificationSettings['pushNotifications'] ?? false,
      'biometric': _biometricEnabled,
      'twoFactor': _twoFactorEnabled,
      'highContrast': _highContrastMode,
      'dataUsage': _dataUsageSettings['dataSavingMode'] ?? false,
      'privacy': _privacySettings['dataCollection']['analytics'] ?? false,
    };
  }

  // Check if specific permission is granted
  bool hasPermission(String permission) {
    switch (permission) {
      case 'notifications':
        return _notificationSettings['pushNotifications'] ?? false;
      case 'location':
        return _privacySettings['dataCollection']['locationTracking'] ?? false;
      case 'analytics':
        return _privacySettings['dataCollection']['analytics'] ?? false;
      case 'biometric':
        return _biometricEnabled;
      default:
        return false;
    }
  }

  // Clear All Data
  Future<bool> clearAllData() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Reset all settings to defaults
      _selectedTheme = 'system';
      _selectedLanguage = 'en';
      _fontSize = 16.0;
      _highContrastMode = false;
      _biometricEnabled = false;
      _pinEnabled = false;
      _sessionTimeout = 30;
      _twoFactorEnabled = false;

      // Reload default settings
      await initializeSettings('client_123');

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to clear all data: $e');
      _setLoading(false);
      return false;
    }
  }
}
