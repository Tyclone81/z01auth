import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import '../../models/presence_state.dart';

/// Frame 3 Skeleton: 03_Dashboard (Live Radar)
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PresenceState _currentState = PresenceState.checkedIn;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final borderStrong = isDark ? Z01Colors.darkBorderStrong : Z01Colors.lightBorderStrong;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
                      Text('Z01auth', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 2),
                      Text(
                        'Wed, Oct 14 • Zone01 Campus',
                        style: Z01Theme.monoStyle(context: context, fontSize: 11),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: textCol,
                    radius: 18,
                    child: Text(
                      'AB',
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Central Radar Ring Skeleton
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cardBg,
                  border: Border.all(color: borderStrong, width: 2.5),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('((•))', style: Z01Theme.monoStyle(context: context, fontSize: 20)),
                    const SizedBox(height: 6),
                    Text(
                      _currentState == PresenceState.checkedIn ? 'CHECKED IN' : 'OFF PREMISES',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: textCol),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
