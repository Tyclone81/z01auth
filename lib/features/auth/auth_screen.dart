import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import 'widgets/biometric_auth_modal.dart';

/// Frame 1: 01_Auth (Google Auth + Proximity-Gated Biometrics)
/// Strict monochrome Black (#000000) & White (#FFFFFF) UI matching Figma spec
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Proximity gate state (Simulates physical perimeter detection)
  bool _isNearPremises = true;
  String? _warningMessage;

  void _toggleProximityGate() {
    setState(() {
      _isNearPremises = !_isNearPremises;
      _warningMessage = null;
    });
  }

  void _handleBiometricAuth() {
    if (!_isNearPremises) {
      setState(() {
        _warningMessage = '⚠ Biometrics blocked: Connect to campus Wi-Fi or enter 50m perimeter.';
      });
      return;
    }

    BiometricAuthModal.show(
      context: context,
      title: 'Biometric Sign-In',
      subtitle: 'Touch the fingerprint sensor to verify your identity at Zone01 Campus.',
      proximityTag: 'PROXIMITY VERIFIED • 18m',
      onSuccess: () {
        Navigator.pushReplacementNamed(context, '/permissions');
      },
    );
  }

  void _handleGoogleSignIn() {
    if (!_isNearPremises) {
      setState(() {
        _warningMessage = '⚠ Cannot sign in: Must be near premises GPS or Wi-Fi to bind device.';
      });
      return;
    }
    // Proceed to Step 2 Permissions onboarding
    Navigator.pushNamed(context, '/permissions');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;
    final accentCol = isDark ? Z01Colors.darkAccent : Z01Colors.lightAccent;
    final accentFg = isDark ? Z01Colors.darkAccentFg : Z01Colors.lightAccentFg;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Status & Interactive Proximity Gate Banner
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('08:40', style: Z01Theme.monoStyle(context: context, fontSize: 12, color: mutedCol)),
                      Text('5G • 100%', style: Z01Theme.monoStyle(context: context, fontSize: 12, color: mutedCol)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Proximity Gate Banner (Interactive toggle for test & validation)
                  GestureDetector(
                    onTap: _toggleProximityGate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isNearPremises ? borderStrong : borderCol,
                          width: _isNearPremises ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _isNearPremises ? '((•))' : '( × )',
                            style: Z01Theme.monoStyle(
                              context: context,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: textCol,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isNearPremises ? 'NEAR PREMISES • 18m' : 'OFF PREMISES • >150m',
                                  style: Z01Theme.monoStyle(
                                    context: context,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: textCol,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  _isNearPremises
                                      ? 'Z01_Campus_5G detected • Biometrics unlocked'
                                      : 'Campus Wi-Fi not detected • Biometrics locked',
                                  style: TextStyle(color: mutedCol, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: textCol,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'TEST',
                              style: Z01Theme.monoStyle(
                                context: context,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Center Brand & Mission
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: borderStrong, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: textCol.withValues(alpha: 0.08),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Z01',
                          style: Z01Theme.monoStyle(
                            context: context,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: textCol,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: textCol,
                            shape: BoxShape.circle,
                            border: Border.all(color: isDark ? Colors.black : Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check,
                            size: 13,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Z01auth', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Zero-touch attendance powered by campus Wi-Fi, geofencing & on-site biometrics.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mutedCol, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 16),

                  // Mini feature pills
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _featurePill(context, '1st Scan = Time In'),
                      _featurePill(context, 'Last Seen = Time Out'),
                      _featurePill(context, 'Biometric Gate'),
                    ],
                  ),
                ],
              ),

              // Bottom Action Area
              Column(
                children: [
                  if (_warningMessage != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderStrong),
                      ),
                      child: Text(
                        _warningMessage!,
                        style: TextStyle(color: textCol, fontSize: 11, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  // Primary Button: Biometric Sign-In (Proximity-Gated)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isNearPremises ? accentCol : cardBg,
                        foregroundColor: _isNearPremises ? accentFg : mutedCol,
                        side: _isNearPremises ? null : BorderSide(color: borderCol, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: _isNearPremises ? 2 : 0,
                      ),
                      onPressed: _handleBiometricAuth,
                      icon: Icon(
                        _isNearPremises ? Icons.fingerprint_rounded : Icons.lock_outline_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _isNearPremises
                            ? 'Sign In with Biometrics (On-Premises)'
                            : '🔒 Biometrics Locked (Move Near Campus)',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Secondary Button: Google Sign-In
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: cardBg,
                        side: BorderSide(color: borderStrong, width: 1.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _handleGoogleSignIn,
                      icon: Text(
                        'G',
                        style: Z01Theme.monoStyle(
                          context: context,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: textCol,
                        ),
                      ),
                      label: Text(
                        'Continue with Google',
                        style: TextStyle(color: textCol, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Biometric & attendance sign-in requires campus GPS/Wi-Fi proximity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mutedCol, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featurePill(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderCol),
      ),
      child: Text(
        text,
        style: Z01Theme.monoStyle(context: context, fontSize: 9, fontWeight: FontWeight.w600),
      ),
    );
  }
}
