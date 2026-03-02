import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:evencir_project/features/plan/bloc/plan_cubit.dart';
import 'package:evencir_project/models/training_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  late ScrollController _scrollController;
  final Map<int, GlobalKey> _weekKeys = {};

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<PlanCubit>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToCurrentWeek(cubit.state),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentWeek(PlanState state) {
    final currentWeek = context.read<PlanCubit>().weekOfMonth(
      state.selectedDate,
    );
    final key = _weekKeys[currentWeek];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCubit, PlanState>(
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        final cubit = context.read<PlanCubit>();
        final totalWeeks = cubit.totalWeeksInMonth(state.selectedDate);
        final currentWeekNum = cubit.weekOfMonth(state.selectedDate);

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
              itemCount: state.weeks.length,
              itemBuilder: (context, index) {
                final week = state.weeks[index];
                final weekNum = cubit.weekOfMonth(week.first);
                _weekKeys.putIfAbsent(weekNum, () => GlobalKey());
                return _buildWeekSection(
                  sectionKey: _weekKeys[weekNum]!,
                  cubit: cubit,
                  days: week,
                  weekNumber: weekNum,
                  totalWeeks: totalWeeks,
                  isCurrentWeek: weekNum == currentWeekNum,
                  plans: state.plans,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeekSection({
    required GlobalKey sectionKey,
    required PlanCubit cubit,
    required List<DateTime> days,
    required int weekNumber,
    required int totalWeeks,
    required bool isCurrentWeek,
    required Map<DateTime, TrainingEntry> plans,
  }) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: sectionKey,
      child: Column(
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
          ...days.map((day) => _buildDayRow(context, cubit, day, plans)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDayRow(
    BuildContext context,
    PlanCubit cubit,
    DateTime day,
    Map<DateTime, TrainingEntry> plans,
  ) {
    final normalized = DateTime(day.year, day.month, day.day);
    final entry = plans[normalized];
    final colors = context.appColors;

    return DragTarget<MapEntry<DateTime, TrainingEntry>>(
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
                    ? _buildDayWithWorkout(
                      context,
                      cubit,
                      normalized,
                      day,
                      entry,
                    )
                    : _buildEmptyDay(context, day),
          ),
        );
      },
    );
  }

  Widget _buildDayWithWorkout(
    BuildContext context,
    PlanCubit cubit,
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
            child: _buildWorkoutContent(context, day, entry),
          ),
        ),
      ),
      childWhenDragging: _buildEmptyDay(context, day, isDragging: true),
      child: _buildWorkoutContent(context, day, entry),
    );
  }

  Widget _buildWorkoutContent(
    BuildContext context,
    DateTime day,
    TrainingEntry entry,
  ) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final dayName = _dayNames[day.weekday - 1];

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

  Widget _buildEmptyDay(
    BuildContext context,
    DateTime day, {
    bool isDragging = false,
  }) {
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
