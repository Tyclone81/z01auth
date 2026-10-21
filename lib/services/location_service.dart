import 'dart:math';
import '../core/constants/api_endpoints.dart';

/// Campus Location & Geofencing Service
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  double _currentLatitude = ApiEndpoints.defaultCampusLatitude;
  double _currentLongitude = ApiEndpoints.defaultCampusLongitude;
  double _accuracyMeters = 8.5;
  bool _isMockLocation = false;

  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude;
  double get accuracyMeters => _accuracyMeters;
  bool get isMockLocation => _isMockLocation;

  /// Calculate distance in meters using the Haversine formula
  double calculateDistanceToCampus({
    double? latitude,
    double? longitude,
    double campusLat = ApiEndpoints.defaultCampusLatitude,
    double campusLng = ApiEndpoints.defaultCampusLongitude,
  }) {
    final lat1 = (latitude ?? _currentLatitude) * pi / 180.0;
    final lon1 = (longitude ?? _currentLongitude) * pi / 180.0;
    final lat2 = campusLat * pi / 180.0;
    final lon2 = campusLng * pi / 180.0;

    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    const double earthRadiusMeters = 6371000.0;
    return earthRadiusMeters * c;
  }

  /// Verifies if user is within the 50m campus perimeter
  bool isWithinGeofence({double radiusMeters = ApiEndpoints.defaultGeofenceRadiusMeters}) {
    final distance = calculateDistanceToCampus();
    return distance <= radiusMeters;
  }

  /// Update simulated coordinates for testing
  void setCoordinates({
    required double latitude,
    required double longitude,
    double accuracy = 8.5,
    bool isMock = false,
  }) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _accuracyMeters = accuracy;
    _isMockLocation = isMock;
  }
}
