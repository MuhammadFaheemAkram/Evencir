part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.selectedDate,
    required this.activityDots,
  });

  final DateTime selectedDate;
  final Map<DateTime, List<Color>> activityDots;

  HomeState copyWith({
    DateTime? selectedDate,
    Map<DateTime, List<Color>>? activityDots,
  }) {
    return HomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      activityDots: activityDots ?? this.activityDots,
    );
  }

  @override
  List<Object> get props => [selectedDate, activityDots];
}
