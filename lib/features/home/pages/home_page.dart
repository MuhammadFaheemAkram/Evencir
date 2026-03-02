import 'package:evencir_project/features/home/bloc/home_cubit.dart';
import 'package:evencir_project/features/home/pages/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(initialDate: selectedDate),
      child: const HomeView(),
    );
  }
}
