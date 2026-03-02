import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required DateTime initialDate})
    : super(
        HomeState(
          selectedDate: initialDate,
          activityDots: _generateActivityDots(initialDate),
        ),
      );

  /// Update selected date
  void setDate(DateTime date) {
    if (date == state.selectedDate) return;
    emit(
      state.copyWith(
        selectedDate: date,
        activityDots: _generateActivityDots(date),
      ),
    );
  }

  /// Generate sample activity dots for the current week
  static Map<DateTime, List<Color>> _generateActivityDots(DateTime date) {
    final weekday = date.weekday;
    final monday = date.subtract(Duration(days: weekday - 1));
    return {
      // Monday (selected) — green
      DateTime(monday.year, monday.month, monday.day + 1): [
        const Color(0xFF27AE60),
      ],
      // Wednesday — grey
      DateTime(monday.year, monday.month, monday.day + 2): [
        const Color(0xFF5A6A7A),
      ],
      // Thursday — blue
      DateTime(monday.year, monday.month, monday.day + 3): [
        const Color(0xFF4A90D9),
      ],
      // Saturday — red
      DateTime(monday.year, monday.month, monday.day + 5): [
        const Color(0xFFE74C3C),
      ],
    };
  }
}
