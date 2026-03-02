import 'dart:math';

import 'package:evencir_project/theme/app_colors_extension.dart';
import 'package:evencir_project/utils/app_icons.dart';
import 'package:evencir_project/widgets/mood_face_painter.dart';
import 'package:evencir_project/widgets/mood_ring_painter.dart';
import 'package:flutter/material.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen>
    with SingleTickerProviderStateMixin {
  /// Angle in radians (0 = top / 12 o'clock, going clockwise 0..2π).
  double _angle = _moodAngles[Mood.calm]!; // default: Calm

  // Each mood occupies a 90° (π/2) quadrant, starting from top going clockwise.
  // top-right = Calm, bottom-right = Content,
  // bottom-left = Peaceful, top-left = Happy
  static const _moodAngles = <Mood, double>{
    Mood.calm: pi * 0.25, // 45°  — center of top-right quadrant
    Mood.content: pi * 0.75, // 135° — center of bottom-right quadrant
    Mood.peaceful: pi * 1.25, // 225° — center of bottom-left quadrant
    Mood.happy: pi * 1.75, // 315° — center of top-left quadrant
  };

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

  // ── Mood from current angle ──

  Mood get _currentMood {
    final a = _angle % (2 * pi);
    if (a < pi / 2) return Mood.calm; // 0–90°  top-right
    if (a < pi) return Mood.content; // 90–180° bottom-right
    if (a < 3 * pi / 2) return Mood.peaceful; // 180–270° bottom-left
    return Mood.happy; // 270–360° top-left
  }

  String get _moodLabel {
    switch (_currentMood) {
      case Mood.happy:
        return 'Happy';
      case Mood.calm:
        return 'Calm';
      case Mood.content:
        return 'Content';
      case Mood.peaceful:
        return 'Peaceful';
    }
  }

  AppIcon get _emojiIcon {
    switch (_currentMood) {
      case Mood.happy:
        return AppIcon.happy;
      case Mood.calm:
        return AppIcon.calm;
      case Mood.content:
        return AppIcon.content;
      case Mood.peaceful:
        return AppIcon.peaceful;
    }
  }

  // ── Touch → angle conversion ──

  double _offsetToAngle(Offset position, Offset center) {
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    // atan2 from positive-x, convert so 0 = top (12 o'clock) going clockwise
    double a = atan2(dy, dx) + pi / 2;
    if (a < 0) a += 2 * pi;
    return a;
  }

  void _onPanStart(DragStartDetails details, Offset center, double ringRadius) {
    _snapController.stop();
    final pos = details.localPosition;
    final dist = (pos - center).distance;
    if ((dist - ringRadius).abs() < 40) {
      setState(() => _angle = _offsetToAngle(pos, center));
    }
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    Offset center,
    double ringRadius,
  ) {
    setState(() => _angle = _offsetToAngle(details.localPosition, center));
  }

  void _onPanEnd(DragEndDetails details) {
    // Snap to the center of the nearest mood quadrant
    final targetAngle = _moodAngles[_currentMood]!;
    final startAngle = _angle;

    // Handle wrapping for shortest path
    double diff = targetAngle - startAngle;
    if (diff > pi) diff -= 2 * pi;
    if (diff < -pi) diff += 2 * pi;
    final adjustedTarget = startAngle + diff;

    _snapAnimation = Tween<double>(
        begin: startAngle,
        end: adjustedTarget,
      ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut))
      ..addListener(() {
        if (mounted) {
          setState(() {
            double a = _snapAnimation!.value % (2 * pi);
            if (a < 0) a += 2 * pi;
            _angle = a;
          });
        }
      });

    _snapController.forward(from: 0);
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Title
              Text(
                'Mood',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
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
              const SizedBox(height: 32),
              // ── Mood Wheel ──
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wheelSize = min(constraints.maxWidth * 1.0, 293.0);
                    final ringRadius =
                        wheelSize / 2 - (wheelSize / 2 * 0.22 / 2) - 12;
                    final center = Offset(wheelSize / 2, wheelSize / 2);

                    return GestureDetector(
                      onPanStart: (d) => _onPanStart(d, center, ringRadius),
                      onPanUpdate: (d) => _onPanUpdate(d, center, ringRadius),
                      onPanEnd: _onPanEnd,
                      onTapDown: (d) {
                        final dist = (d.localPosition - center).distance;
                        if ((dist - ringRadius).abs() < 40) {
                          setState(() {
                            _angle = _offsetToAngle(d.localPosition, center);
                          });
                        }
                      },
                      onTapUp: (_) => _onPanEnd(DragEndDetails()),
                      child: SizedBox(
                        width: wheelSize,
                        height: wheelSize,
                        child: Stack(
                          children: [
                            // Ring — CustomPainter with SweepGradient for
                            // smooth blended color transitions between moods
                            Positioned.fill(
                              child: CustomPaint(
                                painter: MoodRingPainter(thumbAngle: _angle),
                              ),
                            ),
                            // Center emoji SVG
                            Center(
                              child: SizedBox(
                                width: wheelSize * 0.38,
                                height: wheelSize * 0.38,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: AppIcons.svg(
                                    _emojiIcon,
                                    size: wheelSize * 0.38,
                                    key: ValueKey(_emojiIcon),
                                  ),
                                ),
                              ),
                            ),
                            // Draggable thumb
                            Positioned(
                              left:
                                  center.dx -
                                  25 +
                                  ringRadius * cos(_angle - pi / 2),
                              top:
                                  center.dy -
                                  25 +
                                  ringRadius * sin(_angle - pi / 2),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFE8F0EC),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // ── Mood label ──
              const SizedBox(height: 32),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _moodLabel,
                    key: ValueKey(_moodLabel),
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // ── Continue button ──
              Padding(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
