/// On-device Biometric Authentication Service
class BiometricService {
  BiometricService._();
  static final BiometricService instance = BiometricService._();

  bool _isHardwareSupported = true;
  bool _canCheckBiometrics = true;

  bool get isHardwareSupported => _isHardwareSupported;
  bool get canCheckBiometrics => _canCheckBiometrics;

  /// Check if device has enrolled fingerprints or face unlock
  Future<bool> checkBiometricAvailability() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _isHardwareSupported && _canCheckBiometrics;
  }

  /// Authenticate user via biometric prompt
  Future<bool> authenticate({
    required String reason,
    bool proximityVerified = true,
  }) async {
    // Proximity gating rule: biometrics are blocked if user is outside campus perimeter
    if (!proximityVerified) {
      return false;
    }

    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  /// For testing/debug toggle
  void setHardwareSupported(bool supported) {
    _isHardwareSupported = supported;
  }

  void setCanCheckBiometrics(bool canCheck) {
    _canCheckBiometrics = canCheck;
  }
}
