import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:evencir_project/widgets/gradient_progress_bar.dart';
import 'package:flutter/material.dart';

class CaloriesCard extends StatelessWidget {
  const CaloriesCard({
    super.key,
    required this.consumed,
    required this.remaining,
    required this.total,
  });
  final int consumed;
  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final double progress = consumed / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.cardBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big number + unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$consumed',
                style: textTheme.headlineLarge?.copyWith(fontSize: 40),
              ),
              const SizedBox(width: 4),
              Text(
                'Calories',
                style: textTheme.titleMedium?.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$remaining Remaining',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Progress bar labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$total',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Progress bar
          GradientProgressBar(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: colors.progressGrey,
            gradient: const LinearGradient(
              colors: [Color(0xFF7BBDE2), Color(0xFF69C0B1), Color(0xFF60C198)],
            ),
          ),
        ],
      ),
    );
  }
}
