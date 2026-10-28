import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';
import '../../../models/presence_state.dart';

/// Paints the presence ring:
///  - checkedIn:   solid ring + a soft ripple inside
///  - approaching: dashed ring
///  - offPremises: dotted ring
class RadarRingPainter extends CustomPainter {
  final PresenceState state;
  final Color color;
  final Color trackColor;
  final double animationValue;

  RadarRingPainter({
    required this.state,
    required this.color,
    required this.trackColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;

    // Faint track behind every state
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke,
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (state) {
      case PresenceState.checkedIn:
        canvas.drawCircle(center, radius, paint);

        // One soft ripple moving inward
        final ripple = Paint()
          ..color = color.withValues(alpha: 0.18 * (1.0 - animationValue))
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(center, radius - 16 - (animationValue * 14), ripple);
        break;

      case PresenceState.approaching:
        const int dashes = 16;
        const double dashAngle = (2 * pi) / dashes;
        for (int i = 0; i < dashes; i++) {
          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius),
            i * dashAngle,
            dashAngle * 0.6,
            false,
            paint,
          );
        }
        break;

      case PresenceState.offPremises:
        const int dots = 32;
        const double dotAngle = (2 * pi) / dots;
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        for (int i = 0; i < dots; i++) {
          final angle = i * dotAngle;
          canvas.drawCircle(
            Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
            2.2,
            dotPaint,
          );
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant RadarRingPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.animationValue != animationValue;
  }
}

/// The big presence ring on the dashboard.
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
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Z01Palette.of(context);

    IconData icon;
    Color iconColor;
    Color ringColor;
    String title;
    String sub;

    switch (widget.state) {
      case PresenceState.checkedIn:
        icon = Icons.shield_rounded;
        iconColor = p.brand;
        ringColor = p.brand;
        title = 'Checked in';
        sub = '07h 37m active'; // TODO: use real session time from the service
        break;
      case PresenceState.approaching:
        icon = Icons.shield_outlined;
        iconColor = p.brand;
        ringColor = p.brand;
        title = 'Near campus';
        sub = 'Ready for biometrics';
        break;
      case PresenceState.offPremises:
        icon = Icons.lock_outline_rounded;
        iconColor = p.muted;
        ringColor = p.muted;
        title = 'Off premises';
        sub = 'Biometrics locked';
        break;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          return SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: RadarRingPainter(
                state: widget.state,
                color: ringColor,
                trackColor: p.border,
                animationValue: _pulse.value,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 52, color: iconColor),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: p.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sub,
                      style: Z01Theme.monoStyle(
                        context: context,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: p.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}