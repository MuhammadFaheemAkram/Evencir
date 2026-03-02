import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit({DateTime? initialDate})
    : super(DateState(selectedDate: initialDate ?? _getCurrentMonthFirstDay()));

  /// Get the first day of the current month
  static DateTime _getCurrentMonthFirstDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  /// Update the selected date
  void setDate(DateTime date) {
    if (date == state.selectedDate) return;
    emit(state.copyWith(selectedDate: date));
  }

  /// Get current week number for the selected date
  int getCurrentWeekNumber() {
    final date = state.selectedDate;
    final firstOfMonth = DateTime(date.year, date.month);
    final firstWeekday = firstOfMonth.weekday - 1;
    return ((date.day + firstWeekday - 1) ~/ 7) + 1;
  }
}
