import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:evencir_project/features/home/bloc/home_cubit.dart';
import 'package:evencir_project/features/home/widgets/calories_card.dart';
import 'package:evencir_project/features/home/widgets/hydration_card.dart';
import 'package:evencir_project/features/home/widgets/week_view.dart';
import 'package:evencir_project/features/home/widgets/weight_card.dart';
import 'package:evencir_project/features/home/widgets/workout_card.dart';
import 'package:evencir_project/tab/cubit/date_cubit.dart';
import 'package:evencir_project/widgets/section_header.dart';
import 'package:evencir_project/widgets/week_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (prev, curr) => prev.selectedDate != curr.selectedDate,
      listener: (context, state) {
        // Sync with DateCubit when date changes in home
        context.read<DateCubit>().setDate(state.selectedDate);
      },
      child: const _BodyView(),
    );
  }
}

class _BodyView extends StatelessWidget {
  const _BodyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const _DateSection(),
                const SizedBox(height: 28),
                // ── Workouts Section ──
                SectionHeader(
                  title: 'Workouts',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcons.svg(
                        AppIcon.sun,
                        color: context.appColors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '9°',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                WorkoutCard(
                  date: 'December 22',
                  duration: '25m - 30m',
                  title: 'Upper Body',
                  onTap: () {
                    // Navigate to workout detail
                  },
                ),
                const SizedBox(height: 32),
                // ── My Insights Section ──
                const SectionHeader(title: 'My Insights'),
                const SizedBox(height: 24),
                // Two side-by-side cards
                const SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                        child: CaloriesCard(
                          consumed: 550,
                          remaining: 1950,
                          total: 2500,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(child: WeightCard(weight: 75, change: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Hydration card
                HydrationCard(
                  percentage: 0,
                  currentMl: 0,
                  toastMessage: '500 ml added to water log',
                  onLogNow: () {
                    // Log water intake
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.selectedDate != curr.selectedDate,
      builder: (context, state) {
        final colors = context.appColors;

        return AppBar(
          leading: Align(
            child: AppIcons.svg(
              AppIcon.notification,
              color: colors.textPrimary,
            ),
          ),
          title: WeekView(
            selectedDate: state.selectedDate,
            onDateChanged: (date) => context.read<HomeCubit>().setDate(date),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        );
      },
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (prev, curr) =>
              prev.selectedDate != curr.selectedDate ||
              prev.activityDots != curr.activityDots,
      builder: (context, state) {
        final colors = context.appColors;
        final textTheme = Theme.of(context).textTheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date Label ──
            Text(
              state.formatDate,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // ── Week Calendar ──
            WeekCalendar(
              selectedDate: state.selectedDate,
              onDateSelected: context.read<HomeCubit>().setDate,
              activityDots: state.activityDots,
            ),
          ],
        );
      },
    );
  }
}
