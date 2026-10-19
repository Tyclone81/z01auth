import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import '../../models/presence_state.dart';
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
  PresenceState _currentState = PresenceState.checkedIn;
  bool _isPinging = false;
  String _lastSeenTime = '04:19:02 PM';
  String _latestLogTime = '16:19';

  final List<DetectionLog> _recentDetections = [
    const DetectionLog(
      id: 'ping_992',
      timeEat: '16:19',
      title: 'Wi-Fi Heartbeat (Auto)',
      subtitle: 'BSSID: 00:1A:2B:3C:4D:5E',
      triggerType: 'WIFI_HEARTBEAT',
    ),
    const DetectionLog(
      id: 'ping_901',
      timeEat: '08:42',
      title: 'First Check-In (Time In)',
      subtitle: 'Door Wi-Fi + GPS Handshake',
      triggerType: 'BIOMETRIC_CHECKIN',
    ),
  ];

  void _cycleRadarState() {
    setState(() {
      if (_currentState == PresenceState.checkedIn) {
        _currentState = PresenceState.approaching;
      } else if (_currentState == PresenceState.approaching) {
        _currentState = PresenceState.offPremises;
      } else {
        _currentState = PresenceState.checkedIn;
      }
    });
  }

  void _triggerBiometricSync() {
    if (_currentState == PresenceState.offPremises) {
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
      onSuccess: _sendHeartbeatPing,
    );
  }

  void _sendHeartbeatPing() async {
    setState(() => _isPinging = true);

    await Future.delayed(const Duration(milliseconds: 700));

    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = now.minute.toString().padLeft(2, '0');
    final secondStr = now.second.toString().padLeft(2, '0');
    final formattedTime = '${hour.toString().padLeft(2, '0')}:$minuteStr:$secondStr $period';
    final shortTime = '${now.hour.toString().padLeft(2, '0')}:$minuteStr';

    if (mounted) {
      setState(() {
        _isPinging = false;
        _lastSeenTime = formattedTime;
        _latestLogTime = shortTime;
        _recentDetections.insert(
          0,
          DetectionLog(
            id: 'ping_${now.millisecondsSinceEpoch}',
            timeEat: shortTime,
            title: 'Biometric Attendance Sync',
            subtitle: 'Go Backend Heartbeat Synced',
            triggerType: 'MANUAL_BIOMETRIC_SYNC',
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Attendance Synced with Go Backend at $shortTime ✓',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar with Brand, Synced Pill, Switcher, Menu Trigger, Avatar
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
                              _isPinging ? '● SYNCING' : '● SYNCED',
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
                        onPressed: _cycleRadarState,
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
                state: _currentState,
                onTap: _cycleRadarState,
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
                    _currentState == PresenceState.checkedIn
                        ? 'Wi-Fi: Z01_Campus_5G ✓'
                        : _currentState == PresenceState.approaching
                            ? 'Wi-Fi: Scanning...'
                            : 'Wi-Fi: Disconnected',
                    isVerified: _currentState == PresenceState.checkedIn,
                  ),
                  _statusPill(
                    context,
                    _currentState != PresenceState.offPremises
                        ? 'GPS: Inside Premises ✓'
                        : 'GPS: Outside (>150m)',
                    isVerified: _currentState != PresenceState.offPremises,
                  ),
                  _statusPill(
                    context,
                    _currentState == PresenceState.checkedIn
                        ? 'Biometrics: Verified ✓'
                        : _currentState == PresenceState.approaching
                            ? 'Biometrics: Unlocked'
                            : 'Biometrics: Locked 🔒',
                    isVerified: _currentState == PresenceState.checkedIn,
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
                            '08:42:10 AM',
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
                            _lastSeenTime,
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
                    backgroundColor: _currentState != PresenceState.offPremises ? accentCol : cardBg,
                    foregroundColor: _currentState != PresenceState.offPremises ? accentFg : mutedCol,
                    side: _currentState != PresenceState.offPremises ? null : BorderSide(color: borderCol),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: _currentState != PresenceState.offPremises ? 2 : 0,
                  ),
                  onPressed: _currentState != PresenceState.offPremises ? _triggerBiometricSync : null,
                  icon: _isPinging
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: accentFg),
                        )
                      : Icon(
                          _currentState != PresenceState.offPremises ? Icons.fingerprint_rounded : Icons.lock_outline_rounded,
                          size: 18,
                        ),
                  label: Text(
                    _currentState == PresenceState.checkedIn
                        ? 'Biometric Verify & Sync Attendance'
                        : _currentState == PresenceState.approaching
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
                  itemCount: _recentDetections.length,
                  separatorBuilder: (_, _) => Divider(color: borderCol, height: 1),
                  itemBuilder: (context, index) {
                    final log = _recentDetections[index];
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
                            log.timeEat == '16:19' ? _latestLogTime : log.timeEat,
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
