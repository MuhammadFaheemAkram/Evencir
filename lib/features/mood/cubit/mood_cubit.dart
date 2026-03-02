import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:flutter/material.dart';

part 'mood_state.dart';

enum Mood { happy, calm, content, peaceful }

class MoodCubit extends Cubit<MoodState> {
  MoodCubit()
    : super(
        MoodState(angle: _moodAngles[Mood.calm] ?? 0, currentMood: Mood.calm),
      );

  // Each mood occupies a 90° (π/2) quadrant, starting from top going clockwise.
  // top-right = Calm, bottom-right = Content,
  // bottom-left = Peaceful, top-left = Happy
  static const _moodAngles = <Mood, double>{
    Mood.calm: pi * 0.25, // 45°  — center of top-right quadrant
    Mood.content: pi * 0.75, // 135° — center of bottom-right quadrant
    Mood.peaceful: pi * 1.25, // 225° — center of bottom-left quadrant
    Mood.happy: pi * 1.75, // 315° — center of top-left quadrant
  };

  /// Get mood from angle
  Mood _getMoodFromAngle(double angle) {
    final a = angle % (2 * pi);
    if (a < pi / 2) return Mood.calm; // 0–90°  top-right
    if (a < pi) return Mood.content; // 90–180° bottom-right
    if (a < 3 * pi / 2) return Mood.peaceful; // 180–270° bottom-left
    return Mood.happy; // 270–360° top-left
  }

  /// Get emoji icon for mood
  AppIcon getEmojiIcon(Mood mood) {
    switch (mood) {
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

  /// Convert touch position to angle
  double offsetToAngle(Offset position, Offset center) {
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    // atan2 from positive-x, convert so 0 = top (12 o'clock) going clockwise
    double a = atan2(dy, dx) + pi / 2;
    if (a < 0) a += 2 * pi;
    return a;
  }

  /// Update angle and mood
  void updateAngle(double angle) {
    final mood = _getMoodFromAngle(angle);
    emit(state.copyWith(angle: angle, currentMood: mood));
  }

  /// Get target angle for snapping
  double getSnapTargetAngle() {
    return _moodAngles[state.currentMood]!;
  }

  /// Calculate shortest path for snap animation
  double calculateSnapDelta(double startAngle, double targetAngle) {
    double diff = targetAngle - startAngle;
    if (diff > pi) diff -= 2 * pi;
    if (diff < -pi) diff += 2 * pi;
    return diff;
  }
}
