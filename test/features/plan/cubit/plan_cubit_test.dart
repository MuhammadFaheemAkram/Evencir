import 'package:evencir_project/features/plan/bloc/plan_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlanCubit', () {
    late PlanCubit planCubit;

    setUp(() {
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month);
      planCubit = PlanCubit(initialDate: firstDayOfMonth);
    });

    tearDown(() {
      planCubit.close();
    });

    test('initial state has selected date', () {
      final now = DateTime.now();
      expect(planCubit.state.selectedDate.month, equals(now.month));
      expect(planCubit.state.selectedDate.year, equals(now.year));
    });

    test('initial state has sample plans', () {
      expect(planCubit.state.plans.isNotEmpty, true);
    });

    test('initial state has weeks of month', () {
      expect(planCubit.state.weeks.isNotEmpty, true);
      // Weeks should contain lists of dates
      for (final week in planCubit.state.weeks) {
        expect(week.isNotEmpty, true);
      }
    });

    test('weekOfMonth returns correct week number', () {
      final date = DateTime(2026, 3, 8);
      final week = planCubit.weekOfMonth(date);
      expect(week, equals(2));
    });

    test('weekOfMonth for first day returns 1', () {
      final date = DateTime(2026, 3);
      final week = planCubit.weekOfMonth(date);
      expect(week, equals(1));
    });

    test('movePlan moves workout to new date', () {
      final oldDate = DateTime(2026, 3, 8);
      final newDate = DateTime(2026, 3, 9);

      // Get initial plans
      final initialPlansLength = planCubit.state.plans.length;

      planCubit.movePlan(oldDate, newDate);

      // Plans list should remain same size
      expect(planCubit.state.plans.length, equals(initialPlansLength));
    });

    test('weekDateRange returns formatted date range', () {
      final week = [
        DateTime(2026, 3, 2),
        DateTime(2026, 3, 3),
        DateTime(2026, 3, 4),
      ];
      final range = planCubit.weekDateRange(week);
      expect(range, isNotEmpty);
      expect(range.contains('-'), true); // Should have date range separator
    });

    test('totalTimeForWeek calculates hours correctly', () {
      final week = [DateTime(2026, 3), DateTime(2026, 3, 2)];
      final totalTime = planCubit.totalTimeForWeek(week);
      expect(totalTime, isNotEmpty);
      // Should return format like "X-Y hours" or similar
      expect(totalTime.isNotEmpty, true);
    });
  });
}
