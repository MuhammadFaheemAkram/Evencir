import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:evencir_project/features/plan/bloc/plan_cubit.dart';
import 'package:evencir_project/features/plan/models/training_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  late ItemScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentWeek());
  }

  Future<void> _scrollToCurrentWeek() async {
    final currentWeek = context.read<PlanCubit>().weekOfMonth(
      context.read<PlanCubit>().state.selectedDate,
    );
    _scrollController.scrollTo(
      index: currentWeek - 1,
      duration: Duration(milliseconds: currentWeek * 100),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _PlanAppBar(),
      body: _PlanBody(scrollController: _scrollController),
    );
  }
}

// ── Private Widget Classes ──

class _PlanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PlanAppBar();

  @override
  final preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
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
    );
  }
}

class _PlanBody extends StatelessWidget {
  const _PlanBody({required this.scrollController});

  final ItemScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PlanCubit, PlanState>(
        buildWhen:
            (previous, current) =>
                previous.selectedDate != current.selectedDate ||
                previous.plans != current.plans,
        builder: (context, state) {
          final cubit = context.read<PlanCubit>();
          final totalWeeks = cubit.totalWeeksInMonth(state.selectedDate);
          final currentWeekNum = cubit.weekOfMonth(state.selectedDate);

          return _PlanWeeksList(
            weeks: state.weeks,
            scrollController: scrollController,
            cubit: cubit,
            plans: state.plans,
            totalWeeks: totalWeeks,
            currentWeekNum: currentWeekNum,
          );
        },
      ),
    );
  }
}

class _PlanWeeksList extends StatelessWidget {
  const _PlanWeeksList({
    required this.weeks,
    required this.scrollController,
    required this.cubit,
    required this.plans,
    required this.totalWeeks,
    required this.currentWeekNum,
  });

  final List<List<DateTime>> weeks;
  final ItemScrollController scrollController;
  final PlanCubit cubit;
  final Map<DateTime, TrainingModel> plans;
  final int totalWeeks;
  final int currentWeekNum;

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: scrollController,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: weeks.length,
      itemBuilder: (context, index) {
        final week = weeks[index];
        final weekNum = cubit.weekOfMonth(week.first);
        return _PlanWeekSection(
          cubit: cubit,
          days: week,
          weekNumber: weekNum,
          totalWeeks: totalWeeks,
          isCurrentWeek: weekNum == currentWeekNum,
          plans: plans,
        );
      },
    );
  }
}

class _PlanWeekSection extends StatelessWidget {
  const _PlanWeekSection({
    required this.cubit,
    required this.days,
    required this.weekNumber,
    required this.totalWeeks,
    required this.isCurrentWeek,
    required this.plans,
  });

  final PlanCubit cubit;
  final List<DateTime> days;
  final int weekNumber;
  final int totalWeeks;
  final bool isCurrentWeek;
  final Map<DateTime, TrainingModel> plans;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accent bar
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
                    cubit.weekDateRange(days),
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
                  cubit.totalTimeForWeek(days),
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
        ...days.map((day) => _PlanDayRow(cubit: cubit, day: day, plans: plans)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PlanDayRow extends StatelessWidget {
  const _PlanDayRow({
    required this.cubit,
    required this.day,
    required this.plans,
  });

  final PlanCubit cubit;
  final DateTime day;
  final Map<DateTime, TrainingModel> plans;

  @override
  Widget build(BuildContext context) {
    final normalized = DateTime(day.year, day.month, day.day);
    final entry = plans[normalized];
    final colors = context.appColors;
    final dayNames = cubit.state.dayNames;

    return DragTarget<MapEntry<DateTime, TrainingModel>>(
      onAcceptWithDetails: (details) {
        cubit.movePlan(details.data.key, normalized);
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
                    ? _PlanDayWithWorkout(
                      date: normalized,
                      day: day,
                      entry: entry,
                      dayNames: dayNames,
                    )
                    : _PlanEmptyDay(day: day, dayNames: dayNames),
          ),
        );
      },
    );
  }
}

class _PlanDayWithWorkout extends StatelessWidget {
  const _PlanDayWithWorkout({
    required this.date,
    required this.day,
    required this.entry,
    required this.dayNames,
  });

  final DateTime date;
  final DateTime day;
  final TrainingModel entry;
  final List<String> dayNames;

  @override
  Widget build(BuildContext context) {
    return Draggable<MapEntry<DateTime, TrainingModel>>(
      data: MapEntry(date, entry),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: Opacity(
            opacity: 0.85,
            child: _PlanWorkoutContent(
              day: day,
              entry: entry,
              dayNames: dayNames,
            ),
          ),
        ),
      ),
      childWhenDragging: _PlanEmptyDay(
        day: day,
        dayNames: dayNames,
        isDragging: true,
      ),
      child: _PlanWorkoutContent(day: day, entry: entry, dayNames: dayNames),
    );
  }
}

class _PlanWorkoutContent extends StatelessWidget {
  const _PlanWorkoutContent({
    required this.day,
    required this.entry,
    required this.dayNames,
  });

  final DateTime day;
  final TrainingModel entry;
  final List<String> dayNames;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final dayName = dayNames[day.weekday - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

class _PlanEmptyDay extends StatelessWidget {
  const _PlanEmptyDay({
    required this.day,
    required this.dayNames,
    this.isDragging = false,
  });

  final DateTime day;
  final List<String> dayNames;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final dayName = dayNames[day.weekday - 1];

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
}
