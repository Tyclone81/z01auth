import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';

/// Frame 4 Skeleton: 04_History (Monthly Attendance Log)
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Z01Colors.darkCard : Z01Colors.lightCard;
    final borderCol = isDark ? Z01Colors.darkBorder : Z01Colors.lightBorder;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Attendance Log', style: Theme.of(context).textTheme.headlineMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderCol),
                    ),
                    child: Text('Oct 2026 ▾', style: Z01Theme.monoStyle(context: context, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderCol),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statColumn(context, 'PRESENT', '18d'),
                    _statColumn(context, 'AVG HOURS', '8.4h'),
                    _statColumn(context, 'VERIFIED', '100%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statColumn(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(title, style: Z01Theme.monoStyle(context: context, fontSize: 9, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: Z01Theme.monoStyle(context: context, fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
