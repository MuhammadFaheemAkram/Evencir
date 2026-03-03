part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.selectedDate,
    required this.activityDots,
    required this.currentHour,
  });

  final DateTime selectedDate;
  final Map<DateTime, List<Color>> activityDots;
  final int currentHour;

  HomeState copyWith({
    DateTime? selectedDate,
    Map<DateTime, List<Color>>? activityDots,
    int? currentHour,
  }) {
    return HomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      activityDots: activityDots ?? this.activityDots,
      currentHour: currentHour ?? this.currentHour,
    );
  }

  String get formatDate {
    final formattedDate = DateFormat('dd MMM yyyy').format(selectedDate);
    if (selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day) {
      return 'Today, $formattedDate';
    }
    return formattedDate;
  }

  @override
  List<Object> get props => [selectedDate, activityDots, currentHour];
}
