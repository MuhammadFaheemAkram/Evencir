import 'dart:math';
import 'package:flutter/material.dart';

/// The four moods the wheel can select.
enum Mood { happy, calm, content, peaceful }

/// Paints a rounded-square emoji face for the given [mood].
class MoodFacePainter extends CustomPainter {

  MoodFacePainter({required this.mood});
  final Mood mood;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = size.width;

    // ── Background rounded square ──
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: s * 0.82, height: s * 0.82),
      Radius.circular(s * 0.22),
    );
    final bgPaint = Paint()..color = _bgColor;
    canvas.drawRRect(bgRect, bgPaint);

    switch (mood) {
      case Mood.happy:
        _drawHappyFace(canvas, center, s);
      case Mood.calm:
        _drawCalmFace(canvas, center, s);
      case Mood.content:
        _drawContentFace(canvas, center, s);
      case Mood.peaceful:
        _drawPeacefulFace(canvas, center, s);
    }
  }

  Color get _bgColor {
    switch (mood) {
      case Mood.happy:
        return const Color(0xFFF9C88A); // warm orange-peach
      case Mood.calm:
        return const Color(0xFFD4E8E4); // soft teal-tint
      case Mood.content:
        return const Color(0xFFEFC840); // bright gold
      case Mood.peaceful:
        return const Color(0xFFF5D6A0); // peach
    }
  }

  // ─── Happy: closed happy eyes (^‿^), wide smile ───

  void _drawHappyFace(Canvas canvas, Offset c, double s) {
    final paint =
        Paint()
          ..color = const Color(0xFF3A5A50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.028
          ..strokeCap = StrokeCap.round;

    // Left eye — arc curving up (happy squint)
    final leftEyeCenter = c + Offset(-s * 0.14, -s * 0.08);
    _drawArcEye(canvas, leftEyeCenter, s * 0.08, paint, up: true);

    // Right eye — arc curving up
    final rightEyeCenter = c + Offset(s * 0.14, -s * 0.08);
    _drawArcEye(canvas, rightEyeCenter, s * 0.08, paint, up: true);

    // Smile — wide curve
    final smilePaint =
        Paint()
          ..color = const Color(0xFF3A5A50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.03
          ..strokeCap = StrokeCap.round;

    final smileRect = Rect.fromCenter(
      center: c + Offset(0, s * 0.06),
      width: s * 0.38,
      height: s * 0.28,
    );
    canvas.drawArc(smileRect, 0.15, pi - 0.3, false, smilePaint);
  }

  // ─── Calm: gentle closed eyes, rosy cheeks, small smile ───

  void _drawCalmFace(Canvas canvas, Offset c, double s) {
    final paint =
        Paint()
          ..color = const Color(0xFF5A6A6A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.022
          ..strokeCap = StrokeCap.round;

    // Left eye — gentle arc
    final leftEyeCenter = c + Offset(-s * 0.13, -s * 0.06);
    _drawArcEye(canvas, leftEyeCenter, s * 0.065, paint, up: true);

    // Right eye — gentle arc
    final rightEyeCenter = c + Offset(s * 0.13, -s * 0.06);
    _drawArcEye(canvas, rightEyeCenter, s * 0.065, paint, up: true);

    // Rosy cheeks
    final cheekPaint =
        Paint()..color = const Color(0xFFE8A0A0).withValues(alpha: 0.6);
    canvas.drawCircle(c + Offset(-s * 0.2, s * 0.04), s * 0.055, cheekPaint);
    canvas.drawCircle(c + Offset(s * 0.2, s * 0.04), s * 0.055, cheekPaint);

    // Small gentle smile
    final smilePaint =
        Paint()
          ..color = const Color(0xFF5A6A6A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.022
          ..strokeCap = StrokeCap.round;

    final smileRect = Rect.fromCenter(
      center: c + Offset(0, s * 0.08),
      width: s * 0.18,
      height: s * 0.12,
    );
    canvas.drawArc(smileRect, 0.2, pi - 0.4, false, smilePaint);
  }

  // ─── Content: XD style face — big laugh ───

  void _drawContentFace(Canvas canvas, Offset c, double s) {
    final paint =
        Paint()
          ..color = const Color(0xFF5A4020)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.028
          ..strokeCap = StrokeCap.round;

    // Left eye — X-shaped squint (two arcs)
    final leftCenter = c + Offset(-s * 0.13, -s * 0.07);
    _drawArcEye(canvas, leftCenter, s * 0.075, paint, up: true);

    // Right eye
    final rightCenter = c + Offset(s * 0.13, -s * 0.07);
    _drawArcEye(canvas, rightCenter, s * 0.075, paint, up: true);

    // Big open mouth smile
    final mouthPaint =
        Paint()
          ..color = const Color(0xFF5A4020)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.032
          ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: c + Offset(0, s * 0.08),
      width: s * 0.35,
      height: s * 0.30,
    );
    canvas.drawArc(mouthRect, 0.1, pi - 0.2, false, mouthPaint);

    // Fill the mouth opening
    final mouthFill =
        Paint()
          ..color = const Color(0xFF5A4020).withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;
    canvas.drawArc(mouthRect, 0.1, pi - 0.2, true, mouthFill);
  }

  // ─── Peaceful: open eyes (dot style), smile ───

  void _drawPeacefulFace(Canvas canvas, Offset c, double s) {
    final eyePaint =
        Paint()
          ..color = const Color(0xFF3A5A50)
          ..style = PaintingStyle.fill;

    // Left eye — dot
    canvas.drawCircle(c + Offset(-s * 0.13, -s * 0.06), s * 0.032, eyePaint);

    // Right eye — dot
    canvas.drawCircle(c + Offset(s * 0.13, -s * 0.06), s * 0.032, eyePaint);

    // Smile
    final smilePaint =
        Paint()
          ..color = const Color(0xFF3A5A50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.025
          ..strokeCap = StrokeCap.round;

    final smileRect = Rect.fromCenter(
      center: c + Offset(0, s * 0.06),
      width: s * 0.28,
      height: s * 0.22,
    );
    canvas.drawArc(smileRect, 0.15, pi - 0.3, false, smilePaint);
  }

  // ─── Helper: draw an arc-based eye ───

  void _drawArcEye(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint, {
    required bool up,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    if (up) {
      // Happy/squint arc curving upward
      canvas.drawArc(rect, -pi + 0.3, pi - 0.6, false, paint);
    } else {
      canvas.drawArc(rect, 0.3, pi - 0.6, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) =>
      oldDelegate.mood != mood;
}
