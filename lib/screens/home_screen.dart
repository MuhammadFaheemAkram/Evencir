import 'package:evencir_project/theme/app_colors_extension.dart';
import 'package:evencir_project/utils/app_icons.dart';
import 'package:evencir_project/utils/date_notifier.dart';
import 'package:evencir_project/widgets/calories_card.dart';
import 'package:evencir_project/widgets/hydration_card.dart';
import 'package:evencir_project/widgets/month_calendar_sheet.dart';
import 'package:evencir_project/widgets/section_header.dart';
import 'package:evencir_project/widgets/week_calendar.dart';
import 'package:evencir_project/widgets/weight_card.dart';
import 'package:evencir_project/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Today, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final dateNotifier = context.watch<DateNotifier>();
    final selectedDate = dateNotifier.selectedDate;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Align(
          child: AppIcons.svg(AppIcon.notification, color: colors.textPrimary),
        ),
        title: _WeekView(
          selectedDate: selectedDate,
          onDateChanged: dateNotifier.setDate,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // ── Date Label ──
                Text(
                  _formatDate(selectedDate),
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                // ── Week Calendar ──
                WeekCalendar(
                  selectedDate: selectedDate,
                  onDateSelected: dateNotifier.setDate,
                  // Sample activity dots — replace with real data source.
                  activityDots: _sampleActivityDots(selectedDate),
                ),
                const SizedBox(height: 28),
                // ── Workouts Section ──
                SectionHeader(
                  title: 'Workouts',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcons.svg(AppIcon.sun, color: colors.textPrimary),
                      const SizedBox(width: 6),
                      Text(
                        '9°',
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                WorkoutCard(
                  date: 'December 22',
                  duration: '25m - 30m',
                  title: 'Upper Body',
                  onTap: () {
                    // Navigate to workout detail
                  },
                ),
                const SizedBox(height: 32),
                // ── My Insights Section ──
                const SectionHeader(title: 'My Insights'),
                const SizedBox(height: 24),
                // Two side-by-side cards
                const SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: CaloriesCard(
                          consumed: 550,
                          remaining: 1950,
                          total: 2500,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(child: WeightCard(weight: 75, change: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Hydration card
                HydrationCard(
                  percentage: 0,
                  currentMl: 0,
                  toastMessage: '500 ml added to water log',
                  onLogNow: () {
                    // Log water intake
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Sample activity dots for the current week — replace with real data source.
  Map<DateTime, List<Color>> _sampleActivityDots(DateTime selectedDate) {
    final weekday = selectedDate.weekday;
    final monday = selectedDate.subtract(Duration(days: weekday - 1));
    return {
      // Monday (selected) — green
      DateTime(monday.year, monday.month, monday.day + 1): [
        const Color(0xFF27AE60),
      ],
      // Wednesday — grey
      DateTime(monday.year, monday.month, monday.day + 2): [
        const Color(0xFF5A6A7A),
      ],
      // Thursday — blue
      DateTime(monday.year, monday.month, monday.day + 3): [
        const Color(0xFF4A90D9),
      ],
      // Saturday — red
      DateTime(monday.year, monday.month, monday.day + 5): [
        const Color(0xFFE74C3C),
      ],
    };
  }
}

class _WeekView extends StatelessWidget {
  const _WeekView({required this.selectedDate, required this.onDateChanged});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final currentWeek = _weekOfMonth(selectedDate);
    final totalWeeks = _totalWeeksInMonth(selectedDate);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () async {
        final picked = await MonthCalendarSheet.show(context, selectedDate);
        if (picked != null && context.mounted) {
          onDateChanged(picked);
        }
      },

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcons.svg(AppIcon.week, color: colors.textPrimary),
          const SizedBox(width: 6),
          Text('Week $currentWeek/$totalWeeks', style: textTheme.labelLarge),
          const SizedBox(width: 4),
          AppIcons.svg(
            AppIcon.arrowDown,
            height: 6,
            width: 2,
            color: colors.textPrimary,
          ),
        ],
      ),
    );
  }

  /// Returns which week of the month [date] falls in (1-based).
  int _weekOfMonth(DateTime date) {
    final firstOfMonth = DateTime(date.year, date.month);
    // Offset so Monday = 0
    final firstWeekday = firstOfMonth.weekday - 1; // 0=Mon … 6=Sun
    return ((date.day + firstWeekday - 1) ~/ 7) + 1;
  }

  /// Total number of weeks that contain at least one day of the month.
  int _totalWeeksInMonth(DateTime date) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final lastDay = DateTime(date.year, date.month, daysInMonth);
    return _weekOfMonth(lastDay);
  }
}
