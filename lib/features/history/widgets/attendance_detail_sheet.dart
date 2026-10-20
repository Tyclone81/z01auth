import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';
import '../../../models/presence_state.dart';

/// Modal sheet showing detailed audit trail and timestamps for an attendance day
class AttendanceDetailSheet extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceDetailSheet({super.key, required this.record});

  static void show(BuildContext context, AttendanceRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => AttendanceDetailSheet(record: record),
    );
  }

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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.dateTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Zone01 Campus • Verification Audit',
                      style: TextStyle(color: mutedCol, fontSize: 11),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: record.isActive ? textCol : cardBg,
                    border: Border.all(color: borderStrong),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    record.isActive ? 'ACTIVE TODAY' : record.duration,
                    style: Z01Theme.monoStyle(
                      context: context,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: record.isActive
                          ? (isDark ? Colors.black : Colors.white)
                          : textCol,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time In / Time Out Breakdown Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderCol),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('First Seen (Time In):', style: TextStyle(color: mutedCol, fontSize: 12)),
                      Text(
                        record.timeIn,
                        style: Z01Theme.monoStyle(context: context, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last Seen (Time Out):', style: TextStyle(color: mutedCol, fontSize: 12)),
                      Text(
                        record.timeOut,
                        style: Z01Theme.monoStyle(context: context, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(color: borderCol, height: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Campus Wi-Fi BSSID:', style: TextStyle(color: mutedCol, fontSize: 12)),
                      Text(
                        '00:1a:2b:3c:4d:5e',
                        style: Z01Theme.monoStyle(context: context, fontSize: 11, color: mutedCol),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biometric Status:', style: TextStyle(color: mutedCol, fontSize: 12)),
                      Text(
                        'Verified On-Premises ✓',
                        style: Z01Theme.monoStyle(context: context, fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderCol),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Close Audit', style: TextStyle(color: textCol, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
