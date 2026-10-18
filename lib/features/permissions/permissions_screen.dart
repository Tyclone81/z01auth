import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';

/// Item model for permissions checklist
class PermissionItem {
  final String title;
  final String description;
  bool isGranted;
  final String stepNumber;

  PermissionItem({
    required this.title,
    required this.description,
    required this.isGranted,
    required this.stepNumber,
  });
}

/// Frame 2: 02_Permissions (Android 10+ Permission Onboarding)
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final List<PermissionItem> _items = [
    PermissionItem(
      title: 'Precise Location (GPS)',
      description: 'Detects when you enter the 50m campus perimeter.',
      isGranted: true,
      stepNumber: '1',
    ),
    PermissionItem(
      title: 'Background Location',
      description: 'Select "Allow all the time" so Time-In logs hands-free.',
      isGranted: false,
      stepNumber: '2',
    ),
    PermissionItem(
      title: 'Wi-Fi State & BSSID',
      description: 'Verifies hardware MAC address of the premises router.',
      isGranted: true,
      stepNumber: '3',
    ),
    PermissionItem(
      title: 'On-Premises Biometrics',
      description: 'Fingerprint / Face ID unlocked only when inside campus perimeter.',
      isGranted: true,
      stepNumber: '4',
    ),
  ];

  void _togglePermission(int index) {
    setState(() {
      _items[index].isGranted = !_items[index].isGranted;
    });

    if (_items[index].isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          content: Text(
            '${_items[index].title}: Permission Granted ✓',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  void _handleContinue() {
    // If background location is not granted, auto-grant it on continue or proceed
    setState(() {
      for (var item in _items) {
        item.isGranted = true;
      }
    });

    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final cardElevated = isDark ? Z01Colors.darkCardElevated : Z01Colors.lightCardElevated;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;
    final accentCol = isDark ? Z01Colors.darkAccent : Z01Colors.lightAccent;
    final accentFg = isDark ? Z01Colors.darkAccentFg : Z01Colors.lightAccentFg;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '02_Permissions',
          style: Z01Theme.monoStyle(context: context, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Android 10+ Flow',
                style: Z01Theme.monoStyle(context: context, fontSize: 11, color: mutedCol),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textCol),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: textCol,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'STEP 2 OF 2',
                  style: Z01Theme.monoStyle(
                    context: context,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enable Auto-Check-In',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 6),
              Text(
                'Android requires fine location permissions to read the premises Wi-Fi BSSID and mark hands-free attendance.',
                style: TextStyle(color: mutedCol, fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 18),

              // Checklist Cards
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final isGranted = item.isGranted;

                    return GestureDetector(
                      onTap: () => _togglePermission(index),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isGranted ? borderStrong : borderCol,
                            width: isGranted ? 1.4 : 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              margin: const EdgeInsets.only(top: 2, right: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isGranted ? textCol : cardElevated,
                                border: Border.all(color: isGranted ? textCol : borderCol),
                              ),
                              alignment: Alignment.center,
                              child: isGranted
                                  ? Icon(Icons.check, size: 14, color: isDark ? Colors.black : Colors.white)
                                  : Text(
                                      item.stepNumber,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textCol),
                                    ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: textCol,
                                        ),
                                      ),
                                      Text(
                                        isGranted ? 'GRANTED' : 'REQUIRED',
                                        style: Z01Theme.monoStyle(
                                          context: context,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isGranted ? textCol : mutedCol,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: TextStyle(color: mutedCol, fontSize: 11, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom CTA
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentCol,
                    foregroundColor: accentFg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  onPressed: _handleContinue,
                  child: const Text(
                    'Continue to Live Radar →',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
