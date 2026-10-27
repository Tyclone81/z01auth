import 'package:flutter/material.dart';
import '../../../core/theme/z01_theme.dart';
import '../../../models/presence_state.dart';

/// Bottom sheet with the details of one attendance day.
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
    final p = Z01Palette.of(context);

    return Container(
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: p.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: p.muted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title + status pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.dateTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: p.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Zone01 Kisumu',
                        style: TextStyle(color: p.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: record.isActive ? p.brand : p.cardElevated,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    record.isActive ? 'Active today' : record.duration,
                    style: Z01Theme.monoStyle(
                      context: context,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: record.isActive ? p.onBrand : p.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Time In / Time Out
            Row(
              children: [
                Expanded(
                  child: _timeCard(
                    context,
                    p,
                    label: 'FIRST SEEN · IN',
                    time: record.timeIn,
                    filled: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _timeCard(
                    context,
                    p,
                    label: record.isActive ? 'LAST SEEN' : 'LAST SEEN · OUT',
                    time: record.timeOut,
                    filled: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Verification details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: p.border),
              ),
              child: Column(
                children: [
                  _detailRow(
                    context,
                    p,
                    icon: Icons.wifi_rounded,
                    label: 'Wi-Fi access point',
                    // TODO: replace with the real BSSID stored on the record
                    value: '00:1a:2b:3c:4d:5e',
                    mono: true,
                  ),
                  Divider(color: p.border, height: 24),
                  _detailRow(
                    context,
                    p,
                    icon: Icons.fingerprint_rounded,
                    label: 'Biometrics',
                    value: 'Verified on campus',
                    mono: false,
                    highlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _timeCard(
    BuildContext context,
    Z01Palette p, {
    required String label,
    required String time,
    required bool filled,
  }) {
    final labelColor = filled ? p.onBrand : p.muted;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: filled ? p.brand : p.card,
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, letterSpacing: 0.8, color: labelColor),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: Z01Theme.monoStyle(
              context: context,
              fontSize: 18,
              color: filled ? p.onBrand : p.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    BuildContext context,
    Z01Palette p, {
    required IconData icon,
    required String label,
    required String value,
    required bool mono,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: highlight ? p.brand : p.muted),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: TextStyle(color: p.muted, fontSize: 13)),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: mono
              ? Z01Theme.monoStyle(
                  context: context,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: p.text,
                )
              : TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: p.text,
                ),
        ),
      ],
    );
  }
}