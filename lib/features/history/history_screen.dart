import 'package:flutter/material.dart';
import '../../core/theme/z01_theme.dart';
import '../../models/presence_state.dart';
import 'widgets/attendance_detail_sheet.dart';

/// Frame 4: History (monthly summary + daily attendance log)
/// MOCK DATA for now. Real records come from the backend later.
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
    final p = Z01Palette.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header + month picker ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: p.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: _switchMonth,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: p.cardElevated,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedMonth,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: p.text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              size: 18, color: p.muted),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ---------- Summary ----------
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: p.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _statColumn(p, 'DAYS PRESENT', '${_summary.daysPresent}d'),
                    ),
                    Container(width: 1, height: 32, color: p.border),
                    Expanded(
                      child: _statColumn(p, 'AVG HOURS', '${_summary.avgHours}h'),
                    ),
                    Container(width: 1, height: 32, color: p.border),
                    Expanded(
                      child: _statColumn(
                          p, 'VERIFIED', '${_summary.verificationRatePercent}%'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'DAILY LOG',
                style: TextStyle(fontSize: 11, letterSpacing: 0.9, color: p.muted),
              ),
              const SizedBox(height: 10),

              // ---------- Daily cards ----------
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _records.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _recordCard(p, _records[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordCard(Z01Palette p, AttendanceRecord item) {
    return Material(
      color: p.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => AttendanceDetailSheet.show(context, item),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.isActive ? p.brand : p.border,
              width: item.isActive ? 1.4 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      item.dateTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.isActive ? p.brand : p.cardElevated,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      item.isActive ? 'Active' : item.duration,
                      style: Z01Theme.monoStyle(
                        context: context,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.isActive ? p.onBrand : p.text,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _timeBlock(p, 'IN', item.timeIn),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 16, color: p.muted),
                  ),
                  _timeBlock(p, item.isActive ? 'LAST SEEN' : 'OUT', item.timeOut),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeBlock(Z01Palette p, String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, letterSpacing: 0.8, color: p.muted),
        ),
        const SizedBox(height: 3),
        Text(
          time,
          style: Z01Theme.monoStyle(context: context, fontSize: 14),
        ),
      ],
    );
  }

  Widget _statColumn(Z01Palette p, String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 10, letterSpacing: 0.8, color: p.muted),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Z01Theme.monoStyle(context: context, fontSize: 20),
        ),
      ],
    );
  }
}