import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import '../history/history_screen.dart';
import 'dashboard_screen.dart';
import 'widgets/settings_drawer.dart';

/// Shell managing bottom navigation between Frame 3 (Live Radar) and Frame 4 (History),
/// plus triggers for the in-app Settings Drawer.
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
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;
    final textCol = isDark ? Z01Colors.darkText : Z01Colors.lightText;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: cardBg,
          border: Border(top: BorderSide(color: borderCol, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              iconSymbol: '((•))',
              label: 'Live Radar',
              isSelected: _currentIndex == 0,
              textCol: textCol,
              mutedCol: mutedCol,
            ),
            _buildNavItem(
              index: 1,
              iconSymbol: '☰',
              label: 'History',
              isSelected: _currentIndex == 1,
              textCol: textCol,
              mutedCol: mutedCol,
            ),
            InkWell(
              onTap: () => SettingsDrawer.show(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('⚙', style: TextStyle(fontSize: 14, color: mutedCol)),
                    const SizedBox(height: 2),
                    Text('Settings', style: TextStyle(fontSize: 10, color: mutedCol)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconSymbol,
    required String label,
    required bool isSelected,
    required Color textCol,
    required Color mutedCol,
  }) {
    final color = isSelected ? textCol : mutedCol;
    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(iconSymbol, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
