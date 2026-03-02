import 'dart:math';
import 'package:flutter/material.dart';

/// Paints the mood gradient ring with blended color segments and tick marks.
class MoodRingPainter extends CustomPainter {

  MoodRingPainter({required this.thumbAngle});
  final double thumbAngle;

  // Ring colors – 4 mood quadrants blended via sweep gradient.
  // Order (clockwise from top / -π/2):
  //   top-right → Calm (teal)
  //   bottom-right → Content (lavender/purple)
  //   bottom-left → Peaceful (pink)
  //   top-left → Happy (orange/peach)
  // Gradient stops (clockwise from 12 o'clock):
  //   Calm #6EB9AD  (top-right, 0–90°)
  //   Content #C9BBEF (bottom-right, 90–180°)
  //   Peaceful #F28DB3 (bottom-left, 180–270°)
  //   Happy #F99955 (top-left, 270–360°)
  static const _ringColors = [
    Color(0xFF6EB9AD), // Calm — 12 o'clock start
    Color(0xFF6EB9AD), // Calm center
    Color(0xFF6EB9AD), // Calm→Content blend
    Color(0xFF6EB9AD), // transition
    Color(0xFFC9BBEF), // Content center
    Color(0xFFC9BBEF), // Content
    Color(0xFFC9BBEF), // Content→Peaceful blend//0xFFC9BBEF
    Color(0xFFC9BBEF), // transition
    Color(0xFFF28DB3), // Peaceful center
    Color(0xFFF28DB3), // Peaceful
    Color(0xFFF28DB3), // Peaceful→Happy blend
    Color(0xFFF99670), // transition
    Color(0xFFF99955), // Happy center
    Color(0xFFF99955), // Happy
    Color(0xFFF99955), // Happy→Calm blend
    Color(0xFF8ABCB8), // back to Calm (full circle)
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final ringWidth = radius * 0.2;
    final ringRadius = radius - ringWidth / 2 - 12; // inset for tick marks

    // ── Gradient ring ──
    final ringRect = Rect.fromCircle(center: center, radius: ringRadius);
    final ringPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringWidth
          ..shader = const SweepGradient(
            colors: _ringColors,
            transform: GradientRotation(-pi / 2),
          ).createShader(ringRect);

    canvas.drawCircle(center, ringRadius, ringPaint);

    // ── Tick marks on outer edge ──
    final tickPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    const tickCount = 12;
    final tickOuterR = ringRadius + ringWidth / 2 - 1;
    final tickInnerR = ringRadius - ringWidth / 2 + 1;

    for (int i = 0; i < tickCount; i++) {
      final angle = -pi / 2 + (2 * pi * i / tickCount);
      final outerPt = Offset(
        center.dx + tickOuterR * cos(angle),
        center.dy + tickOuterR * sin(angle),
      );
      final innerPt = Offset(
        center.dx + tickInnerR * cos(angle),
        center.dy + tickInnerR * sin(angle),
      );
      canvas.drawLine(innerPt, outerPt, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodRingPainter oldDelegate) =>
      oldDelegate.thumbAngle != thumbAngle;
}
