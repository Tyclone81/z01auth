import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';

/// The shield centrepiece on the login screen.
/// Flat brand-blue shield when on premises, muted grey and locked when off.
/// Colours come from Z01Palette, so it works in dark and light mode.
class ProximityShieldHero extends StatefulWidget {
  final bool isNearPremises;
  final VoidCallback onToggleProximity;

  const ProximityShieldHero({
    super.key,
    required this.isNearPremises,
    required this.onToggleProximity,
  });

  @override
  State<ProximityShieldHero> createState() => _ProximityShieldHeroState();
}

class _ProximityShieldHeroState extends State<ProximityShieldHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
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
    final isNear = widget.isNearPremises;

    return GestureDetector(
      onTap: widget.onToggleProximity,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Layer 1: faint geofence rings
            Positioned.fill(
              child: CustomPaint(painter: _RingsPainter(p: p, isNear: isNear)),
            ),

            // Layer 2: one soft pulse ring (only when on premises)
            if (isNear)
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  final t = _pulse.value;
                  return Opacity(
                    opacity: (1 - t) * 0.35,
                    child: Container(
                      width: 120 + t * 70,
                      height: 120 + t * 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: p.brand, width: 1.5),
                      ),
                    ),
                  );
                },
              ),

            // Layer 3: the shield
            Transform.translate(
              offset: const Offset(0, -10),
              child: _ShieldGraphic(p: p, isNear: isNear),
            ),

            // Layer 4: two small status chips
            Positioned(
              bottom: 30,
              left: 0,
              child: _Chip(
                p: p,
                icon: isNear ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                label: isNear ? 'Wi-Fi verified' : 'Wi-Fi not detected',
                active: isNear,
              ),
            ),
            Positioned(
              bottom: 30,
              right: 0,
              child: _Chip(
                p: p,
                icon: isNear ? Icons.fingerprint_rounded : Icons.lock_outline_rounded,
                label: isNear ? 'Biometrics ready' : 'Biometrics locked',
                active: isNear,
              ),
            ),

            // Layer 5: test hint (debug builds only)
            if (kDebugMode)
              Positioned(
                bottom: 6,
                child: Text(
                  'Tap to toggle test mode',
                  style: Z01Theme.monoStyle(
                    context: context,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: p.muted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shield + keyhole (near) or padlock (far).
class _ShieldGraphic extends StatelessWidget {
  final Z01Palette p;
  final bool isNear;
  const _ShieldGraphic({required this.p, required this.isNear});

  @override
  Widget build(BuildContext context) {
    const w = 104.0;
    const h = 126.0;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(w, h),
            painter: _ShieldPainter(p: p, isNear: isNear),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: isNear
                ? Column(
                    key: const ValueKey('unlocked'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(10, 15),
                        painter: const _KeyholeStemPainter(),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('locked'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded, size: 30, color: p.muted),
                      const SizedBox(height: 4),
                      Text(
                        'LOCKED',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: p.muted,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _KeyholeStemPainter extends CustomPainter {
  const _KeyholeStemPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _KeyholeStemPainter oldDelegate) => false;
}

/// Flat shield: solid fill, a soft highlight on the top edge, a thin outline.
class _ShieldPainter extends CustomPainter {
  final Z01Palette p;
  final bool isNear;
  const _ShieldPainter({required this.p, required this.isNear});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shield = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.25, -2, w * 0.04, h * 0.05, 0, h * 0.20)
      ..lineTo(0, h * 0.52)
      ..cubicTo(0, h * 0.78, w * 0.30, h * 0.94, w * 0.5, h)
      ..cubicTo(w * 0.70, h * 0.94, w, h * 0.78, w, h * 0.52)
      ..lineTo(w, h * 0.20)
      ..cubicTo(w * 0.96, h * 0.05, w * 0.75, -2, w * 0.5, 0)
      ..close();

    // Solid fill
    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.fill
        ..color = isNear ? p.brand : p.cardElevated,
    );

    // Soft highlight across the upper part
    final highlight = Path()
      ..moveTo(w * 0.5, 3)
      ..cubicTo(w * 0.26, 1, w * 0.07, h * 0.07, 3, h * 0.22)
      ..lineTo(3, h * 0.40)
      ..cubicTo(w * 0.3, h * 0.30, w * 0.7, h * 0.30, w - 3, h * 0.40)
      ..lineTo(w - 3, h * 0.22)
      ..cubicTo(w * 0.93, h * 0.07, w * 0.74, 1, w * 0.5, 3)
      ..close();
    canvas.drawPath(
      highlight,
      Paint()..color = Colors.white.withValues(alpha: isNear ? 0.14 : 0.05),
    );

    // Thin outline
    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = isNear ? p.brand : p.muted.withValues(alpha: 0.6),
    );
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter old) =>
      old.isNear != isNear || old.p.bg != p.bg;
}

/// Faint concentric rings (the 50 / 100 / 150 m perimeters).
class _RingsPainter extends CustomPainter {
  final Z01Palette p;
  final bool isNear;
  const _RingsPainter({required this.p, required this.isNear});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.46);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = p.border;

    canvas.drawCircle(center, 55, paint);
    canvas.drawCircle(center, 90, paint);
    canvas.drawCircle(center, 125, paint);

    // The innermost ring picks up the brand colour when on premises.
    if (isNear) {
      canvas.drawCircle(
        center,
        55,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = p.brand.withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter old) =>
      old.isNear != isNear || old.p.bg != p.bg;
}

/// Small status chip (Wi-Fi, biometrics).
class _Chip extends StatelessWidget {
  final Z01Palette p;
  final IconData icon;
  final String label;
  final bool active;
  const _Chip({
    required this.p,
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: p.cardElevated,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: active ? p.brand : p.muted),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: p.text),
          ),
        ],
      ),
    );
  }
}