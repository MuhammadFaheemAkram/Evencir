import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:evencir_project/widgets/month_calendar_sheet.dart';
import 'package:flutter/material.dart';

class WeekView extends StatelessWidget {
  const WeekView({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

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
    final firstWeekday = firstOfMonth.weekday - 1;
    return ((date.day + firstWeekday - 1) ~/ 7) + 1;
  }

  /// Total number of weeks that contain at least one day of the month.
  int _totalWeeksInMonth(DateTime date) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final lastDay = DateTime(date.year, date.month, daysInMonth);
    return _weekOfMonth(lastDay);
  }
}
