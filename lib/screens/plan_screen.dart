import 'package:evencir_project/models/training_entry.dart';
import 'package:evencir_project/theme/app_colors_extension.dart';
import 'package:evencir_project/utils/app_icons.dart';
import 'package:evencir_project/utils/date_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Map<DateTime, TrainingEntry> _plans = {};
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _weekKeys = {};
  DateTime? _lastInitDate;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final date = context.read<DateNotifier>().selectedDate;
    final monthKey = DateTime(date.year, date.month);
    if (_lastInitDate != monthKey) {
      _lastInitDate = monthKey;
      _initSamplePlans(date);
      _weekKeys.clear();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToCurrentWeek(date),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Sample data ──────────────────────────────────────────────────────────

  void _initSamplePlans(DateTime date) {
    final y = date.year;
    final m = date.month;
    _plans = {
      DateTime(y, m, 8): const TrainingEntry(
        workoutType: 'Arms Workout',
        name: 'Arm Blaster',
        duration: '25m - 30m',
        badgeColor: Color(0xFF2A8C82),
      ),
      DateTime(y, m, 11): const TrainingEntry(
        workoutType: 'Leg Workout',
        name: 'Leg Day Blitz',
        duration: '25m - 30m',
        badgeColor: Color(0xFF7B61FF),
      ),
      DateTime(y, m, 13): const TrainingEntry(
        workoutType: 'Intervals',
        name: 'Descending Hi Reps',
        duration: '6km',
        badgeColor: Color(0xFF2A8C82),
      ),
      DateTime(y, m, 14): const TrainingEntry(
        workoutType: 'Intervals',
        name: 'Shorter Intervals',
        duration: '3km',
        badgeColor: Color(0xFF2A8C82),
      ),
    };
  }

  // ── Week helpers ─────────────────────────────────────────────────────────

  int _weekOfMonth(DateTime date) {
    final firstOfMonth = DateTime(date.year, date.month);
    final firstWeekday = firstOfMonth.weekday - 1; // 0=Mon … 6=Sun
    return ((date.day + firstWeekday - 1) ~/ 7) + 1;
  }

  int _totalWeeksInMonth(DateTime date) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final lastDay = DateTime(date.year, date.month, daysInMonth);
    return _weekOfMonth(lastDay);
  }

  /// Returns weeks of the month as lists of dates (only days in the month).
  List<List<DateTime>> _weeksOfMonth(DateTime date) {
    final y = date.year;
    final m = date.month;
    final firstDay = DateTime(y, m);

    // Monday of the week containing the 1st
    DateTime monday = firstDay.subtract(Duration(days: firstDay.weekday - 1));

    final List<List<DateTime>> weeks = [];
    while (true) {
      final List<DateTime> weekDays = [];
      for (int i = 0; i < 7; i++) {
        final day = monday.add(Duration(days: i));
        if (day.month == m && day.year == y) {
          weekDays.add(day);
        }
      }
      if (weekDays.isEmpty) break;
      weeks.add(weekDays);
      monday = monday.add(const Duration(days: 7));
    }
    return weeks;
  }

  void _scrollToCurrentWeek(DateTime date) {
    final currentWeek = _weekOfMonth(date);
    final key = _weekKeys[currentWeek];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _weekDateRange(List<DateTime> days) {
    if (days.isEmpty) return '';
    final first = days.first;
    final last = days.last;
    final monthName = _monthNames[first.month - 1];
    return '$monthName ${first.day}-${last.day}';
  }

  String _totalTimeForWeek(List<DateTime> days) {
    int totalMinutes = 0;
    for (final day in days) {
      final normalized = DateTime(day.year, day.month, day.day);
      final entry = _plans[normalized];
      if (entry != null) {
        totalMinutes += _parseDuration(entry.duration);
      }
    }
    return 'Total: ${totalMinutes}min';
  }

  int _parseDuration(String dur) {
    // e.g. "25m - 30m" → 25, "6km" → 30 (fallback)
    final match = RegExp(r'(\d+)m').firstMatch(dur);
    if (match != null) return int.parse(match.group(1)!);
    return 30; // fallback for non-minute formats
  }

  void _movePlan(DateTime from, DateTime to) {
    if (from == to) return;
    setState(() {
      final entry = _plans.remove(from);
      if (entry != null) {
        final existing = _plans[to];
        _plans[to] = entry;
        if (existing != null) {
          _plans[from] = existing;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedDate = context.watch<DateNotifier>().selectedDate;
    final weeks = _weeksOfMonth(selectedDate);
    final totalWeeks = _totalWeeksInMonth(selectedDate);
    final currentWeekNum = _weekOfMonth(selectedDate);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Text(
          'Training Calendar',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Text(
              'Save',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 24),
        leadingWidth: 220,
      ),
      body: SafeArea(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: weeks.length,
          itemBuilder: (context, index) {
            final week = weeks[index];
            final weekNum = _weekOfMonth(week.first);
            _weekKeys.putIfAbsent(weekNum, () => GlobalKey());
            return _buildWeekSection(
              sectionKey: _weekKeys[weekNum]!,
              days: week,
              weekNumber: weekNum,
              totalWeeks: totalWeeks,
              isCurrentWeek: weekNum == currentWeekNum,
            );
          },
        ),
      ),
    );
  }

  // ── Week section ─────────────────────────────────────────────────────────

  Widget _buildWeekSection({
    required GlobalKey sectionKey,
    required List<DateTime> days,
    required int weekNumber,
    required int totalWeeks,
    required bool isCurrentWeek,
  }) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teal → blue accent bar
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: weekNumber == 1 ? colors.progressBlue : colors.teal,
            ),
          ),
          // Week header
          Container(
            color: colors.cardBackground,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $weekNumber/$totalWeeks',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _weekDateRange(days),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    _totalTimeForWeek(days),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Day rows
          ...days.map((day) => _buildDayRow(day)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Day row (drag target wrapper) ────────────────────────────────────────

  Widget _buildDayRow(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    final entry = _plans[normalized];
    final colors = context.appColors;

    return DragTarget<MapEntry<DateTime, TrainingEntry>>(
      onAcceptWithDetails: (details) {
        _movePlan(details.data.key, normalized);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return DecoratedBox(
          decoration: BoxDecoration(
            color:
                isHovering
                    ? colors.teal.withValues(alpha: 0.1)
                    : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                entry != null
                    ? _buildDayWithWorkout(normalized, day, entry)
                    : _buildEmptyDay(day),
          ),
        );
      },
    );
  }

  // ── Day with workout (draggable) ─────────────────────────────────────────

  Widget _buildDayWithWorkout(
    DateTime date,
    DateTime day,
    TrainingEntry entry,
  ) {
    return Draggable<MapEntry<DateTime, TrainingEntry>>(
      data: MapEntry(date, entry),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Opacity(
            opacity: 0.85,
            child: _buildWorkoutContent(day, entry),
          ),
        ),
      ),
      childWhenDragging: _buildEmptyDay(day, isDragging: true),
      child: _buildWorkoutContent(day, entry),
    );
  }

  Widget _buildWorkoutContent(DateTime day, TrainingEntry entry) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final dayName = _dayNames[day.weekday - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Day label column
          SizedBox(
            width: 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${day.day}',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Workout card
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.cardBorder, width: 0.5),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 7,
                      decoration: BoxDecoration(
                        color: colors.textPrimary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppIcons.svg(AppIcon.drag),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Workout type badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: entry.badgeColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _iconForType(entry.workoutType),
                                          color: entry.badgeColor,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          entry.workoutType,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: entry.badgeColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.name,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                entry.duration,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty day row ────────────────────────────────────────────────────────

  Widget _buildEmptyDay(DateTime day, {bool isDragging = false}) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final dayName = _dayNames[day.weekday - 1];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            isDragging
                                ? colors.textTertiary
                                : colors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${day.day}',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color:
                            isDragging
                                ? colors.textTertiary
                                : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.cardBorder, thickness: 0.5),
      ],
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'arms workout':
        return Icons.fitness_center;
      case 'leg workout':
        return Icons.directions_run;
      case 'intervals':
        return Icons.bolt;
      default:
        return Icons.sports;
    }
  }
}
