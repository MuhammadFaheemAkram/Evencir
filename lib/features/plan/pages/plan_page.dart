import 'package:evencir_project/features/plan/bloc/plan_cubit.dart';
import 'package:evencir_project/features/plan/pages/plan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlanCubit(initialDate: selectedDate),
      child: const PlanView(),
    );
  }
}
