import 'package:flutter/material.dart';

/// A horizontal progress bar that fills with a [LinearGradient].
///
/// Usage:
/// ```dart
/// GradientProgressBar(
///   value: 0.6,
///   gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
/// )
/// ```
class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar({
    super.key,
    required this.value,
    required this.gradient,
    this.height = 6,
    this.borderRadius = 4,
    this.backgroundColor,
  });

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// The gradient applied to the filled portion.
  final LinearGradient gradient;

  /// Height of the bar. Defaults to 6.
  final double height;

  /// Corner radius of the bar. Defaults to 4.
  final double borderRadius;

  /// Background color of the unfilled track.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final trackColor =
        backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            width: totalWidth,
            height: height,
            child: Stack(
              children: [
                // Track (background)
                Container(width: totalWidth, height: height, color: trackColor),
                // Filled portion with gradient
                if (clamped > 0)
                  Container(
                    width: totalWidth * clamped,
                    height: height,
                    decoration: BoxDecoration(gradient: gradient),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
