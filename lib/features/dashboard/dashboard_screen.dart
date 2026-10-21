import 'package:flutter/material.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/theme/z01_theme.dart';
import '../../models/presence_state.dart';
import '../../services/attendance_service.dart';
import '../auth/widgets/biometric_auth_modal.dart';
import 'widgets/radar_ring.dart';
import 'widgets/settings_drawer.dart';

/// Frame 3: 03_Dashboard (Live Radar & Heartbeat Dashboard)
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AttendanceService _attendanceService = AttendanceService.instance;

  @override
  void initState() {
    super.initState();
    _attendanceService.initialize();
  }

  void _triggerBiometricSync() {
    if (_attendanceService.presenceState == PresenceState.offPremises) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔒 Biometrics blocked: Move near campus perimeter to unlock.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    BiometricAuthModal.show(
      context: context,
      title: 'Confirm Presence Biometrics',
      subtitle: 'Scan your fingerprint while on Z01_Campus_5G to sync attendance.',
      proximityTag: 'ON-PREMISES VERIFIED',
      onSuccess: () async {
        final success = await _attendanceService.authenticateAndSync(
          triggerType: AttendanceTriggerType.manualBiometricSync,
        );
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              content: Text('Attendance Synced with Go Backend ✓', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;
    final accentCol = isDark ? Z01Colors.darkAccent : Z01Colors.lightAccent;
    final accentFg = isDark ? Z01Colors.darkAccentFg : Z01Colors.lightAccentFg;

    return ListenableBuilder(
      listenable: _attendanceService,
      builder: (context, _) {
        final currentState = _attendanceService.presenceState;
        final isPinging = _attendanceService.isSyncing;
        final lastSeenTime = _attendanceService.lastSeenEat;
        final detections = _attendanceService.recentDetections;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Z01auth', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: textCol,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isPinging ? '● SYNCING' : '● SYNCED',
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
                          const SizedBox(height: 2),
                          Text('Wed, Oct 14 • Zone01 Campus', style: TextStyle(color: mutedCol, fontSize: 11)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Cycle Radar State',
                            icon: const Icon(Icons.tune_rounded, size: 20),
                            onPressed: _attendanceService.cycleStateForDemo,
                          ),
                          IconButton(
                            tooltip: 'Settings Menu',
                            icon: const Icon(Icons.menu_rounded, size: 22),
                            onPressed: () => SettingsDrawer.show(context),
                          ),
                          const SizedBox(width: 4),
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: textCol,
                            child: Text(
                              'AB',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Presence Radar Ring
                  PresenceRadarRing(
                    state: currentState,
                    onTap: _attendanceService.cycleStateForDemo,
                  ),
                  const SizedBox(height: 16),

                  // Verification Status Pills
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      _statusPill(
                        context,
                        currentState == PresenceState.checkedIn
                            ? 'Wi-Fi: Z01_Campus_5G ✓'
                            : currentState == PresenceState.approaching
                                ? 'Wi-Fi: Scanning...'
                                : 'Wi-Fi: Disconnected',
                        isVerified: currentState == PresenceState.checkedIn,
                      ),
                      _statusPill(
                        context,
                        currentState != PresenceState.offPremises
                            ? 'GPS: Inside Premises ✓'
                            : 'GPS: Outside (>150m)',
                        isVerified: currentState != PresenceState.offPremises,
                      ),
                      _statusPill(
                        context,
                        currentState == PresenceState.checkedIn
                            ? 'Biometrics: Verified ✓'
                            : currentState == PresenceState.approaching
                                ? 'Biometrics: Unlocked'
                                : 'Biometrics: Locked 🔒',
                        isVerified: currentState == PresenceState.checkedIn,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 2-Column Summary Cards (FIRST SEEN & LAST SEEN)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderCol),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'FIRST SEEN (IN)',
                                    style: Z01Theme.monoStyle(context: context, fontSize: 9, color: mutedCol, fontWeight: FontWeight.w700),
                                  ),
                                  Icon(Icons.lock_outline_rounded, size: 13, color: textCol),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _attendanceService.firstSeenEat,
                                style: Z01Theme.monoStyle(context: context, fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text('Locked for today', style: TextStyle(color: mutedCol, fontSize: 9)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderCol),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'LAST SEEN (OUT)',
                                    style: Z01Theme.monoStyle(context: context, fontSize: 9, color: mutedCol, fontWeight: FontWeight.w700),
                                  ),
                                  Icon(Icons.sync_rounded, size: 14, color: textCol),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                lastSeenTime,
                                style: Z01Theme.monoStyle(context: context, fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text('Updates on Wi-Fi', style: TextStyle(color: mutedCol, fontSize: 9)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentState != PresenceState.offPremises ? accentCol : cardBg,
                        foregroundColor: currentState != PresenceState.offPremises ? accentFg : mutedCol,
                        side: currentState != PresenceState.offPremises ? null : BorderSide(color: borderCol),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: currentState != PresenceState.offPremises ? 2 : 0,
                      ),
                      onPressed: currentState != PresenceState.offPremises ? _triggerBiometricSync : null,
                      icon: isPinging
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: accentFg),
                            )
                          : Icon(
                              currentState != PresenceState.offPremises ? Icons.fingerprint_rounded : Icons.lock_outline_rounded,
                              size: 18,
                            ),
                      label: Text(
                        currentState == PresenceState.checkedIn
                            ? 'Biometric Verify & Sync Attendance'
                            : currentState == PresenceState.approaching
                                ? 'Scan Fingerprint to Check In'
                                : '🔒 Move Near Campus to Unlock',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Recent Detections List
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RECENT DETECTIONS',
                      style: Z01Theme.monoStyle(
                        context: context,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: mutedCol,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderCol),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: detections.length,
                      separatorBuilder: (_, _) => Divider(color: borderCol, height: 1),
                      itemBuilder: (context, index) {
                        final log = detections[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: textCol,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      log.title,
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: textCol),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      log.subtitle,
                                      style: Z01Theme.monoStyle(context: context, fontSize: 9, color: mutedCol),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                log.timeEat,
                                style: Z01Theme.monoStyle(context: context, fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _statusPill(BuildContext context, String text, {required bool isVerified}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isVerified ? borderStrong : borderCol, width: isVerified ? 1.2 : 1),
      ),
      child: Text(
        text,
        style: Z01Theme.monoStyle(
          context: context,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: isVerified ? textCol : mutedCol,
        ),
      ),
    );
  }
}
