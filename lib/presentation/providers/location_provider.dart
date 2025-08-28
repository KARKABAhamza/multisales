import 'package:flutter/foundation.dart';
import 'dart:math' show cos, asin, sqrt, pi;

/// Location Provider for MultiSales Client App
/// Handles location services, agency finder, technician tracking, and navigation
class LocationProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, double>? _currentLocation;
  List<Map<String, dynamic>> _nearbyAgencies = [];
  List<Map<String, dynamic>> _technicianLocations = [];
  bool _locationPermissionGranted = false;
  bool _locationServiceEnabled = false;
  String? _selectedAgencyId;
  Map<String, dynamic>? _selectedAgency;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, double>? get currentLocation => _currentLocation;
  List<Map<String, dynamic>> get nearbyAgencies => _nearbyAgencies;
  List<Map<String, dynamic>> get technicianLocations => _technicianLocations;
  bool get locationPermissionGranted => _locationPermissionGranted;
  bool get locationServiceEnabled => _locationServiceEnabled;
  String? get selectedAgencyId => _selectedAgencyId;
  Map<String, dynamic>? get selectedAgency => _selectedAgency;

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

  // Initialize Location Services
  Future<bool> initializeLocationServices() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate permission request
      _locationPermissionGranted = true;
      _locationServiceEnabled = true;

      // Simulate getting current location (Casablanca)
      _currentLocation = {
        'latitude': 33.5831,
        'longitude': -7.6167,
      };

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize location services: $e');
      _setLoading(false);
      return false;
    }
  }

  // Request Location Permission
  Future<bool> requestLocationPermission() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _locationPermissionGranted = true;
      _locationServiceEnabled = true;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to get location permission: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get Current Location
  Future<bool> getCurrentLocation() async {
    if (!_locationPermissionGranted) {
      _setError('Location permission not granted');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // Simulate getting current location with slight variations
      const baseLatitude = 33.5831;
      const baseLongitude = -7.6167;

      _currentLocation = {
        'latitude':
            baseLatitude + (0.01 - 0.02 * (DateTime.now().millisecond / 1000)),
        'longitude':
            baseLongitude + (0.01 - 0.02 * (DateTime.now().second / 60)),
      };

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to get current location: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Nearby MultiSales Agencies
  Future<bool> loadNearbyAgencies({double radius = 10.0}) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      _nearbyAgencies = [
        {
          'id': 'agency_casa_1',
          'name': 'MultiSales Casablanca Centre',
          'address': '123 Avenue Mohammed V, Casablanca 20000',
          'phone': '+212 522 123 456',
          'email': 'casablanca@multisales.ma',
          'latitude': 33.5886,
          'longitude': -7.6094,
          'distance': 1.2, // km
          'rating': 4.8,
          'services': ['Sales', 'Technical Support', 'Customer Service'],
          'openingHours': {
            'monday': '08:00 - 18:00',
            'tuesday': '08:00 - 18:00',
            'wednesday': '08:00 - 18:00',
            'thursday': '08:00 - 18:00',
            'friday': '08:00 - 18:00',
            'saturday': '09:00 - 16:00',
            'sunday': 'Closed',
          },
          'isOpen': true,
          'manager': 'Fatima Zahra Alami',
          'parkingAvailable': true,
        },
        {
          'id': 'agency_casa_2',
          'name': 'MultiSales Maarif',
          'address': '45 Boulevard Zerktouni, Maarif, Casablanca 20100',
          'phone': '+212 522 987 654',
          'email': 'maarif@multisales.ma',
          'latitude': 33.5650,
          'longitude': -7.6256,
          'distance': 2.8, // km
          'rating': 4.6,
          'services': ['Sales', 'Technical Support'],
          'openingHours': {
            'monday': '08:30 - 17:30',
            'tuesday': '08:30 - 17:30',
            'wednesday': '08:30 - 17:30',
            'thursday': '08:30 - 17:30',
            'friday': '08:30 - 17:30',
            'saturday': '09:30 - 15:30',
            'sunday': 'Closed',
          },
          'isOpen': true,
          'manager': 'Ahmed Bennani',
          'parkingAvailable': false,
        },
        {
          'id': 'agency_rabat_1',
          'name': 'MultiSales Rabat Agdal',
          'address': '78 Avenue Allal Ben Abdellah, Rabat 10000',
          'phone': '+212 537 654 321',
          'email': 'rabat@multisales.ma',
          'latitude': 34.0181,
          'longitude': -6.8286,
          'distance': 87.5, // km
          'rating': 4.7,
          'services': ['Sales', 'Technical Support', 'Training Center'],
          'openingHours': {
            'monday': '08:00 - 18:00',
            'tuesday': '08:00 - 18:00',
            'wednesday': '08:00 - 18:00',
            'thursday': '08:00 - 18:00',
            'friday': '08:00 - 18:00',
            'saturday': '09:00 - 16:00',
            'sunday': 'Closed',
          },
          'isOpen': false,
          'manager': 'Youssef Tazi',
          'parkingAvailable': true,
        },
        {
          'id': 'agency_marrakech_1',
          'name': 'MultiSales Marrakech Gueliz',
          'address': '12 Avenue Mohamed VI, Gueliz, Marrakech 40000',
          'phone': '+212 524 111 222',
          'email': 'marrakech@multisales.ma',
          'latitude': 31.6295,
          'longitude': -7.9811,
          'distance': 242.3, // km
          'rating': 4.5,
          'services': ['Sales', 'Customer Service'],
          'openingHours': {
            'monday': '08:00 - 17:00',
            'tuesday': '08:00 - 17:00',
            'wednesday': '08:00 - 17:00',
            'thursday': '08:00 - 17:00',
            'friday': '08:00 - 17:00',
            'saturday': '09:00 - 15:00',
            'sunday': 'Closed',
          },
          'isOpen': true,
          'manager': 'Aicha Berrada',
          'parkingAvailable': true,
        },
      ];

      // Sort by distance
      _nearbyAgencies.sort((a, b) => a['distance'].compareTo(b['distance']));

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to load nearby agencies: $e');
      _setLoading(false);
      return false;
    }
  }

  // Track Technician Location for Active Appointments
  Future<bool> trackTechnicianLocation(String appointmentId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      _technicianLocations = [
        {
          'appointmentId': appointmentId,
          'technicianId': 'tech_001',
          'technicianName': 'Ahmed Benali',
          'currentLatitude': 33.5756,
          'currentLongitude': -7.6098,
          'destinationLatitude': _currentLocation?['latitude'] ?? 33.5831,
          'destinationLongitude': _currentLocation?['longitude'] ?? -7.6167,
          'estimatedArrival':
              DateTime.now().add(const Duration(minutes: 15)).toIso8601String(),
          'status': 'en_route', // en_route, nearby, arrived
          'lastUpdated': DateTime.now().toIso8601String(),
          'phone': '+212 661 234 567',
          'vehicleInfo': 'Toyota Hilux - 123ABC45',
        },
      ];

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to track technician location: $e');
      _setLoading(false);
      return false;
    }
  }

  // Select Agency
  void selectAgency(String agencyId) {
    _selectedAgencyId = agencyId;
    _selectedAgency = _nearbyAgencies.firstWhere(
      (agency) => agency['id'] == agencyId,
      orElse: () => {},
    );
    notifyListeners();
  }

  // Get Navigation Instructions to Agency
  Future<Map<String, dynamic>?> getNavigationToAgency(String agencyId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final agency = _nearbyAgencies.firstWhere(
        (a) => a['id'] == agencyId,
        orElse: () => {},
      );

      if (agency.isEmpty) {
        _setError('Agency not found');
        _setLoading(false);
        return null;
      }

      final navigationData = {
        'agencyId': agencyId,
        'agencyName': agency['name'],
        'agencyAddress': agency['address'],
        'destinationLatitude': agency['latitude'],
        'destinationLongitude': agency['longitude'],
        'distance': agency['distance'],
        'estimatedDuration': _calculateTravelTime(agency['distance']),
        'directions': [
          'Head southeast on your current street',
          'Turn right onto Avenue Mohammed V',
          'Continue for ${(agency['distance'] * 0.7).toStringAsFixed(1)} km',
          'Turn left onto ${agency['address'].split(',')[0]}',
          'Destination will be on your right',
        ],
        'mapUrl':
            'https://maps.google.com/maps?q=${agency['latitude']},${agency['longitude']}',
      };

      _setLoading(false);
      return navigationData;
    } catch (e) {
      _setError('Failed to get navigation instructions: $e');
      _setLoading(false);
      return null;
    }
  }

  // Get Distance Between Two Points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simplified distance calculation (Haversine formula would be more accurate)
    const double earthRadius = 6371; // km

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = (dLat / 2) * (dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            (dLon / 2) *
            (dLon / 2);

    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  // Find Nearest Agency
  Map<String, dynamic>? findNearestAgency() {
    if (_nearbyAgencies.isEmpty) return null;

    return _nearbyAgencies.first; // Already sorted by distance
  }

  // Get Agencies by Service Type
  List<Map<String, dynamic>> getAgenciesByService(String serviceType) {
    return _nearbyAgencies.where((agency) {
      final services = agency['services'] as List<String>;
      return services.contains(serviceType);
    }).toList();
  }

  // Check if Agency is Currently Open
  bool isAgencyOpen(Map<String, dynamic> agency) {
    final now = DateTime.now();
    final currentDay = _getDayOfWeek(now.weekday);
    final openingHours = agency['openingHours'] as Map<String, dynamic>;

    if (!openingHours.containsKey(currentDay)) return false;

    final todayHours = openingHours[currentDay] as String;
    if (todayHours == 'Closed') return false;

    // Simplified time check
    final currentHour = now.hour;
    return currentHour >= 8 && currentHour < 18;
  }

  // Private helper methods
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  String _calculateTravelTime(double distanceKm) {
    // Assume average speed of 30 km/h in city
    final minutes = (distanceKm / 30 * 60).round();

    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}min';
    }
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'monday';
    }
  }

  // Reset location data
  void resetLocationData() {
    _currentLocation = null;
    _nearbyAgencies.clear();
    _technicianLocations.clear();
    _selectedAgencyId = null;
    _selectedAgency = null;
    notifyListeners();
  }
}
