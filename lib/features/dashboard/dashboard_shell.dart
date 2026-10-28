import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import '../analytics/analytics_screen.dart';
import '../history/history_screen.dart';
import 'dashboard_screen.dart';
import 'widgets/settings_drawer.dart';

/// Bottom navigation: Live, History, Insights, plus the Settings drawer.
class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    HistoryScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final p = Z01Palette.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: p.bg,
          border: Border(top: BorderSide(color: p.border, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _navItem(p, 0, Icons.sensors_rounded, 'Live'),
                _navItem(p, 1, Icons.history_rounded, 'History'),
                _navItem(p, 2, Icons.insights_rounded, 'Insights'),
                _navItem(
                  p,
                  -1,
                  Icons.settings_outlined,
                  'Settings',
                  onTap: () => SettingsDrawer.show(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    Z01Palette p,
    int index,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    final selected = index == _currentIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap ?? () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: selected ? p.brand : p.muted),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? p.text : p.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}