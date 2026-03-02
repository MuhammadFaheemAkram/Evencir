import 'package:flutter/material.dart';

/// Represents a single workout / training entry assigned to a date.
@immutable
class TrainingEntry {

  const TrainingEntry({
    required this.workoutType,
    required this.name,
    required this.duration,
    required this.badgeColor,
  });
  final String workoutType;
  final String name;
  final String duration;
  final Color badgeColor;
}
