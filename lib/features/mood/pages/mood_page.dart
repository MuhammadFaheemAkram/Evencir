import 'package:evencir_project/features/mood/cubit/mood_cubit.dart';
import 'package:evencir_project/features/mood/pages/mood_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoodCubit(),
      child: const MoodView(),
    );
  }
}
