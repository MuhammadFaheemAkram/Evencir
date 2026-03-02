import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single workout / training entry assigned to a date.

class TrainingModel extends Equatable {
  const TrainingModel({
    required this.workoutType,
    required this.name,
    required this.duration,
    required this.badgeColor,
  });
  final String workoutType;
  final String name;
  final String duration;
  final Color badgeColor;

  @override
  List<Object?> get props => [workoutType, name, duration, badgeColor];
}
