/// Presence state variants matching Figma component states & backend responses
enum PresenceState {
  checkedIn,   // CHECKED_IN: Within geofence & connected to campus Wi-Fi
  approaching, // NEAR_PREMISES: In 50m geofence, awaiting Wi-Fi handshake
  offPremises, // OFF_PREMISES: Outside campus perimeter (>50m / disconnected)
}

/// User profile returned from POST /api/v1/auth/session
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String initials;
  final String cohort;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.initials,
    required this.cohort,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      initials: json['initials'] as String? ?? 'AB',
      cohort: json['cohort'] as String? ?? 'Cohort 2026',
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'display_name': displayName,
    'initials': initials,
    'cohort': cohort,
  };
}

/// Campus configuration returned from GET /api/v1/config/premises
class PremisesConfig {
  final String campusName;
  final String timezone;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final List<String> allowedBssids;
  final int heartbeatIntervalSeconds;

  const PremisesConfig({
    required this.campusName,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.allowedBssids,
    required this.heartbeatIntervalSeconds,
  });

  factory PremisesConfig.fromJson(Map<String, dynamic> json) {
    final geofence = json['geofence'] as Map<String, dynamic>? ?? {};
    final allowedWifi = json['allowed_wifi'] as List<dynamic>? ?? [];
    final bssids = allowedWifi
        .map((e) => (e['bssid'] as String? ?? '').toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    return PremisesConfig(
      campusName: json['campus_name'] as String? ?? 'Zone01 Campus',
      timezone: json['timezone'] as String? ?? 'Africa/Nairobi',
      latitude: (geofence['latitude'] as num?)?.toDouble() ?? -0.091702,
      longitude: (geofence['longitude'] as num?)?.toDouble() ?? 34.767956,
      radiusMeters: (geofence['radius_meters'] as num?)?.toDouble() ?? 50.0,
      allowedBssids: bssids,
      heartbeatIntervalSeconds: json['heartbeat_interval_seconds'] as int? ?? 300,
    );
  }
}

/// Request body for POST /api/v1/attendance/ping
class AttendancePingRequest {
  final String triggerType;
  final DateTime clientTimestamp;
  final bool biometricVerified;
  final bool wifiConnected;
  final String wifiSsid;
  final String wifiBssid;
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final bool isMockLocation;

  const AttendancePingRequest({
    required this.triggerType,
    required this.clientTimestamp,
    required this.biometricVerified,
    required this.wifiConnected,
    required this.wifiSsid,
    required this.wifiBssid,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    this.isMockLocation = false,
  });

  Map<String, dynamic> toJson() => {
    'trigger_type': triggerType,
    'client_timestamp': clientTimestamp.toUtc().toIso8601String(),
    'biometric_verified': biometricVerified,
    'wifi': {
      'connected': wifiConnected,
      'ssid': wifiSsid,
      'bssid': wifiBssid.toLowerCase(),
    },
    'location': {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy_meters': accuracyMeters,
      'is_mock_location': isMockLocation,
    },
  };
}

/// Response payload from POST /api/v1/attendance/ping
class AttendancePingResponse {
  final String date;
  final PresenceState presenceState;
  final String firstSeenAt;
  final String lastSeenAt;
  final bool firstSeenLocked;
  final int activeDurationSeconds;
  final String activeDurationFormatted;
  final bool wifiVerified;
  final bool gpsVerified;
  final bool biometricVerified;

  const AttendancePingResponse({
    required this.date,
    required this.presenceState,
    required this.firstSeenAt,
    required this.lastSeenAt,
    required this.firstSeenLocked,
    required this.activeDurationSeconds,
    required this.activeDurationFormatted,
    required this.wifiVerified,
    required this.gpsVerified,
    required this.biometricVerified,
  });

  factory AttendancePingResponse.fromJson(Map<String, dynamic> json) {
    final verification = json['verification'] as Map<String, dynamic>? ?? {};
    final stateStr = json['presence_state'] as String? ?? 'CHECKED_IN';
    final state = stateStr == 'CHECKED_IN'
        ? PresenceState.checkedIn
        : stateStr == 'NEAR_PREMISES'
            ? PresenceState.approaching
            : PresenceState.offPremises;

    return AttendancePingResponse(
      date: json['date'] as String? ?? '',
      presenceState: state,
      firstSeenAt: json['first_seen_at'] as String? ?? '',
      lastSeenAt: json['last_seen_at'] as String? ?? '',
      firstSeenLocked: json['first_seen_locked'] as bool? ?? true,
      activeDurationSeconds: json['active_duration_seconds'] as int? ?? 0,
      activeDurationFormatted: json['active_duration_formatted'] as String? ?? '00h 00m',
      wifiVerified: verification['wifi_verified'] as bool? ?? false,
      gpsVerified: verification['gps_verified'] as bool? ?? false,
      biometricVerified: verification['biometric_verified'] as bool? ?? false,
    );
  }
}

/// Item in recent_detections list on Frame 3 Live Radar
class DetectionLog {
  final String id;
  final String timeEat;
  final String title;
  final String subtitle;
  final String triggerType;
  final bool isVerified;

  const DetectionLog({
    required this.id,
    required this.timeEat,
    required this.title,
    required this.subtitle,
    required this.triggerType,
    this.isVerified = true,
  });

  factory DetectionLog.fromJson(Map<String, dynamic> json) {
    return DetectionLog(
      id: json['id'] as String? ?? '',
      timeEat: json['time_eat'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      triggerType: json['trigger_type'] as String? ?? '',
      isVerified: true,
    );
  }
}

/// Daily attendance item in Frame 4 History
class AttendanceRecord {
  final String date;
  final String dateTitle;
  final String timeIn;
  final String timeOut;
  final String duration;
  final bool isActive;
  final String status;

  const AttendanceRecord({
    required this.date,
    required this.dateTitle,
    required this.timeIn,
    required this.timeOut,
    required this.duration,
    this.isActive = false,
    this.status = 'COMPLETED',
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: json['date'] as String? ?? '',
      dateTitle: json['display_date'] as String? ?? '',
      timeIn: json['first_seen_eat'] as String? ?? '',
      timeOut: json['last_seen_eat'] as String? ?? '',
      duration: json['duration_formatted'] as String? ?? '',
      isActive: json['is_active_today'] as bool? ?? false,
      status: json['status'] as String? ?? 'COMPLETED',
    );
  }
}

/// Monthly summary statistics in Frame 4 History
class AttendanceSummaryStats {
  final int daysPresent;
  final double avgHours;
  final int verificationRatePercent;

  const AttendanceSummaryStats({
    required this.daysPresent,
    required this.avgHours,
    required this.verificationRatePercent,
  });

  factory AttendanceSummaryStats.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryStats(
      daysPresent: json['days_present'] as int? ?? 0,
      avgHours: (json['avg_hours'] as num?)?.toDouble() ?? 0.0,
      verificationRatePercent: json['verification_rate_percent'] as int? ?? 100,
    );
  }
}
