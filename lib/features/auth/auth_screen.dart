import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';

/// Frame 1 Skeleton: 01_Auth (Google Sign-In + Proximity-Gated Biometrics)
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;
    final accentCol = isDark ? Z01Colors.darkAccent : Z01Colors.lightAccent;
    final accentFg = isDark ? Z01Colors.darkAccentFg : Z01Colors.lightAccentFg;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Bar Time / Network indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('08:40', style: Z01Theme.monoStyle(context: context, fontSize: 12, color: mutedCol)),
                  Text('5G • 100%', style: Z01Theme.monoStyle(context: context, fontSize: 12, color: mutedCol)),
                ],
              ),

              // Brand Icon & Tagline
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderStrong, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Z01',
                      style: Z01Theme.monoStyle(
                        context: context,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: textCol,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Z01auth', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Zero-touch attendance powered by campus Wi-Fi, geofencing & on-site biometrics.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: mutedCol, fontSize: 13, height: 1.4),
                  ),
                ],
              ),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentCol,
                        foregroundColor: accentFg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/permissions');
                      },
                      child: const Text('Sign In with Biometrics', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderStrong, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/permissions');
                      },
                      child: Text('Continue with Google', style: TextStyle(color: textCol, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
