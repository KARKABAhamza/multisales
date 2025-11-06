import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/location_model.dart';
import '../services/firestore_service.dart';

/// Location provider for MultiSales app
/// Manages GPS location, address lookup, and location-based services
class LocationProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Current location
  LocationModel? _currentLocation;
  String? _currentAddress;

  // Location history
  List<LocationModel> _locationHistory = [];
  List<String> _savedAddresses = [];

  // State management
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;
  bool _isLocationEnabled = false;
  bool _hasLocationPermission = false;

  // Settings
  bool _isLocationTrackingEnabled = false;
  bool _isAutoLocationEnabled = true;
  double _locationAccuracy = 100.0; // meters

  LocationProvider();

  // Getters
  LocationModel? get currentLocation => _currentLocation;
  String? get currentAddress => _currentAddress;
  List<LocationModel> get locationHistory => _locationHistory;
  List<String> get savedAddresses => _savedAddresses;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  bool get isLocationEnabled => _isLocationEnabled;
  bool get hasLocationPermission => _hasLocationPermission;

  bool get isLocationTrackingEnabled => _isLocationTrackingEnabled;
  bool get isAutoLocationEnabled => _isAutoLocationEnabled;
  double get locationAccuracy => _locationAccuracy;

  // Computed getters
  bool get canUseLocation => _isLocationEnabled && _hasLocationPermission;
  String get locationStatus {
    if (!_isLocationEnabled) return 'Location services disabled';
    if (!_hasLocationPermission) return 'Location permission denied';
    if (_currentLocation == null) return 'Location not available';
    return 'Location available';
  }

  /// Initialize location provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _setLoading(true);
      _clearError();

      await Future.wait([
        _checkLocationServices(),
        _loadSavedAddresses(),
        _loadLocationSettings(),
      ]);

      if (canUseLocation && _isAutoLocationEnabled) {
        await getCurrentLocation();
      }

      _isInitialized = true;
    } catch (e) {
      _setError('Failed to initialize location services: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Check location services and permissions
  Future<void> _checkLocationServices() async {
    try {
      // Check if location services are enabled (implementation)
      // final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      _isLocationEnabled = true; // Mock for now

      // Check location permissions (implementation)
      // final permission = await Geolocator.checkPermission();
      _hasLocationPermission = true; // Mock for now

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to check location services: $e');
    }
  }

  /// Get current location
  Future<LocationModel?> getCurrentLocation() async {
    if (!canUseLocation) {
      _setError('Location services not available');
      return null;
    }

    try {
      _setLoading(true);
      _clearError();

      // Get current position (implementation)
      // final position = await Geolocator.getCurrentPosition();

      // Mock location for now
      final mockLocation = LocationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        latitude: 25.2048, // Dubai coordinates
        longitude: 55.2708,
        accuracy: _locationAccuracy,
        timestamp: DateTime.now(),
      );

      _currentLocation = mockLocation;
      _addToLocationHistory(mockLocation);

      // Get address from coordinates
      await _updateCurrentAddress();

      notifyListeners();
      return _currentLocation;
    } catch (e) {
      _setError('Failed to get current location: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update current address from coordinates
  Future<void> _updateCurrentAddress() async {
    if (_currentLocation == null) return;

    try {
      // Reverse geocoding (implementation)
      // final placemarks = await placemarkFromCoordinates(
      //   _currentLocation!.latitude,
      //   _currentLocation!.longitude,
      // );

      // Mock address for now
      _currentAddress = 'Dubai Marina, Dubai, UAE';

      notifyListeners();
    } catch (e) {
      // Handle geocoding error silently
    }
  }

  /// Add location to history
  void _addToLocationHistory(LocationModel location) {
    _locationHistory.insert(0, location);

    // Keep only last 100 locations
    if (_locationHistory.length > 100) {
      _locationHistory = _locationHistory.take(100).toList();
    }

    // Save to Firestore asynchronously
    _saveLocationToHistory(location);
  }

  /// Save location to Firestore history
  Future<void> _saveLocationToHistory(LocationModel location) async {
    try {
      await _firestoreService.createDocument(
        collection: 'location_history',
        documentId: location.id,
        data: location.toMap(),
      );
    } catch (e) {
      debugPrint('Failed to save location to Firestore: $e');
    }
  }

  /// Search for locations/addresses
  Future<List<LocationSearchResult>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    try {
      _setLoading(true);
      _clearError();

      // Geocoding search (implementation)
      // final locations = await locationFromAddress(query);

      // Mock search results for now
      final results = _generateMockSearchResults(query);

      return results;
    } catch (e) {
      _setError('Failed to search locations: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  /// Get coordinates from address
  Future<LocationModel?> getLocationFromAddress(String address) async {
    try {
      // Geocoding (implementation)
      // final locations = await locationFromAddress(address);

      // Mock result for now
      final location = LocationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        latitude: 25.2048 + (DateTime.now().millisecond / 10000),
        longitude: 55.2708 + (DateTime.now().millisecond / 10000),
        accuracy: 50.0,
        timestamp: DateTime.now(),
        address: address,
      );

      return location;
    } catch (e) {
      _setError('Failed to get location from address: $e');
      return null;
    }
  }

  /// Calculate distance between two locations
  double calculateDistance(LocationModel location1, LocationModel location2) {
    // Haversine formula implementation (simplified)
    const double earthRadius = 6371; // km

    final lat1Rad = location1.latitude * (3.141592653589793 / 180);
    final lat2Rad = location2.latitude * (3.141592653589793 / 180);
    final deltaLatRad =
        (location2.latitude - location1.latitude) * (3.141592653589793 / 180);
    final deltaLonRad =
        (location2.longitude - location1.longitude) * (3.141592653589793 / 180);

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLonRad / 2) *
            sin(deltaLonRad / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Save address to favorites
  Future<void> saveAddress(String address) async {
    if (!_savedAddresses.contains(address)) {
      _savedAddresses.add(address);
      notifyListeners();

      // Save to Firestore
      try {
        await _firestoreService.createDocument(
          collection: 'saved_addresses',
          documentId: DateTime.now().millisecondsSinceEpoch.toString(),
          data: {
            'address': address,
            'createdAt': DateTime.now().toIso8601String(),
            'userId': 'anonymous_user_${DateTime.now().millisecondsSinceEpoch}',
          },
        );
      } catch (e) {
        debugPrint('Failed to save address to Firestore: $e');
      }
    }
  }

  /// Remove saved address
  Future<void> removeSavedAddress(String address) async {
    _savedAddresses.remove(address);
    notifyListeners();

    // Update persistent storage (implementation)
  }

  /// Update location settings
  Future<void> updateLocationSettings({
    bool? trackingEnabled,
    bool? autoLocationEnabled,
    double? accuracy,
  }) async {
    try {
      if (trackingEnabled != null) {
        _isLocationTrackingEnabled = trackingEnabled;
      }
      if (autoLocationEnabled != null) {
        _isAutoLocationEnabled = autoLocationEnabled;
      }
      if (accuracy != null) {
        _locationAccuracy = accuracy;
      }

      // Save settings to Firestore
      await _firestoreService.updateDocument(
        collection: 'user_settings',
        documentId: 'location_settings',
        data: {
          'trackingEnabled': _isLocationTrackingEnabled,
          'autoLocationEnabled': _isAutoLocationEnabled,
          'accuracy': _locationAccuracy,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to update location settings: $e');
    }
  }

  /// Request location permissions
  Future<bool> requestLocationPermission() async {
    try {
      // Request permission (implementation)
      // final permission = await Geolocator.requestPermission();

      _hasLocationPermission = true; // Mock for now
      notifyListeners();

      return _hasLocationPermission;
    } catch (e) {
      _setError('Failed to request location permission: $e');
      return false;
    }
  }

  /// Load saved addresses
  Future<void> _loadSavedAddresses() async {
    try {
      // Try to load from Firestore first
      final result =
          await _firestoreService.getCollection(collection: 'saved_addresses');
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> addressData = result['data'];
        _savedAddresses =
            addressData.map((data) => data['address'] as String).toList();
      } else {
        // Fall back to mock data if Firestore fails
        debugPrint(
            'Failed to load addresses from Firestore: ${result['error']}');
        _savedAddresses = [
          'Home',
          'Office',
          'Dubai Marina, Dubai, UAE',
          'Business Bay, Dubai, UAE',
        ];
      }
    } catch (e) {
      // Handle error silently and use mock data
      _savedAddresses = [
        'Home',
        'Office',
        'Dubai Marina, Dubai, UAE',
        'Business Bay, Dubai, UAE',
      ];
    }
  }

  /// Load location settings
  Future<void> _loadLocationSettings() async {
    try {
      // Try to load from Firestore first
      final result = await _firestoreService.getDocument(
        collection: 'user_settings',
        documentId: 'location_settings',
      );

      if (result['success'] == true && result['data'] != null) {
        final settings = result['data'] as Map<String, dynamic>;
        _isLocationTrackingEnabled = settings['trackingEnabled'] ?? false;
        _isAutoLocationEnabled = settings['autoLocationEnabled'] ?? true;
        _locationAccuracy = (settings['accuracy'] ?? 100.0).toDouble();
      } else {
        // Fall back to default settings
        _isLocationTrackingEnabled = false;
        _isAutoLocationEnabled = true;
        _locationAccuracy = 100.0;
      }
    } catch (e) {
      // Handle error silently and use defaults
      _isLocationTrackingEnabled = false;
      _isAutoLocationEnabled = true;
      _locationAccuracy = 100.0;
    }
  }

  /// Generate mock search results
  List<LocationSearchResult> _generateMockSearchResults(String query) {
    return [
      LocationSearchResult(
        id: '1',
        name: '$query - Main Location',
        address: '$query, Dubai, UAE',
        latitude: 25.2048,
        longitude: 55.2708,
        type: 'business',
      ),
      LocationSearchResult(
        id: '2',
        name: '$query - Branch Office',
        address: '$query Street, Abu Dhabi, UAE',
        latitude: 24.4539,
        longitude: 54.3773,
        type: 'office',
      ),
      LocationSearchResult(
        id: '3',
        name: '$query - Service Center',
        address: '$query Avenue, Sharjah, UAE',
        latitude: 25.3463,
        longitude: 55.4209,
        type: 'service',
      ),
    ];
  }

  /// Clear location history
  void clearLocationHistory() {
    _locationHistory.clear();
    notifyListeners();
  }

  /// Refresh current location
  Future<void> refresh() async {
    if (canUseLocation) {
      await getCurrentLocation();
    }
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _locationHistory.clear();
    _savedAddresses.clear();
    super.dispose();
  }
}

/// Location search result model
class LocationSearchResult {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type;

  LocationSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  LocationModel toLocationModel() {
    return LocationModel(
      id: id,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      address: address,
    );
  }
}
