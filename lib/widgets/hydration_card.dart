import 'package:evencir_project/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

class HydrationCard extends StatelessWidget {
  const HydrationCard({
    super.key,
    required this.percentage,
    required this.currentMl,
    this.goalLiters = 2.0,
    this.toastMessage,
    this.onLogNow,
  });
  final int percentage;
  final double currentMl;
  final double goalLiters;
  final String? toastMessage;
  final VoidCallback? onLogNow;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.cardBorder, width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - percentage & Hydration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$percentage%',
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: 42,
                          color: colors.progressBlue,
                        ),
                      ),
                      const SizedBox(height: 42),
                      Text(
                        'Hydration',
                        style: textTheme.titleLarge?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onLogNow,
                        child: Text(
                          'Log Now',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side - vertical water bar chart
                Expanded(
                  child: SizedBox(
                    height: 140,
                    child: CustomPaint(
                      painter: _WaterBarPainter(
                        currentMl: currentMl,
                        goalLiters: goalLiters,
                        colors: colors,
                      ),
                      size: const Size(double.infinity, 140),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom toast message
          if (toastMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: colors.teal.withValues(alpha: 0.40),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  toastMessage ?? '',
                  style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WaterBarPainter extends CustomPainter {
  _WaterBarPainter({
    required this.currentMl,
    required this.goalLiters,
    required this.colors,
  });
  final double currentMl;
  final double goalLiters;
  final AppColorsExtension colors;

  @override
  void paint(Canvas canvas, Size size) {
    const double rightMargin = 50;
    final double chartWidth = size.width - rightMargin;
    final double chartX = chartWidth * 0.5;

    // Dashed vertical line
    final dashPaint =
        Paint()
          ..color = colors.textTertiary.withValues(alpha: 0.5)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    double dashY = 0;
    const dashHeight = 4.0;
    const dashGap = 4.0;
    while (dashY < size.height) {
      canvas.drawLine(
        Offset(chartX, dashY),
        Offset(chartX, (dashY + dashHeight).clamp(0, size.height)),
        dashPaint,
      );
      dashY += dashHeight + dashGap;
    }

    // Goal label - 2L at top
    final goalTextPainter = TextPainter(
      text: TextSpan(
        text: '${goalLiters.toStringAsFixed(0)} L',
        style: TextStyle(
          color: colors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    goalTextPainter.paint(
      canvas,
      Offset(chartX - goalTextPainter.width - 8, 0),
    );

    // Dot at top
    final dotPaint = Paint()..color = colors.progressBlue;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(chartX, 0), width: 12, height: 6),
        const Radius.circular(4),
      ),
      dotPaint,
    );

    // 0 L label at bottom
    final zeroTextPainter = TextPainter(
      text: TextSpan(
        text: '0 L',
        style: TextStyle(
          color: colors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    zeroTextPainter.paint(
      canvas,
      Offset(chartX - zeroTextPainter.width - 8, size.height - 14),
    );

    // Dot at bottom

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(chartX, size.height - 4),
          width: 12,
          height: 6,
        ),
        const Radius.circular(4),
      ),
      dotPaint,
    );

    // Middle dot for current level
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(chartX, size.height * 0.55),
          width: 12,
          height: 6,
        ),
        const Radius.circular(4),
      ),
      dotPaint,
    );

    // Horizontal line from mid dot to right
    final hLinePaint =
        Paint()
          ..color = colors.textTertiary.withValues(alpha: 0.4)
          ..strokeWidth = 1;
    canvas.drawLine(
      Offset(chartX + 5, size.height - 8),
      Offset(size.width - rightMargin + 30, size.height - 8),
      hLinePaint,
    );

    // Current ml value at the end of horizontal line
    final mlTextPainter = TextPainter(
      text: TextSpan(
        text: '${currentMl.toStringAsFixed(0)}ml',
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    mlTextPainter.paint(
      canvas,
      Offset(size.width - mlTextPainter.width, size.height - 20),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
