import 'package:evencir_project/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

class WeightCard extends StatelessWidget {
  const WeightCard({
    super.key,
    required this.weight,
    required this.change,
    this.unit = 'kg',
  });
  final double weight;
  final double change;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final bool isGain = change >= 0;
    final String changeText =
        isGain
            ? '+${change.toStringAsFixed(1)}$unit'
            : '${change.toStringAsFixed(1)}$unit';

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
          // Weight value + unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                weight.toStringAsFixed(0),
                style: textTheme.headlineLarge?.copyWith(fontSize: 40),
              ),
              const SizedBox(width: 2),
              Text(unit, style: textTheme.titleMedium?.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          // Change indicator
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isGain
                          ? colors.green.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Icon(
                    isGain ? Icons.trending_up : Icons.trending_down,
                    size: 12,
                    color: isGain ? colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                changeText,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Label
          Text(
            'Weight',
            style: textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
