import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';

/// Interactive modal sheet simulating Android biometric fingerprint authentication
class BiometricAuthModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final String proximityTag;
  final VoidCallback onSuccess;

  const BiometricAuthModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.proximityTag,
    required this.onSuccess,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String proximityTag,
    required VoidCallback onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BiometricAuthModal(
        title: title,
        subtitle: subtitle,
        proximityTag: proximityTag,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<BiometricAuthModal> createState() => _BiometricAuthModalState();
}

class _BiometricAuthModalState extends State<BiometricAuthModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isSuccess = false;
  String _statusMessage = 'Tap fingerprint icon to verify';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleScan() async {
    if (_isSuccess) return;
    setState(() {
      _isSuccess = true;
      _statusMessage = '✓ Biometrics Verified! Authenticating...';
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      Navigator.pop(context);
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCol = isDark ? Z01Colors.darkBg : Z01Colors.lightBg;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: borderStrong, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: mutedCol.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Proximity Tag Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: textCol,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.proximityTag,
                style: Z01Theme.monoStyle(
                  context: context,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: mutedCol, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Interactive Fingerprint Scan Circle with animated pulse
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final glow = _isSuccess ? 18.0 : 6.0 + (_pulseController.value * 12.0);
                return GestureDetector(
                  onTap: _handleScan,
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardBg,
                      border: Border.all(color: borderStrong, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: textCol.withValues(alpha: _isSuccess ? 0.35 : 0.15),
                          blurRadius: glow,
                          spreadRadius: glow / 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSuccess ? Icons.check_circle_rounded : Icons.fingerprint_rounded,
                      size: 44,
                      color: textCol,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            Text(
              _statusMessage,
              style: Z01Theme.monoStyle(
                context: context,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textCol,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderCol),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: mutedCol, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
