import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/z01_theme.dart';
import 'widgets/biometric_auth_modal.dart';
import 'widgets/proximity_shield_hero.dart';

/// Frame 1: 01_Auth (Google Auth + Proximity-Gated Biometrics)
/// Features the interactive Lock & Shield centerpiece inspired by modern fintech UI/UX.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Proximity gate state (Simulates physical campus perimeter detection)
  bool _isNearPremises = true;
  String? _warningMessage;

  void _toggleProximityGate() {
    setState(() {
      _isNearPremises = !_isNearPremises;
      _warningMessage = null;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _isNearPremises ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
        content: Row(
          children: [
            Icon(
              _isNearPremises ? Icons.shield_rounded : Icons.lock_outline_rounded,
              color: _isNearPremises ? Z01Colors.cyanGlow : Z01Colors.lockedAmber,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              _isNearPremises
                  ? 'Proximity Gate: In Range (18m) • Biometrics Unlocked'
                  : 'Proximity Gate: Out of Range (>150m) • Biometrics Gated',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Bar: Brand, Hardware Status, and Theme Toggle
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: textCol,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Z01',
                                      style: Z01Theme.monoStyle(
                                        context: context,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: isDark ? Colors.black : Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Z01auth',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                      color: textCol,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '5G • 100%',
                                    style: Z01Theme.monoStyle(context: context, fontSize: 11, color: mutedCol),
                                  ),
                                  const SizedBox(width: 8),
                                  // Theme toggle button
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    iconSize: 18,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    icon: Icon(
                                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                      color: textCol,
                                    ),
                                    onPressed: () => ThemeController.instance.toggleTheme(),
                                    tooltip: 'Toggle Theme',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // The Interactive Centerpiece: Lock & Shield Proximity Hero
                          ProximityShieldHero(
                            isNearPremises: _isNearPremises,
                            onToggleProximity: _toggleProximityGate,
                          ),
                        ],
                      ),

                      // Center: Contextual Status, Headline & Privacy Badges
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                _isNearPremises ? 'Campus Gate Unlocked' : 'Proximity Gate Armed',
                                key: ValueKey(_isNearPremises ? 'title_near' : 'title_off'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                _isNearPremises
                                    ? 'Connected to Z01_Campus_5G. On-premises biometrics are armed for zero-touch attendance.'
                                    : 'Campus Wi-Fi & 50m geofence not detected. Biometric attendance is locked until in proximity.',
                                key: ValueKey(_isNearPremises ? 'desc_near' : 'desc_off'),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: mutedCol, fontSize: 12, height: 1.45),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Micro feature tags
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              alignment: WrapAlignment.center,
                              children: [
                                _featurePill(context, '100% On-Device Proof'),
                                _featurePill(context, 'Zero GPS Tracking'),
                                _featurePill(context, 'Triple-Layer Gate'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Bottom Action Area
                      Column(
                        children: [
                          if (_warningMessage != null) ...[
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Z01Colors.lockedAmber.withValues(alpha: 0.6),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 16, color: Z01Colors.lockedAmber),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _warningMessage!,
                                      style: TextStyle(color: textCol, fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
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
                                side: _isNearPremises ? null : BorderSide(color: borderCol, width: 1.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                                side: BorderSide(color: borderStrong, width: 1.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shield_outlined, size: 12, color: mutedCol),
                              const SizedBox(width: 4),
                              Text(
                                'Local verification only • Your personal data stays on device',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: mutedCol, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
