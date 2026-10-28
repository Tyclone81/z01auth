import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/z01_theme.dart';
import 'widgets/biometric_auth_modal.dart';
import 'widgets/proximity_shield_hero.dart';

/// Frame 1: 01_Auth (Google sign-in + proximity-gated biometrics)
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Simulated proximity state (mock until real sensors are wired in)
  bool _isNearPremises = true;
  String? _warningMessage;

  void _toggleProximityGate() {
    setState(() {
      _isNearPremises = !_isNearPremises;
      _warningMessage = null;
    });

    final p = Z01Palette.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.cardElevated,
        content: Row(
          children: [
            Icon(
              _isNearPremises ? Icons.shield_rounded : Icons.lock_outline_rounded,
              color: p.brand,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isNearPremises
                    ? 'Test mode: on premises (18 m)'
                    : 'Test mode: off premises (>150 m)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBiometricAuth() {
    if (!_isNearPremises) {
      setState(() {
        _warningMessage =
            'Biometrics are locked. Connect to campus Wi-Fi or enter the 50 m perimeter.';
      });
      return;
    }

    BiometricAuthModal.show(
      context: context,
      title: 'Biometric Sign-In',
      subtitle: 'Touch the fingerprint sensor to verify your identity at Zone01.',
      proximityTag: 'PROXIMITY VERIFIED • 18m',
      onSuccess: () {
        Navigator.pushReplacementNamed(context, '/permissions');
      },
    );
  }

    void _handleGoogleSignIn() {
    // Signing in only proves who you are. Attendance is recorded separately
    // and only counts when you are on premises.
    Navigator.pushNamed(context, '/permissions');
  }

  @override
  Widget build(BuildContext context) {
    final p = Z01Palette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ---------- TOP: wordmark + theme toggle + shield ----------
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Z01 Authentication App',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: p.text,
                                      ),
                                    ),
                                    Text(
                                      'ZONE01 KISUMU',
                                      style: TextStyle(
                                        fontSize: 11,
                                        letterSpacing: 0.9,
                                        color: p.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                iconSize: 20,
                                tooltip: 'Toggle theme',
                                icon: Icon(
                                  isDark
                                      ? Icons.light_mode_outlined
                                      : Icons.dark_mode_outlined,
                                  color: p.text,
                                ),
                                onPressed: () => ThemeController.instance.toggleTheme(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Test toggle only works in debug builds.
                          ProximityShieldHero(
                            isNearPremises: _isNearPremises,
                            onToggleProximity:
                                kDebugMode ? _toggleProximityGate : () {},
                          ),
                        ],
                      ),

                      // ---------- MIDDLE: headline + status ----------
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Text(
                              'Log in to mark attendance',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 26,
                                    height: 1.25,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Campus Wi-Fi and location confirm where you are. '
                              'Your fingerprint confirms it\'s you.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: p.muted, fontSize: 14, height: 1.5),
                            ),
                            const SizedBox(height: 16),
                            _statusPill(p),
                          ],
                        ),
                      ),

                      // ---------- BOTTOM: actions ----------
                      Column(
                        children: [
                          if (_warningMessage != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: p.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: p.borderStrong, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, size: 16, color: p.text),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _warningMessage!,
                                      style: TextStyle(
                                        color: p.text,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Primary: Google
                          FilledButton.icon(
                            onPressed: _handleGoogleSignIn,
                            icon: Text(
                              'G',
                              style: Z01Theme.monoStyle(
                                context: context,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: p.accentFg,
                              ),
                            ),
                            label: const Text('Continue with Google'),
                          ),
                          const SizedBox(height: 12),

                          // Secondary: Biometrics (locked look when off premises)
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _isNearPremises ? p.text : p.muted,
                            ),
                            onPressed: _handleBiometricAuth,
                            icon: Icon(
                              _isNearPremises
                                  ? Icons.fingerprint_rounded
                                  : Icons.lock_outline_rounded,
                              size: 20,
                            ),
                            label: Text(
                              _isNearPremises
                                  ? 'Sign in with biometrics'
                                  : 'Biometrics unlock on campus',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Biometrics never leave your device.',
                            style: TextStyle(color: p.muted, fontSize: 12),
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

  Widget _statusPill(Z01Palette p) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(_isNearPremises),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: p.cardElevated,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isNearPremises ? p.brand : p.muted,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _isNearPremises ? 'On premises · 18 m' : 'Off premises · >150 m',
              style: TextStyle(fontSize: 12, color: p.text),
            ),
          ],
        ),
      ),
    );
  }
}