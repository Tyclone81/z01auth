import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import '../../models/presence_state.dart';
import 'widgets/attendance_detail_sheet.dart';

/// Frame 4: 04_History (Monthly Attendance Log & Summary)
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedMonth = 'Oct 2026';

  final AttendanceSummaryStats _summary = const AttendanceSummaryStats(
    daysPresent: 18,
    avgHours: 8.4,
    verificationRatePercent: 100,
  );

  final List<AttendanceRecord> _records = [
    const AttendanceRecord(
      date: '2026-10-21',
      dateTitle: 'Today — Wed, Oct 21',
      timeIn: '08:42 AM',
      timeOut: '04:19 PM',
      duration: '7h 37m',
      isActive: true,
      status: 'ACTIVE',
    ),
    const AttendanceRecord(
      date: '2026-10-20',
      dateTitle: 'Tue, Oct 20',
      timeIn: '08:39 AM',
      timeOut: '05:12 PM',
      duration: '8h 33m',
      isActive: false,
      status: 'COMPLETED',
    ),
    const AttendanceRecord(
      date: '2026-10-19',
      dateTitle: 'Mon, Oct 19',
      timeIn: '08:15 AM',
      timeOut: '05:19 PM',
      duration: '9h 04m',
      isActive: false,
      status: 'COMPLETED',
    ),
    const AttendanceRecord(
      date: '2026-10-16',
      dateTitle: 'Fri, Oct 16',
      timeIn: '09:02 AM',
      timeOut: '04:52 PM',
      duration: '7h 50m',
      isActive: false,
      status: 'COMPLETED',
    ),
    const AttendanceRecord(
      date: '2026-10-15',
      dateTitle: 'Thu, Oct 15',
      timeIn: '08:30 AM',
      timeOut: '05:00 PM',
      duration: '8h 30m',
      isActive: false,
      status: 'COMPLETED',
    ),
    const AttendanceRecord(
      date: '2026-10-14',
      dateTitle: 'Wed, Oct 14',
      timeIn: '08:45 AM',
      timeOut: '05:15 PM',
      duration: '8h 30m',
      isActive: false,
      status: 'COMPLETED',
    ),
  ];

  void _switchMonth() {
    setState(() {
      _selectedMonth = _selectedMonth == 'Oct 2026' ? 'Sep 2026' : 'Oct 2026';
    });
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Month Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Attendance Log', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                  GestureDetector(
                    onTap: _switchMonth,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderCol),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedMonth,
                            style: Z01Theme.monoStyle(context: context, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 16, color: textCol),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Monthly Summary Strip (3 Columns)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderStrong, width: 1.2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _statColumn(context, 'PRESENT', '${_summary.daysPresent}d'),
                    ),
                    Container(width: 1, height: 28, color: borderCol),
                    Expanded(
                      child: _statColumn(context, 'AVG HOURS', '${_summary.avgHours}h'),
                    ),
                    Container(width: 1, height: 28, color: borderCol),
                    Expanded(
                      child: _statColumn(context, 'VERIFIED', '${_summary.verificationRatePercent}%'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Daily Log Cards
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _records.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _records[index];
                    return GestureDetector(
                      onTap: () => AttendanceDetailSheet.show(context, item),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: item.isActive ? borderStrong : borderCol,
                            width: item.isActive ? 1.4 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.dateTitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: item.isActive ? FontWeight.w800 : FontWeight.w600,
                                    color: textCol,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: item.isActive ? textCol : cardElevated,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.isActive ? 'Active' : item.duration,
                                    style: Z01Theme.monoStyle(
                                      context: context,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: item.isActive
                                          ? (isDark ? Colors.black : Colors.white)
                                          : textCol,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'IN: ',
                                        style: Z01Theme.monoStyle(context: context, fontSize: 11, color: mutedCol),
                                      ),
                                      TextSpan(
                                        text: item.timeIn,
                                        style: Z01Theme.monoStyle(context: context, fontSize: 11, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('→', style: TextStyle(color: mutedCol, fontSize: 11)),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item.isActive ? 'LAST: ' : 'OUT: ',
                                        style: Z01Theme.monoStyle(context: context, fontSize: 11, color: mutedCol),
                                      ),
                                      TextSpan(
                                        text: item.timeOut,
                                        style: Z01Theme.monoStyle(context: context, fontSize: 11, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _statColumn(BuildContext context, String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedCol = isDark ? Z01Colors.darkMuted : Z01Colors.lightMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Z01Theme.monoStyle(context: context, fontSize: 8, color: mutedCol, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(value, style: Z01Theme.monoStyle(context: context, fontSize: 15, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
