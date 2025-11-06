import 'dart:math';

/// Location model for MultiSales app
class LocationModel {
  final String id;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final double? heading;
  final DateTime timestamp;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;

  LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.heading,
    required this.timestamp,
    this.address,
    this.city,
    this.country,
    this.postalCode,
  });

  /// Create LocationModel from Firestore document
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      accuracy: map['accuracy']?.toDouble(),
      altitude: map['altitude']?.toDouble(),
      speed: map['speed']?.toDouble(),
      heading: map['heading']?.toDouble(),
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      address: map['address'],
      city: map['city'],
      country: map['country'],
      postalCode: map['postalCode'],
    );
  }

  /// Convert LocationModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'heading': heading,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
      'city': city,
      'country': country,
      'postalCode': postalCode,
    };
  }

  /// Create a copy with updated fields
  LocationModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
    DateTime? timestamp,
    String? address,
    String? city,
    String? country,
    String? postalCode,
  }) {
    return LocationModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  /// Get formatted coordinates
  String get coordinatesText =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  /// Get formatted address or coordinates
  String get displayText => address ?? coordinatesText;

  /// Get short address (first part only)
  String get shortAddress {
    if (address == null) return coordinatesText;
    final parts = address!.split(',');
    return parts.isNotEmpty ? parts.first.trim() : address!;
  }

  /// Get accuracy description
  String get accuracyDescription {
    if (accuracy == null) return 'Unknown accuracy';

    if (accuracy! <= 5) return 'Very high accuracy';
    if (accuracy! <= 10) return 'High accuracy';
    if (accuracy! <= 50) return 'Good accuracy';
    if (accuracy! <= 100) return 'Moderate accuracy';
    return 'Low accuracy';
  }

  /// Check if location has high accuracy
  bool get hasHighAccuracy => accuracy != null && accuracy! <= 10;

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if location is recent (within last 5 minutes)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inMinutes <= 5;
  }

  /// Generate Google Maps URL
  String get googleMapsUrl =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  /// Generate Apple Maps URL
  String get appleMapsUrl => 'http://maps.apple.com/?q=$latitude,$longitude';

  /// Calculate distance to another location (in kilometers)
  double distanceTo(LocationModel other) {
    const double earthRadius = 6371; // km

    final lat1Rad = latitude * (3.141592653589793 / 180);
    final lat2Rad = other.latitude * (3.141592653589793 / 180);
    final deltaLatRad = (other.latitude - latitude) * (3.141592653589793 / 180);
    final deltaLonRad =
        (other.longitude - longitude) * (3.141592653589793 / 180);

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLonRad / 2) *
            sin(deltaLonRad / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Get formatted distance to another location
  String distanceToFormatted(LocationModel other) {
    final distance = distanceTo(other);
    if (distance < 1) {
      return '${(distance * 1000).round()} m';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }

  /// Check if location is valid
  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Get location hash for caching/comparison
  String get locationHash {
    return '${latitude.toStringAsFixed(6)}_${longitude.toStringAsFixed(6)}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LocationModel(id: $id, lat: $latitude, lng: $longitude)';
}

/// Location bounds for map regions
class LocationBounds {
  final double northEast;
  final double northWest;
  final double southEast;
  final double southWest;

  LocationBounds({
    required this.northEast,
    required this.northWest,
    required this.southEast,
    required this.southWest,
  });

  /// Check if location is within bounds
  bool contains(LocationModel location) {
    return location.latitude <= northEast &&
        location.latitude >= southWest &&
        location.longitude <= southEast &&
        location.longitude >= northWest;
  }

  /// Get center point of bounds
  LocationModel get center {
    final centerLat = (northEast + southWest) / 2;
    final centerLng = (southEast + northWest) / 2;

    return LocationModel(
      id: 'center_${DateTime.now().millisecondsSinceEpoch}',
      latitude: centerLat,
      longitude: centerLng,
      timestamp: DateTime.now(),
    );
  }
}

/// Predefined locations for UAE
class UAELocations {
  static final dubai = LocationModel(
    id: 'dubai',
    latitude: 25.2048,
    longitude: 55.2708,
    timestamp: DateTime.now(),
    address: 'Dubai, UAE',
    city: 'Dubai',
    country: 'UAE',
  );

  static final abuDhabi = LocationModel(
    id: 'abu_dhabi',
    latitude: 24.4539,
    longitude: 54.3773,
    timestamp: DateTime.now(),
    address: 'Abu Dhabi, UAE',
    city: 'Abu Dhabi',
    country: 'UAE',
  );

  static final sharjah = LocationModel(
    id: 'sharjah',
    latitude: 25.3463,
    longitude: 55.4209,
    timestamp: DateTime.now(),
    address: 'Sharjah, UAE',
    city: 'Sharjah',
    country: 'UAE',
  );

  static List<LocationModel> get all => [dubai, abuDhabi, sharjah];
}
