import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';

/// The interactive Lock & Shield centerpiece for Z01auth, inspired by modern fintech UI/UX.
/// Features a vector-drawn glowing security shield, subtle campus perimeter radar grid,
/// and floating contextual status chips that react dynamically to proximity gating.
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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNear = widget.isNearPremises;

    final cardBg = isDark ? const Color(0xFF0A0D12) : const Color(0xFFF8FAFD);
    final borderCol = isDark
        ? (isNear ? Z01Colors.electricBlue.withValues(alpha: 0.4) : Z01Colors.darkBorder)
        : (isNear ? Z01Colors.electricBlue.withValues(alpha: 0.3) : Z01Colors.lightBorder);

    return GestureDetector(
      onTap: widget.onToggleProximity,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderCol, width: isNear ? 1.5 : 1.0),
          boxShadow: [
            BoxShadow(
              color: isNear
                  ? Z01Colors.electricBlue.withValues(alpha: isDark ? 0.15 : 0.08)
                  : Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Layer 1: Campus perimeter radar map grid
              Positioned.fill(
                child: CustomPaint(
                  painter: _CampusRadarGridPainter(
                    isNear: isNear,
                    isDark: isDark,
                  ),
                ),
              ),

              // Layer 2: Ambient backlight radial glow
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final glowScale = 1.0 + (_pulseAnimation.value * 0.15);
                  final glowOpacity = isNear
                      ? (isDark ? 0.28 : 0.20) + (_pulseAnimation.value * 0.10)
                      : (isDark ? 0.14 : 0.08);

                  return Transform.scale(
                    scale: glowScale,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            (isNear ? Z01Colors.cyanGlow : Z01Colors.lockedAmber)
                                .withValues(alpha: glowOpacity),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Layer 3: Central Glowing Shield with Lock / Keyhole
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final floatOffset = isNear ? math.sin(_pulseAnimation.value * math.pi) * 3 : 0.0;
                  return Transform.translate(
                    offset: Offset(0, -4 + floatOffset),
                    child: _ShieldLockGraphic(
                      isNear: isNear,
                      isDark: isDark,
                    ),
                  );
                },
              ),

              // Layer 4: Top Floating Chip (Campus Hub / Proximity Range)
              Positioned(
                top: 14,
                child: _FloatingChip(
                  icon: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isNear ? Z01Colors.verifiedGreen : Z01Colors.lockedAmber,
                      boxShadow: [
                        BoxShadow(
                          color: (isNear ? Z01Colors.verifiedGreen : Z01Colors.lockedAmber)
                              .withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  label: isNear ? 'ZONE01 HUB • 18m IN RANGE' : 'OFF PREMISES • >150m GATED',
                  isDark: isDark,
                ),
              ),

              // Layer 5: Bottom Left Floating Chip (Wi-Fi BSSID)
              Positioned(
                bottom: 28,
                left: 14,
                child: _FloatingChip(
                  icon: Icon(
                    isNear ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    size: 13,
                    color: isNear ? Z01Colors.electricBlue : (isDark ? Colors.white54 : Colors.black45),
                  ),
                  label: isNear ? 'Z01_Campus_5G' : 'Wi-Fi Unverified',
                  isDark: isDark,
                ),
              ),

              // Layer 6: Bottom Right Floating Chip (Biometric Status)
              Positioned(
                bottom: 28,
                right: 14,
                child: _FloatingChip(
                  icon: Icon(
                    isNear ? Icons.fingerprint_rounded : Icons.lock_outline_rounded,
                    size: 13,
                    color: isNear ? Z01Colors.cyanGlow : Z01Colors.lockedAmber,
                  ),
                  label: isNear ? 'Biometrics Armed' : 'Biometrics Locked',
                  isDark: isDark,
                ),
              ),

              // Layer 7: Interactive tap prompt footer
              Positioned(
                bottom: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app_rounded,
                      size: 11,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tap card to toggle proximity simulation',
                      style: Z01Theme.monoStyle(
                        context: context,
                        fontSize: 9,
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The vector-drawn shield with an illuminated lock/keyhole cutout at its core.
class _ShieldLockGraphic extends StatelessWidget {
  final bool isNear;
  final bool isDark;

  const _ShieldLockGraphic({
    required this.isNear,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    const shieldWidth = 98.0;
    const shieldHeight = 118.0;

    return SizedBox(
      width: shieldWidth,
      height: shieldHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The vector shield canvas
          CustomPaint(
            size: const Size(shieldWidth, shieldHeight),
            painter: _ShieldPathPainter(
              isNear: isNear,
              isDark: isDark,
            ),
          ),

          // Central Lock / Keyhole Icon with smooth transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: isNear
                ? Column(
                    key: const ValueKey('unlocked'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Keyhole cutout design
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      CustomPaint(
                        size: const Size(10, 14),
                        painter: _KeyholeStemPainter(color: Colors.white),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('locked'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Secure closed padlock
                      Icon(
                        Icons.lock_rounded,
                        size: 28,
                        color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Z01Colors.lockedAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Z01Colors.lockedAmber.withValues(alpha: 0.6),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'LOCKED',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: Z01Colors.lockedAmber,
                          ),
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

/// Custom painter for the tapered keyhole stem
class _KeyholeStemPainter extends CustomPainter {
  final Color color;
  const _KeyholeStemPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _KeyholeStemPainter oldDelegate) => oldDelegate.color != color;
}

/// Custom painter rendering the sleek beveled shield path and specular highlights
class _ShieldPathPainter extends CustomPainter {
  final bool isNear;
  final bool isDark;

  const _ShieldPathPainter({
    required this.isNear,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Vector Path for a sleek modern shield with beveled shoulders and teardrop curve
    final shieldPath = Path();
    shieldPath.moveTo(w * 0.5, 0); // top center dip/arch
    // Top-left shoulder
    shieldPath.cubicTo(w * 0.25, -2, w * 0.04, h * 0.05, 0, h * 0.20);
    // Left edge downward
    shieldPath.lineTo(0, h * 0.52);
    // Left bottom curve to vertex
    shieldPath.cubicTo(0, h * 0.78, w * 0.30, h * 0.94, w * 0.5, h);
    // Right bottom curve up from vertex
    shieldPath.cubicTo(w * 0.70, h * 0.94, w, h * 0.78, w, h * 0.52);
    // Right edge upward
    shieldPath.lineTo(w, h * 0.20);
    // Top-right shoulder back to center
    shieldPath.cubicTo(w * 0.96, h * 0.05, w * 0.75, -2, w * 0.5, 0);
    shieldPath.close();

    // Outer drop shadow
    final shadowPaint = Paint()
      ..color = (isNear ? Z01Colors.electricBlue : Colors.black)
          .withValues(alpha: isNear ? 0.35 : 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(shieldPath.shift(const Offset(0, 6)), shadowPaint);

    // Shield Body Gradient Fill
    final Rect rect = Offset.zero & size;
    final Paint bodyPaint = Paint()..style = PaintingStyle.fill;

    if (isNear) {
      // Sleek vibrant royal-blue to cyan gradient (Fintech aesthetic)
      bodyPaint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E70FF),
          Color(0xFF0E61FA),
          Color(0xFF00C2FF),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect);
    } else {
      // Locked: Sleek gunmetal slate with subtle dark sheen
      bodyPaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? const [
                Color(0xFF2A2E39),
                Color(0xFF181B22),
                Color(0xFF0F1217),
              ]
            : const [
                Color(0xFFE2E8F0),
                Color(0xFFCBD5E1),
                Color(0xFF94A3B8),
              ],
      ).createShader(rect);
    }

    canvas.drawPath(shieldPath, bodyPaint);

    // Gloss specular highlight on upper-left curve
    final highlightPath = Path();
    highlightPath.moveTo(w * 0.5, 3);
    highlightPath.cubicTo(w * 0.26, 1, w * 0.07, h * 0.07, 3, h * 0.22);
    highlightPath.lineTo(3, h * 0.45);
    highlightPath.cubicTo(w * 0.15, h * 0.32, w * 0.35, h * 0.12, w * 0.5, 3);
    highlightPath.close();

    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: isNear ? 0.45 : 0.25),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(rect);

    canvas.drawPath(highlightPath, highlightPaint);

    // Shield Border Rim
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isNear
            ? [
                Colors.white.withValues(alpha: 0.8),
                Z01Colors.cyanGlow,
                Z01Colors.electricBlue.withValues(alpha: 0.6),
              ]
            : [
                (isDark ? Colors.white30 : Colors.black26),
                (isDark ? Colors.white10 : Colors.black12),
              ],
      ).createShader(rect);

    canvas.drawPath(shieldPath, rimPaint);
  }

  @override
  bool shouldRepaint(covariant _ShieldPathPainter oldDelegate) {
    return oldDelegate.isNear != isNear || oldDelegate.isDark != isDark;
  }
}

/// Custom painter for the campus radar & perimeter street grid background
class _CampusRadarGridPainter extends CustomPainter {
  final bool isNear;
  final bool isDark;

  const _CampusRadarGridPainter({
    required this.isNear,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.46);

    final gridColor = isDark
        ? (isNear
            ? Z01Colors.electricBlue.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.05))
        : (isNear
            ? Z01Colors.electricBlue.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.04));

    final linePaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Concentric Geofence Rings (50m, 100m, 150m)
    canvas.drawCircle(center, 55, linePaint);
    canvas.drawCircle(center, 90, linePaint);
    canvas.drawCircle(center, 125, linePaint);

    // 2. Subtle diagonal street / corridor grid lines
    canvas.drawLine(Offset(0, h * 0.25), Offset(w, h * 0.35), linePaint);
    canvas.drawLine(Offset(0, h * 0.70), Offset(w, h * 0.60), linePaint);
    canvas.drawLine(Offset(w * 0.20, 0), Offset(w * 0.25, h), linePaint);
    canvas.drawLine(Offset(w * 0.80, 0), Offset(w * 0.75, h), linePaint);

    // 3. Compass crosshairs
    final crosshairPaint = Paint()
      ..color = gridColor.withValues(alpha: gridColor.a * 1.5)
      ..strokeWidth = 0.8;

    canvas.drawLine(Offset(center.dx - 18, center.dy), Offset(center.dx + 18, center.dy), crosshairPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 18), Offset(center.dx, center.dy + 18), crosshairPaint);
  }

  @override
  bool shouldRepaint(covariant _CampusRadarGridPainter oldDelegate) {
    return oldDelegate.isNear != isNear || oldDelegate.isDark != isDark;
  }
}

/// Floating pill badge mimicking the micro-cards from the Dribbble fintech shot
class _FloatingChip extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isDark;

  const _FloatingChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final chipBg = isDark ? const Color(0xFF141820) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderCol, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            label,
            style: Z01Theme.monoStyle(
              context: context,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: textCol,
            ),
          ),
        ],
      ),
    );
  }
}
