import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

class WeekCalendar extends StatefulWidget {
  const WeekCalendar({
    super.key,
    required this.selectedDate,
    this.onDateSelected,
    this.activityDots,
  });
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  /// Optional map of date → list of dot colors for activity indicators.
  final Map<DateTime, List<Color>>? activityDots;

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;

  static const List<String> _dayLabels = [
    'M',
    'TU',
    'W',
    'TH',
    'F',
    'SA',
    'SU',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _weekDays = _getWeekDays(_selectedDate);
  }

  @override
  void didUpdateWidget(covariant WeekCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate;
      _weekDays = _getWeekDays(_selectedDate);
    }
  }

  List<DateTime> _getWeekDays(DateTime date) {
    // Monday = 1, Sunday = 7
    final int weekday = date.weekday;
    final DateTime monday = date.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  final double size = 36;

  /// Builds one or more colored dots beneath a calendar day.
  Widget _buildDots(DateTime date, bool isSelected, AppColorsExtension colors) {
    final key = _normalizeDate(date);
    final dots = widget.activityDots?[key];

    if (dots != null && dots.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children:
            dots
                .take(3) // max 3 dots
                .map(
                  (c) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: c),
                  ),
                )
                .toList(),
      );
    }

    // Default: single green dot if selected, transparent otherwise
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? colors.green : Colors.transparent,
      ),
    );
  }

  Widget _buildDayRow(bool scroll) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment:
          scroll ? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
      spacing: 14,
      children: List.generate(7, (index) {
        final date = _weekDays[index];
        final isSelected = _isSameDay(date, _selectedDate);
        return Column(
          children: [
            // Day labels
            SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  _dayLabels[index],
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Date Circles
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
                widget.onDateSelected?.call(date);
              },
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected
                          ? colors.daySelectedBorder.withValues(alpha: 0.19)
                          : colors.dayUnselected,
                  border:
                      isSelected
                          ? Border.all(
                            color: colors.daySelectedBorder,
                            width: 2,
                          )
                          : null,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Activity dot indicators (supports multiple colored dots)
            _buildDots(date, isSelected, colors),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Date numbers row
        LayoutBuilder(
          builder: (context, constraints) {
            final max = constraints.maxWidth;
            final width =
                (7.0 * size) + (6.0 * 14); // 7 days * 36px + 6 spaces * 12px
            if (max > width) {
              return Center(child: _buildDayRow(false));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildDayRow(true),
            );
          },
        ),
        const SizedBox(height: 24),
        // Page indicator
        Container(
          width: 32,
          height: 5,
          decoration: BoxDecoration(
            color: context.appColors.textTertiary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
