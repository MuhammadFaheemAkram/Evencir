part of 'plan_cubit.dart';

class PlanState extends Equatable {
  const PlanState({
    required this.plans,
    required this.selectedDate,
    required this.weeks,
    required this.isLoading,
  });

  final Map<DateTime, TrainingEntry> plans;
  final DateTime selectedDate;
  final List<List<DateTime>> weeks;
  final bool isLoading;

  PlanState copyWith({
    Map<DateTime, TrainingEntry>? plans,
    DateTime? selectedDate,
    List<List<DateTime>>? weeks,
    bool? isLoading,
  }) {
    return PlanState(
      plans: plans ?? this.plans,
      selectedDate: selectedDate ?? this.selectedDate,
      weeks: weeks ?? this.weeks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [plans, selectedDate, weeks, isLoading];
}
