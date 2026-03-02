part of 'mood_cubit.dart';

class MoodState extends Equatable {
  const MoodState({required this.angle, required this.currentMood});

  /// Angle in radians (0 = top / 12 o'clock, going clockwise 0..2π).
  final double angle;

  /// Current mood based on angle
  final Mood currentMood;

  MoodState copyWith({double? angle, Mood? currentMood}) {
    return MoodState(
      angle: angle ?? this.angle,
      currentMood: currentMood ?? this.currentMood,
    );
  }

  /// Get mood label
  String get moodLabel {
    switch (currentMood) {
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

  @override
  List<Object?> get props => [angle, currentMood];
}
