import 'dart:math';

import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:evencir_project/features/mood/cubit/mood_cubit.dart';
import 'package:evencir_project/widgets/mood_ring_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoodView extends StatefulWidget {
  const MoodView({super.key});

  @override
  State<MoodView> createState() => _MoodViewState();
}

class _MoodViewState extends State<MoodView>
    with SingleTickerProviderStateMixin {
  late AnimationController _snapController;
  late Animation<double>? _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _onPanStart(
    DragStartDetails details,
    Offset center,
    double ringRadius,
    MoodCubit cubit,
  ) {
    _snapController.stop();
    final pos = details.localPosition;
    final dist = (pos - center).distance;
    if ((dist - ringRadius).abs() < 40) {
      final angle = cubit.offsetToAngle(pos, center);
      cubit.updateAngle(angle);
    }
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    Offset center,
    double ringRadius,
    MoodCubit cubit,
  ) {
    final angle = cubit.offsetToAngle(details.localPosition, center);
    cubit.updateAngle(angle);
  }

  void _onPanEnd(MoodCubit cubit, double currentAngle) {
    final targetAngle = cubit.getSnapTargetAngle();
    final startAngle = currentAngle;
    final adjustedTarget =
        startAngle + cubit.calculateSnapDelta(startAngle, targetAngle);

    _snapAnimation = Tween<double>(
        begin: startAngle,
        end: adjustedTarget,
      ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut))
      ..addListener(() {
        if (mounted) {
          double a = _snapAnimation!.value % (2 * pi);
          if (a < 0) a += 2 * pi;
          cubit.updateAngle(a);
        }
      });

    _snapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const _MoodHeader(),
              const SizedBox(height: 32),
              _MoodWheel(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
              ),
              const SizedBox(height: 32),
              const _MoodLabel(),
              const Spacer(),
              const _ContinueButton(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private Widget Classes ––

class _MoodHeader extends StatelessWidget {
  const _MoodHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Start your day',
          style: textTheme.titleMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How are you feeling at the\nMoment?',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _MoodWheel extends StatelessWidget {
  const _MoodWheel({
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final void Function(DragStartDetails, Offset, double, MoodCubit) onPanStart;
  final void Function(DragUpdateDetails, Offset, double, MoodCubit) onPanUpdate;
  final void Function(MoodCubit, double) onPanEnd;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      buildWhen: (previous, current) => previous.angle != current.angle,
      builder: (context, state) {
        final cubit = context.read<MoodCubit>();
        return Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wheelSize = min(constraints.maxWidth * 1.0, 293.0);
              final ringRadius =
                  wheelSize / 2 - (wheelSize / 2 * 0.22 / 2) - 12;
              final center = Offset(wheelSize / 2, wheelSize / 2);

              return GestureDetector(
                onPanStart: (d) => onPanStart(d, center, ringRadius, cubit),
                onPanUpdate: (d) => onPanUpdate(d, center, ringRadius, cubit),
                onPanEnd: (_) => onPanEnd(cubit, state.angle),
                onTapDown: (d) {
                  final dist = (d.localPosition - center).distance;
                  if ((dist - ringRadius).abs() < 40) {
                    final angle = cubit.offsetToAngle(d.localPosition, center);
                    cubit.updateAngle(angle);
                  }
                },
                onTapUp: (_) => onPanEnd(cubit, state.angle),
                child: SizedBox(
                  width: wheelSize,
                  height: wheelSize,
                  child: Stack(
                    children: [
                      // Ring — CustomPainter with SweepGradient
                      Positioned.fill(
                        child: CustomPaint(
                          painter: MoodRingPainter(thumbAngle: state.angle),
                        ),
                      ),
                      // Center emoji SVG
                      Center(
                        child: SizedBox(
                          width: wheelSize * 0.38,
                          height: wheelSize * 0.38,
                          child: _MoodEmojiAnimated(wheelSize: wheelSize),
                        ),
                      ),
                      // Draggable thumb
                      Positioned(
                        left:
                            center.dx -
                            25 +
                            ringRadius * cos(state.angle - pi / 2),
                        top:
                            center.dy -
                            25 +
                            ringRadius * sin(state.angle - pi / 2),
                        child: const _MoodThumb(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MoodEmojiAnimated extends StatelessWidget {
  const _MoodEmojiAnimated({required this.wheelSize});

  final double wheelSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      buildWhen:
          (previous, current) => previous.currentMood != current.currentMood,
      builder: (context, state) {
        final cubit = context.read<MoodCubit>();
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: AppIcons.svg(
            cubit.getEmojiIcon(state.currentMood),
            size: wheelSize * 0.38,
            key: ValueKey(state.currentMood),
          ),
        );
      },
    );
  }
}

class _MoodThumb extends StatelessWidget {
  const _MoodThumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE8F0EC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _MoodLabel extends StatelessWidget {
  const _MoodLabel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final moodLabel = context.select(
      (MoodCubit value) => value.state.moodLabel,
    );
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          moodLabel,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.textPrimary,
            foregroundColor: colors.buttonText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            textStyle: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          child: Text(
            'Continue',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.buttonText,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
