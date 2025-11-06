import 'package:flutter/foundation.dart';

/// Offline Capabilities Provider for MultiSales Client App
/// Handles offline data synchronization, caching, and network connectivity
class OfflineProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Connectivity Status
  bool _isOnline = true;
  bool _isConnectedToWifi = false;
  bool _isMobileDataEnabled = true;
  String _connectionType = 'wifi'; // wifi, mobile, none
  String _networkQuality = 'excellent'; // poor, fair, good, excellent

  // Offline Settings
  bool _offlineModeEnabled = true;
  bool _autoSyncEnabled = true;
  bool _syncOnWifiOnly = false;
  final int _maxOfflineDataAge = 7; // days
  double _maxCacheSize = 500.0; // MB

  // Cached Data
  List<Map<String, dynamic>> _cachedServices = [];
  List<Map<String, dynamic>> _cachedAppointments = [];
  List<Map<String, dynamic>> _cachedNotifications = [];
  List<Map<String, dynamic>> _cachedDocuments = [];
  Map<String, dynamic>? _cachedUserProfile;

  // Sync Status
  DateTime? _lastSyncDate;
  bool _isSyncing = false;
  Map<String, dynamic>? _syncProgress;
  List<Map<String, dynamic>> _pendingSync = [];
  List<Map<String, dynamic>> _syncHistory = [];

  // Data Usage
  Map<String, dynamic>? _dataUsageStats;
  bool _dataSaverMode = false;
  double _monthlyDataLimit = 5000.0; // MB
  double _currentDataUsage = 0.0; // MB

  // Cache Management
  Map<String, dynamic>? _cacheStats;
  List<Map<String, dynamic>> _cacheCategories = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;
  bool get isConnectedToWifi => _isConnectedToWifi;
  bool get isMobileDataEnabled => _isMobileDataEnabled;
  String get connectionType => _connectionType;
  String get networkQuality => _networkQuality;
  bool get offlineModeEnabled => _offlineModeEnabled;
  bool get autoSyncEnabled => _autoSyncEnabled;
  bool get syncOnWifiOnly => _syncOnWifiOnly;
  int get maxOfflineDataAge => _maxOfflineDataAge;
  double get maxCacheSize => _maxCacheSize;
  List<Map<String, dynamic>> get cachedServices => _cachedServices;
  List<Map<String, dynamic>> get cachedAppointments => _cachedAppointments;
  List<Map<String, dynamic>> get cachedNotifications => _cachedNotifications;
  List<Map<String, dynamic>> get cachedDocuments => _cachedDocuments;
  Map<String, dynamic>? get cachedUserProfile => _cachedUserProfile;
  DateTime? get lastSyncDate => _lastSyncDate;
  bool get isSyncing => _isSyncing;
  Map<String, dynamic>? get syncProgress => _syncProgress;
  List<Map<String, dynamic>> get pendingSync => _pendingSync;
  List<Map<String, dynamic>> get syncHistory => _syncHistory;
  Map<String, dynamic>? get dataUsageStats => _dataUsageStats;
  bool get dataSaverMode => _dataSaverMode;
  double get monthlyDataLimit => _monthlyDataLimit;
  double get currentDataUsage => _currentDataUsage;
  Map<String, dynamic>? get cacheStats => _cacheStats;
  List<Map<String, dynamic>> get cacheCategories => _cacheCategories;

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

  // Initialize Offline System
  Future<bool> initializeOfflineSystem(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      await Future.wait([
        _checkConnectivity(),
        _loadCachedData(clientId),
        _loadSyncHistory(),
        _loadDataUsageStats(),
        _loadCacheStats(),
        _initializeCacheCategories(),
      ]);

      // Start connectivity monitoring
      _startConnectivityMonitoring();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize offline system: $e');
      _setLoading(false);
      return false;
    }
  }

  // Check Connectivity
  Future<bool> _checkConnectivity() async {
    try {
      // Simulate connectivity check
      await Future.delayed(const Duration(milliseconds: 200));

      _isOnline = true;
      _isConnectedToWifi = true;
      _isMobileDataEnabled = true;
      _connectionType = 'wifi';
      _networkQuality = 'excellent';

      return true;
    } catch (e) {
      _setError('Failed to check connectivity: $e');
      return false;
    }
  }

  // Start Connectivity Monitoring
  void _startConnectivityMonitoring() {
    // In production, this would use connectivity_plus package
    // Simulate periodic connectivity checks
    Future.delayed(const Duration(seconds: 30), () {
      if (!_isLoading) {
        _checkConnectivity();
        _startConnectivityMonitoring();
      }
    });
  }

  // Load Cached Data
  Future<bool> _loadCachedData(String clientId) async {
    try {
      // Load cached services
      _cachedServices = [
        {
          'id': 'service_001',
          'type': 'mobile_plan',
          'name': 'Plan Mobile 50GB',
          'price': 299.0,
          'currency': 'MAD',
          'description': 'Plan mobile avec 50GB internet + appels illimités',
          'features': ['50GB Internet', 'Appels illimités', 'SMS illimités'],
          'cachedAt': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'isAvailable': true,
        },
        {
          'id': 'service_002',
          'type': 'fiber_internet',
          'name': 'Fibre Optique 100Mbps',
          'price': 399.0,
          'currency': 'MAD',
          'description': 'Internet fibre optique haute vitesse 100Mbps',
          'features': ['100Mbps', 'Installation gratuite', 'Wi-Fi inclus'],
          'cachedAt': DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
          'isAvailable': true,
        },
      ];

      // Load cached appointments
      _cachedAppointments = [
        {
          'id': 'appointment_001',
          'type': 'technical_visit',
          'date': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          'time': '10:00',
          'technician': 'Ahmed Benali',
          'service': 'Installation Fibre',
          'address': '123 Rue Mohammed V, Casablanca',
          'status': 'confirmed',
          'cachedAt': DateTime.now()
              .subtract(const Duration(minutes: 30))
              .toIso8601String(),
        },
        {
          'id': 'appointment_002',
          'type': 'agency_visit',
          'date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          'time': '14:30',
          'agency': 'Agence Maarif',
          'purpose': 'Contract Renewal',
          'address': 'Bd Zerktouni, Maarif, Casablanca',
          'status': 'pending',
          'cachedAt': DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
        },
      ];

      // Load cached notifications
      _cachedNotifications = [
        {
          'id': 'notif_001',
          'title': 'Nouvelle Offre Disponible',
          'body':
              'Découvrez notre nouvelle offre fibre optique avec 50% de réduction',
          'type': 'promotion',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 3))
              .toIso8601String(),
          'isRead': false,
          'cachedAt': DateTime.now()
              .subtract(const Duration(hours: 3))
              .toIso8601String(),
        },
        {
          'id': 'notif_002',
          'title': 'Rappel Rendez-vous',
          'body': 'Votre rendez-vous technique est prévu demain à 10h00',
          'type': 'appointment_reminder',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
          'isRead': true,
          'cachedAt': DateTime.now()
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
        },
      ];

      // Load cached documents
      _cachedDocuments = [
        {
          'id': 'doc_001',
          'name': 'Facture_Janvier_2024.pdf',
          'type': 'invoice',
          'size': '245 KB',
          'date': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'localPath': '/cache/documents/invoice_jan_2024.pdf',
          'isDownloaded': true,
          'cachedAt': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
        },
        {
          'id': 'doc_002',
          'name': 'Contrat_Service_Mobile.pdf',
          'type': 'contract',
          'size': '1.2 MB',
          'date': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'localPath': '/cache/documents/mobile_contract.pdf',
          'isDownloaded': true,
          'cachedAt': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
        },
      ];

      // Load cached user profile
      _cachedUserProfile = {
        'id': clientId,
        'firstName': 'Youssef',
        'lastName': 'Alami',
        'email': 'youssef.alami@example.com',
        'phone': '+212 6 12 34 56 78',
        'address': '123 Rue Mohammed V, Casablanca',
        'services': ['Mobile Plan', 'Fiber Internet'],
        'accountType': 'premium',
        'cachedAt':
            DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      };

      return true;
    } catch (e) {
      _setError('Failed to load cached data: $e');
      return false;
    }
  }

  // Load Sync History
  Future<bool> _loadSyncHistory() async {
    try {
      _syncHistory = [
        {
          'id': 'sync_001',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'type': 'full_sync',
          'status': 'completed',
          'duration': 45000, // milliseconds
          'itemsSynced': 28,
          'dataTransferred': 2.5, // MB
          'errors': [],
        },
        {
          'id': 'sync_002',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 8))
              .toIso8601String(),
          'type': 'incremental_sync',
          'status': 'completed',
          'duration': 12000,
          'itemsSynced': 8,
          'dataTransferred': 0.8,
          'errors': [],
        },
        {
          'id': 'sync_003',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'type': 'full_sync',
          'status': 'failed',
          'duration': 8000,
          'itemsSynced': 0,
          'dataTransferred': 0.0,
          'errors': ['Network timeout', 'Server unavailable'],
        },
      ];

      _lastSyncDate = DateTime.now().subtract(const Duration(hours: 2));

      // Load pending sync items
      _pendingSync = [
        {
          'id': 'pending_001',
          'type': 'appointment_booking',
          'data': {
            'appointmentId': 'appointment_003',
            'date':
                DateTime.now().add(const Duration(days: 3)).toIso8601String(),
            'time': '15:00',
            'type': 'technical_visit',
          },
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 15))
              .toIso8601String(),
          'retryCount': 0,
          'maxRetries': 3,
        },
        {
          'id': 'pending_002',
          'type': 'profile_update',
          'data': {
            'field': 'phone',
            'value': '+212 6 98 76 54 32',
          },
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 30))
              .toIso8601String(),
          'retryCount': 1,
          'maxRetries': 3,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load sync history: $e');
      return false;
    }
  }

  // Load Data Usage Stats
  Future<bool> _loadDataUsageStats() async {
    try {
      _dataUsageStats = {
        'currentMonth': {
          'total': 2450.5, // MB
          'byCategory': {
            'services': 850.2,
            'appointments': 245.8,
            'documents': 1200.5,
            'media': 154.0,
          },
          'byDay': {
            '2024-01-01': 45.2,
            '2024-01-02': 78.9,
            '2024-01-03': 123.4,
            // ... more days
          },
        },
        'previousMonth': {
          'total': 3200.8,
          'byCategory': {
            'services': 1200.5,
            'appointments': 350.2,
            'documents': 1500.1,
            'media': 150.0,
          },
        },
        'yearToDate': {
          'total': 25450.3,
          'average': 2545.0,
          'peak': 4200.5,
          'savings': 1200.0, // Data saved through offline mode
        },
      };

      _currentDataUsage = _dataUsageStats!['currentMonth']['total'];

      return true;
    } catch (e) {
      _setError('Failed to load data usage stats: $e');
      return false;
    }
  }

  // Load Cache Stats
  Future<bool> _loadCacheStats() async {
    try {
      _cacheStats = {
        'totalSize': 145.8, // MB
        'maxSize': _maxCacheSize,
        'usagePercentage': (145.8 / _maxCacheSize) * 100,
        'itemCount': 156,
        'categories': {
          'services': {'size': 45.2, 'count': 25},
          'appointments': {'size': 12.5, 'count': 18},
          'notifications': {'size': 8.9, 'count': 45},
          'documents': {'size': 67.8, 'count': 12},
          'profiles': {'size': 2.4, 'count': 1},
          'media': {'size': 9.0, 'count': 55},
        },
        'oldestItem':
            DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
        'newestItem': DateTime.now()
            .subtract(const Duration(minutes: 15))
            .toIso8601String(),
        'hitRate': 85.4, // Cache hit percentage
        'efficiency': 92.1, // Cache efficiency score
      };

      return true;
    } catch (e) {
      _setError('Failed to load cache stats: $e');
      return false;
    }
  }

  // Initialize Cache Categories
  Future<bool> _initializeCacheCategories() async {
    try {
      _cacheCategories = [
        {
          'id': 'services',
          'name': 'Services & Offers',
          'enabled': true,
          'maxAge': 24, // hours
          'maxSize': 100.0, // MB
          'priority': 'high',
          'autoCleanup': true,
        },
        {
          'id': 'appointments',
          'name': 'Appointments',
          'enabled': true,
          'maxAge': 168, // 7 days
          'maxSize': 50.0,
          'priority': 'high',
          'autoCleanup': false,
        },
        {
          'id': 'notifications',
          'name': 'Notifications',
          'enabled': true,
          'maxAge': 720, // 30 days
          'maxSize': 25.0,
          'priority': 'medium',
          'autoCleanup': true,
        },
        {
          'id': 'documents',
          'name': 'Documents',
          'enabled': true,
          'maxAge': 2160, // 90 days
          'maxSize': 200.0,
          'priority': 'low',
          'autoCleanup': false,
        },
        {
          'id': 'profiles',
          'name': 'User Profiles',
          'enabled': true,
          'maxAge': 24,
          'maxSize': 10.0,
          'priority': 'high',
          'autoCleanup': false,
        },
        {
          'id': 'media',
          'name': 'Images & Media',
          'enabled': _dataSaverMode ? false : true,
          'maxAge': 168,
          'maxSize': 100.0,
          'priority': 'low',
          'autoCleanup': true,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to initialize cache categories: $e');
      return false;
    }
  }

  // Sync Data
  Future<bool> syncData({bool forceSync = false}) async {
    if (_isSyncing) return false;

    _isSyncing = true;
    _setError(null);

    try {
      // Check if sync conditions are met
      if (!forceSync && !_canSync()) {
        _isSyncing = false;
        return false;
      }

      _syncProgress = {
        'stage': 'preparing',
        'percentage': 0.0,
        'currentItem': null,
        'totalItems': _pendingSync.length + 4, // Base sync items
        'processedItems': 0,
        'startTime': DateTime.now().toIso8601String(),
      };
      notifyListeners();

      // Stage 1: Upload pending changes
      await _syncPendingItems();

      // Stage 2: Download user profile
      await _syncUserProfile();

      // Stage 3: Download services
      await _syncServices();

      // Stage 4: Download appointments
      await _syncAppointments();

      // Stage 5: Download notifications
      await _syncNotifications();

      // Complete sync
      _syncProgress!['stage'] = 'completed';
      _syncProgress!['percentage'] = 100.0;
      _syncProgress!['endTime'] = DateTime.now().toIso8601String();

      _lastSyncDate = DateTime.now();

      // Add to sync history
      _syncHistory.insert(0, {
        'id': 'sync_${DateTime.now().millisecondsSinceEpoch}',
        'timestamp': DateTime.now().toIso8601String(),
        'type': forceSync ? 'manual_sync' : 'auto_sync',
        'status': 'completed',
        'duration': DateTime.now()
            .difference(DateTime.parse(_syncProgress!['startTime']))
            .inMilliseconds,
        'itemsSynced': _syncProgress!['processedItems'],
        'dataTransferred': 1.5, // Simulated
        'errors': [],
      });

      _isSyncing = false;
      _syncProgress = null;
      notifyListeners();

      return true;
    } catch (e) {
      _isSyncing = false;
      _syncProgress = null;
      _setError('Sync failed: $e');

      // Add failed sync to history
      _syncHistory.insert(0, {
        'id': 'sync_${DateTime.now().millisecondsSinceEpoch}',
        'timestamp': DateTime.now().toIso8601String(),
        'type': forceSync ? 'manual_sync' : 'auto_sync',
        'status': 'failed',
        'duration': 0,
        'itemsSynced': 0,
        'dataTransferred': 0.0,
        'errors': [e.toString()],
      });

      return false;
    }
  }

  // Check if sync can proceed
  bool _canSync() {
    if (!_isOnline) return false;
    if (_syncOnWifiOnly && !_isConnectedToWifi) return false;
    if (_dataSaverMode && _currentDataUsage > _monthlyDataLimit * 0.9) {
      return false;
    }

    return true;
  }

  // Sync Pending Items
  Future<void> _syncPendingItems() async {
    _syncProgress!['stage'] = 'uploading_changes';

    final itemsToSync = List.from(_pendingSync);

    for (int i = 0; i < itemsToSync.length; i++) {
      final item = itemsToSync[i];

      _syncProgress!['currentItem'] = item['type'];
      _syncProgress!['processedItems'] = i + 1;
      _syncProgress!['percentage'] =
          ((i + 1) / _syncProgress!['totalItems']) * 100;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 300));

      // Remove synced item
      _pendingSync.removeWhere((pending) => pending['id'] == item['id']);
    }
  }

  // Sync User Profile
  Future<void> _syncUserProfile() async {
    _syncProgress!['stage'] = 'downloading_profile';
    _syncProgress!['currentItem'] = 'User Profile';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Update cached profile with latest data
    _cachedUserProfile!['cachedAt'] = DateTime.now().toIso8601String();

    _syncProgress!['processedItems'] = _syncProgress!['processedItems'] + 1;
    _syncProgress!['percentage'] =
        (_syncProgress!['processedItems'] / _syncProgress!['totalItems']) * 100;
    notifyListeners();
  }

  // Sync Services
  Future<void> _syncServices() async {
    _syncProgress!['stage'] = 'downloading_services';
    _syncProgress!['currentItem'] = 'Services & Offers';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    // Update cached services
    for (var service in _cachedServices) {
      service['cachedAt'] = DateTime.now().toIso8601String();
    }

    _syncProgress!['processedItems'] = _syncProgress!['processedItems'] + 1;
    _syncProgress!['percentage'] =
        (_syncProgress!['processedItems'] / _syncProgress!['totalItems']) * 100;
    notifyListeners();
  }

  // Sync Appointments
  Future<void> _syncAppointments() async {
    _syncProgress!['stage'] = 'downloading_appointments';
    _syncProgress!['currentItem'] = 'Appointments';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    // Update cached appointments
    for (var appointment in _cachedAppointments) {
      appointment['cachedAt'] = DateTime.now().toIso8601String();
    }

    _syncProgress!['processedItems'] = _syncProgress!['processedItems'] + 1;
    _syncProgress!['percentage'] =
        (_syncProgress!['processedItems'] / _syncProgress!['totalItems']) * 100;
    notifyListeners();
  }

  // Sync Notifications
  Future<void> _syncNotifications() async {
    _syncProgress!['stage'] = 'downloading_notifications';
    _syncProgress!['currentItem'] = 'Notifications';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    // Update cached notifications
    for (var notification in _cachedNotifications) {
      notification['cachedAt'] = DateTime.now().toIso8601String();
    }

    _syncProgress!['processedItems'] = _syncProgress!['processedItems'] + 1;
    _syncProgress!['percentage'] =
        (_syncProgress!['processedItems'] / _syncProgress!['totalItems']) * 100;
    notifyListeners();
  }

  // Clear Cache
  Future<bool> clearCache({String? category}) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      if (category == null) {
        // Clear all cache
        _cachedServices.clear();
        _cachedAppointments.clear();
        _cachedNotifications.clear();
        _cachedDocuments.clear();
        _cachedUserProfile = null;
      } else {
        // Clear specific category
        switch (category) {
          case 'services':
            _cachedServices.clear();
            break;
          case 'appointments':
            _cachedAppointments.clear();
            break;
          case 'notifications':
            _cachedNotifications.clear();
            break;
          case 'documents':
            _cachedDocuments.clear();
            break;
          case 'profiles':
            _cachedUserProfile = null;
            break;
        }
      }

      // Update cache stats
      await _loadCacheStats();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to clear cache: $e');
      _setLoading(false);
      return false;
    }
  }

  // Add to Pending Sync
  void addToPendingSync(String type, Map<String, dynamic> data) {
    _pendingSync.add({
      'id': 'pending_${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'retryCount': 0,
      'maxRetries': 3,
    });
    notifyListeners();
  }

  // Enable/Disable Offline Mode
  void setOfflineModeEnabled(bool enabled) {
    _offlineModeEnabled = enabled;
    notifyListeners();
  }

  // Enable/Disable Auto Sync
  void setAutoSyncEnabled(bool enabled) {
    _autoSyncEnabled = enabled;
    notifyListeners();
  }

  // Set Sync on WiFi Only
  void setSyncOnWifiOnly(bool enabled) {
    _syncOnWifiOnly = enabled;
    notifyListeners();
  }

  // Enable/Disable Data Saver Mode
  void setDataSaverMode(bool enabled) {
    _dataSaverMode = enabled;

    // Update cache categories
    final mediaCategory =
        _cacheCategories.firstWhere((cat) => cat['id'] == 'media');
    mediaCategory['enabled'] = !enabled;

    notifyListeners();
  }

  // Set Max Cache Size
  void setMaxCacheSize(double sizeInMB) {
    _maxCacheSize = sizeInMB;
    notifyListeners();
  }

  // Set Monthly Data Limit
  void setMonthlyDataLimit(double limitInMB) {
    _monthlyDataLimit = limitInMB;
    notifyListeners();
  }

  // Get Offline Status
  Map<String, dynamic> getOfflineStatus() {
    return {
      'isOnline': _isOnline,
      'connectionType': _connectionType,
      'networkQuality': _networkQuality,
      'offlineModeEnabled': _offlineModeEnabled,
      'lastSyncDate': _lastSyncDate?.toIso8601String(),
      'pendingSyncCount': _pendingSync.length,
      'cacheSize': _cacheStats?['totalSize'] ?? 0.0,
      'cacheUsage': _cacheStats?['usagePercentage'] ?? 0.0,
      'dataSaverMode': _dataSaverMode,
      'dataUsage': _currentDataUsage,
      'dataLimit': _monthlyDataLimit,
    };
  }

  // Get Data Usage Summary
  Map<String, dynamic> getDataUsageSummary() {
    if (_dataUsageStats == null) return {};

    final currentMonth = _dataUsageStats!['currentMonth'];
    final usagePercentage = (_currentDataUsage / _monthlyDataLimit) * 100;

    return {
      'currentUsage': _currentDataUsage,
      'monthlyLimit': _monthlyDataLimit,
      'usagePercentage': usagePercentage,
      'remainingData': _monthlyDataLimit - _currentDataUsage,
      'byCategory': currentMonth['byCategory'],
      'isNearLimit': usagePercentage > 80,
      'isOverLimit': usagePercentage > 100,
      'estimatedDaysLeft': _calculateDaysLeft(),
    };
  }

  // Calculate Days Left
  int _calculateDaysLeft() {
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return endOfMonth.difference(now).inDays;
  }

  // Get Cache Summary
  Map<String, dynamic> getCacheSummary() {
    if (_cacheStats == null) return {};

    return {
      'totalSize': _cacheStats!['totalSize'],
      'maxSize': _maxCacheSize,
      'usagePercentage': _cacheStats!['usagePercentage'],
      'itemCount': _cacheStats!['itemCount'],
      'categories': _cacheStats!['categories'],
      'hitRate': _cacheStats!['hitRate'],
      'efficiency': _cacheStats!['efficiency'],
      'needsCleanup': _cacheStats!['usagePercentage'] > 80,
    };
  }

  // Update Cache Category Settings
  void updateCacheCategory(String categoryId, Map<String, dynamic> settings) {
    final categoryIndex =
        _cacheCategories.indexWhere((cat) => cat['id'] == categoryId);
    if (categoryIndex != -1) {
      _cacheCategories[categoryIndex] = {
        ..._cacheCategories[categoryIndex],
        ...settings
      };
      notifyListeners();
    }
  }

  // Get Recent Sync History
  List<Map<String, dynamic>> getRecentSyncHistory({int limit = 10}) {
    return _syncHistory.take(limit).toList();
  }

  // Check if data is stale
  bool isDataStale(String category) {
    final categorySettings = _cacheCategories.firstWhere(
      (cat) => cat['id'] == category,
      orElse: () => {'maxAge': 24},
    );

    final maxAgeHours = categorySettings['maxAge'] as int;
    final maxAge = Duration(hours: maxAgeHours);

    switch (category) {
      case 'services':
        if (_cachedServices.isEmpty) return true;
        final cachedAt = DateTime.parse(_cachedServices.first['cachedAt']);
        return DateTime.now().difference(cachedAt) > maxAge;
      case 'appointments':
        if (_cachedAppointments.isEmpty) return true;
        final cachedAt = DateTime.parse(_cachedAppointments.first['cachedAt']);
        return DateTime.now().difference(cachedAt) > maxAge;
      case 'profiles':
        if (_cachedUserProfile == null) return true;
        final cachedAt = DateTime.parse(_cachedUserProfile!['cachedAt']);
        return DateTime.now().difference(cachedAt) > maxAge;
      default:
        return true;
    }
  }
}
