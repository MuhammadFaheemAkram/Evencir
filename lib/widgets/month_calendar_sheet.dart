import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

/// A full month calendar displayed in a bottom sheet.
/// Returns the selected [DateTime] when a date is tapped.
class MonthCalendarSheet extends StatefulWidget {
  const MonthCalendarSheet({super.key, required this.initialDate});
  final DateTime initialDate;

  /// Shows the calendar bottom sheet and returns the selected date (or null).
  static Future<DateTime?> show(BuildContext context, DateTime initialDate) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MonthCalendarSheet(initialDate: initialDate),
    );
  }

  @override
  State<MonthCalendarSheet> createState() => _MonthCalendarSheetState();
}

class _MonthCalendarSheetState extends State<MonthCalendarSheet> {
  late DateTime _displayedMonth; // 1st of the month being viewed
  late DateTime _selectedDate;

  static const List<String> _dayLabels = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  static const List<String> _monthNames = [
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

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns all the day cells for the displayed month grid.
  /// Includes leading empty cells for alignment to weekday columns.
  List<DateTime?> _buildGridDays() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month);
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    // weekday: Monday=1 … Sunday=7
    final leadingBlanks = firstDay.weekday - 1;

    final List<DateTime?> cells = [];
    // Leading blanks
    for (int i = 0; i < leadingBlanks; i++) {
      cells.add(null);
    }
    // Actual days
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_displayedMonth.year, _displayedMonth.month, d));
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final cells = _buildGridDays();

    // Number of rows needed (7 columns)
    final rowCount = (cells.length / 7).ceil();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar ──
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // ── Month / Year header with arrows ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _previousMonth,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_left,
                        color: colors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                  Text(
                    '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _nextMonth,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_right,
                        color: colors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Weekday labels ──
              Row(
                children:
                    _dayLabels.map((label) {
                      // Highlight the column of the selected date's weekday
                      final int colIndex = _dayLabels.indexOf(label);
                      final bool isSelectedCol =
                          colIndex == (_selectedDate.weekday - 1) &&
                          _selectedDate.month == _displayedMonth.month &&
                          _selectedDate.year == _displayedMonth.year;

                      return Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color:
                                  isSelectedCol
                                      ? colors.textPrimary
                                      : colors.textTertiary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),

              // ── Date grid ──
              ...List.generate(rowCount, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: List.generate(7, (col) {
                      final idx = row * 7 + col;
                      final date = idx < cells.length ? cells[idx] : null;

                      if (date == null) {
                        return const Expanded(child: SizedBox(height: 44));
                      }

                      final bool isSelected = _isSameDay(date, _selectedDate);

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedDate = date);
                            // Return the date and close the sheet
                            Navigator.of(context).pop(date);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            height: 44,
                            child: Center(
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
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
                                      fontSize: 15,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                      color:
                                          isSelected
                                              ? colors.textPrimary
                                              : colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
