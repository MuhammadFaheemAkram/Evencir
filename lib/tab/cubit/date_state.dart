part of 'date_cubit.dart';

class DateState extends Equatable {
  const DateState({required this.selectedDate});

  final DateTime selectedDate;

  DateState copyWith({DateTime? selectedDate}) {
    return DateState(selectedDate: selectedDate ?? this.selectedDate);
  }

  @override
  List<Object> get props => [selectedDate];
}
