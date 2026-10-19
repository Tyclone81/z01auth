import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';
import '../../../models/presence_state.dart';

/// Pixel-perfect custom painter for Solid, Dashed, and Dotted Monochrome Presence Rings
class RadarRingPainter extends CustomPainter {
  final PresenceState state;
  final Color color;
  final double animationValue;

  RadarRingPainter({
    required this.state,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    switch (state) {
      case PresenceState.checkedIn:
        // Solid outer ring with pulse glow
        canvas.drawCircle(center, radius, paint);

        // Subtle concentric inner ripple
        final ripplePaint = Paint()
          ..color = color.withValues(alpha: 0.15 * (1.0 - animationValue))
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(center, radius - 8 - (animationValue * 14), ripplePaint);
        break;

      case PresenceState.approaching:
        // Dashed ring (16 dashes)
        const int dashes = 16;
        const double dashAngle = (2 * pi) / dashes;
        for (int i = 0; i < dashes; i++) {
          final startAngle = i * dashAngle;
          final sweepAngle = dashAngle * 0.65;
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            startAngle,
            sweepAngle,
            false,
            paint,
          );
        }
        break;

      case PresenceState.offPremises:
        // Dotted ring (32 small dots)
        const int dots = 32;
        const double dotAngle = (2 * pi) / dots;
        paint.style = PaintingStyle.fill;
        for (int i = 0; i < dots; i++) {
          final angle = i * dotAngle;
          final x = center.dx + radius * cos(angle);
          final y = center.dy + radius * sin(angle);
          canvas.drawCircle(Offset(x, y), 2.0, paint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant RadarRingPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue;
  }
}

/// Central Presence Radar Component matching Figma Frame 3
class PresenceRadarRing extends StatefulWidget {
  final PresenceState state;
  final VoidCallback onTap;

  const PresenceRadarRing({
    super.key,
    required this.state,
    required this.onTap,
  });

  @override
  State<PresenceRadarRing> createState() => _PresenceRadarRingState();
}

class _PresenceRadarRingState extends State<PresenceRadarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;

    String iconSymbol;
    String statusTitle;
    String statusSub;

    switch (widget.state) {
      case PresenceState.checkedIn:
        iconSymbol = '((•))';
        statusTitle = 'CHECKED IN';
        statusSub = '07h 37m Active';
        break;
      case PresenceState.approaching:
        iconSymbol = '( • )';
        statusTitle = 'NEAR PREMISES';
        statusSub = 'Ready for Biometrics';
        break;
      case PresenceState.offPremises:
        iconSymbol = '( × )';
        statusTitle = 'OFF PREMISES';
        statusSub = 'Biometrics Locked';
        break;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final glowAlpha = widget.state == PresenceState.checkedIn
              ? 0.12 + (_pulseController.value * 0.18)
              : 0.0;

          return Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardBg,
              boxShadow: [
                if (widget.state == PresenceState.checkedIn)
                  BoxShadow(
                    color: textCol.withValues(alpha: glowAlpha),
                    blurRadius: 28,
                    spreadRadius: 4 + (_pulseController.value * 6),
                  ),
              ],
            ),
            child: CustomPaint(
              painter: RadarRingPainter(
                state: widget.state,
                color: textCol,
                animationValue: _pulseController.value,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        iconSymbol,
                        style: Z01Theme.monoStyle(
                          context: context,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textCol,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        statusTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: textCol,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusSub,
                        style: Z01Theme.monoStyle(
                          context: context,
                          fontSize: 11,
                          color: mutedCol,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to test states',
                        style: TextStyle(
                          fontSize: 9,
                          color: mutedCol,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
