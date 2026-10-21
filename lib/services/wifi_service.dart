import '../core/constants/api_endpoints.dart';

/// Campus Wi-Fi State & BSSID Verification Service
class WifiService {
  WifiService._();
  static final WifiService instance = WifiService._();

  bool _isConnected = true;
  String _currentSsid = ApiEndpoints.defaultAllowedSsids.first;
  String _currentBssid = ApiEndpoints.defaultAllowedBssids.first;

  bool get isConnected => _isConnected;
  String get currentSsid => _currentSsid;
  String get currentBssid => _currentBssid.toLowerCase();

  /// Check if the connected Wi-Fi BSSID matches the campus whitelist
  bool isCampusWifiMatched({List<String>? whitelist}) {
    if (!_isConnected) return false;
    final list = whitelist ?? ApiEndpoints.defaultAllowedBssids;
    final normalizedCurrent = _currentBssid.toLowerCase().trim();
    return list.any((bssid) => bssid.toLowerCase().trim() == normalizedCurrent);
  }

  /// Update simulated Wi-Fi connection for testing
  void setWifiState({
    required bool connected,
    String? ssid,
    String? bssid,
  }) {
    _isConnected = connected;
    if (ssid != null) _currentSsid = ssid;
    if (bssid != null) _currentBssid = bssid.toLowerCase();
  }
}
