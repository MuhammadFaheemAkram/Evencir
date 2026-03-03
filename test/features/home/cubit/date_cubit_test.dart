import 'package:bloc_test/bloc_test.dart';
import 'package:evencir_project/tab/cubit/date_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateCubit', () {
    late DateCubit dateCubit;

    setUp(() {
      dateCubit = DateCubit();
    });

    tearDown(() {
      dateCubit.close();
    });

    test('initial state has current month first day', () {
      expect(dateCubit.state.selectedDate.day, equals(1));
      expect(dateCubit.state.selectedDate.month, equals(DateTime.now().month));
      expect(dateCubit.state.selectedDate.year, equals(DateTime.now().year));
    });

    blocTest<DateCubit, DateState>(
      'setDate emits new state with updated date',
      build: () => dateCubit,
      act: (cubit) {
        final newDate = DateTime(2026, 3, 15);
        cubit.setDate(newDate);
      },
      expect:
          () => [
            isA<DateState>().having(
              (state) => state.selectedDate.day,
              'day',
              equals(15),
            ),
          ],
    );

    blocTest<DateCubit, DateState>(
      'setDate does not emit if date is same',
      build: () => dateCubit,
      act: (cubit) {
        final currentDate = cubit.state.selectedDate;
        cubit.setDate(currentDate);
      },
      expect: () => isEmpty,
    );

    test('getCurrentWeekNumber returns correct week', () {
      dateCubit.setDate(DateTime(2026, 3, 8)); // Week 2
      final weekNumber = dateCubit.getCurrentWeekNumber();
      expect(weekNumber, equals(2));
    });

    test('getCurrentWeekNumber for first days of month', () {
      dateCubit.setDate(DateTime(2026, 3)); // Week 1
      final weekNumber = dateCubit.getCurrentWeekNumber();
      expect(weekNumber, equals(1));
    });

    test('getCurrentWeekNumber for last week of month', () {
      dateCubit.setDate(DateTime(2026, 3, 28)); // Last week
      final weekNumber = dateCubit.getCurrentWeekNumber();
      expect(weekNumber, greaterThanOrEqualTo(4));
    });
  });
}
