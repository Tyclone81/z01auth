import 'package:flutter/material.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/z01_theme.dart';

/// In-App Settings & Theme Modal Drawer matching Frame 3 Figma Spec
class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const SettingsDrawer(),
    );
  }

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  bool _wifiPollingEnabled = true;
  final bool _proximityGatingEnforced = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgCol = isDark ? Z01Colors.darkBg : Z01Colors.lightBg;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;

    return Container(
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: borderStrong, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: mutedCol.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MENU & SETTINGS',
                      style: Z01Theme.monoStyle(
                        context: context,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'alex.b@zone01kisumu.ke',
                      style: TextStyle(color: mutedCol, fontSize: 11),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Monochrome Theme Selector Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderStrong, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Appearance Theme',
                        style: TextStyle(color: textCol, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: textCol,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isDark ? 'BLACK' : 'WHITE',
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isDark ? Colors.black : Colors.transparent,
                            side: BorderSide(
                              color: isDark ? Colors.white : borderCol,
                              width: isDark ? 2 : 1,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            ThemeController.instance.setDark();
                          },
                          child: Text(
                            '● Black (Dark)',
                            style: TextStyle(
                              color: isDark ? Colors.white : mutedCol,
                              fontWeight: isDark ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: !isDark ? Colors.white : Colors.transparent,
                            side: BorderSide(
                              color: !isDark ? Colors.black : borderCol,
                              width: !isDark ? 2 : 1,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            ThemeController.instance.setLight();
                          },
                          child: Text(
                            '○ White (Light)',
                            style: TextStyle(
                              color: !isDark ? Colors.black : mutedCol,
                              fontWeight: !isDark ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Background Wi-Fi Polling Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderCol),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Background Wi-Fi Polling', style: TextStyle(color: textCol, fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text('Ping Go server every 5m on campus', style: TextStyle(color: mutedCol, fontSize: 10)),
                    ],
                  ),
                  Switch(
                    value: _wifiPollingEnabled,
                    activeThumbColor: textCol,
                    onChanged: (val) => setState(() => _wifiPollingEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Proximity-Gated Biometrics Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderCol),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Proximity-Gated Biometrics', style: TextStyle(color: textCol, fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text('Require campus GPS/Wi-Fi to unlock', style: TextStyle(color: mutedCol, fontSize: 10)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: textCol,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _proximityGatingEnforced ? 'ENFORCED' : 'OFF',
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
            const SizedBox(height: 14),

            // Sign Out Row
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderCol),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                },
                child: Text('Sign Out of Google Account', style: TextStyle(color: textCol, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
