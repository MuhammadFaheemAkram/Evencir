import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evencir_project/models/training_entry.dart';
import 'package:flutter/material.dart';

part 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  PlanCubit({DateTime? initialDate})
    : super(
        PlanState(
          plans: const {},
          selectedDate: initialDate ?? DateTime.now(),
          weeks: const [],
          isLoading: false,
        ),
      ) {
    _initializeDate(initialDate ?? DateTime.now());
  }

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

  void _initializeDate(DateTime date) {
    final plans = _initSamplePlans(date);
    final weeks = _weeksOfMonth(date);
    emit(state.copyWith(plans: plans, selectedDate: date, weeks: weeks));
  }

  void updateDate(DateTime date) {
    if (date.year == state.selectedDate.year &&
        date.month == state.selectedDate.month) {
      return;
    }
    _initializeDate(date);
  }

  /// Initialize sample plans for the month
  Map<DateTime, TrainingEntry> _initSamplePlans(DateTime date) {
    final y = date.year;
    final m = date.month;
    return {
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

  /// Get week number of the month (1-based)
  int weekOfMonth(DateTime date) {
    final firstOfMonth = DateTime(date.year, date.month);
    final firstWeekday = firstOfMonth.weekday - 1;
    return ((date.day + firstWeekday - 1) ~/ 7) + 1;
  }

  /// Get total number of weeks in the month
  int totalWeeksInMonth(DateTime date) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    final lastDay = DateTime(date.year, date.month, daysInMonth);
    return weekOfMonth(lastDay);
  }

  /// Get weeks of the month as lists of dates
  List<List<DateTime>> _weeksOfMonth(DateTime date) {
    final y = date.year;
    final m = date.month;
    final firstDay = DateTime(y, m);

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

  /// Get date range string for a week
  String weekDateRange(List<DateTime> days) {
    if (days.isEmpty) return '';
    final first = days.first;
    final last = days.last;
    final monthName = _monthNames[first.month - 1];
    return '$monthName ${first.day}-${last.day}';
  }

  /// Get total time for a week
  String totalTimeForWeek(List<DateTime> days) {
    int totalMinutes = 0;
    for (final day in days) {
      final normalized = DateTime(day.year, day.month, day.day);
      final entry = state.plans[normalized];
      if (entry != null) {
        totalMinutes += _parseDuration(entry.duration);
      }
    }
    return 'Total: ${totalMinutes}min';
  }

  /// Parse duration string to minutes
  int _parseDuration(String dur) {
    final match = RegExp(r'(\d+)m').firstMatch(dur);
    if (match != null) return int.parse(match.group(1)!);
    return 30;
  }

  /// Move plan from one date to another (drag-drop)
  void movePlan(DateTime from, DateTime to) {
    if (from == to) return;
    final entry = state.plans.remove(from);
    if (entry != null) {
      final existing = state.plans[to];
      final newPlans = Map<DateTime, TrainingEntry>.from(state.plans);
      newPlans[to] = entry;
      if (existing != null) {
        newPlans[from] = existing;
      }
      emit(state.copyWith(plans: newPlans));
    }
  }
}
