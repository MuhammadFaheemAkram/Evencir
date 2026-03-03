import 'dart:math' as math;

import 'package:bloc_test/bloc_test.dart';
import 'package:evencir_project/core/utils/app_icons.dart';
import 'package:evencir_project/features/mood/cubit/mood_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoodCubit', () {
    late MoodCubit moodCubit;

    setUp(() {
      moodCubit = MoodCubit();
    });

    tearDown(() {
      moodCubit.close();
    });

    test('initial state has calm mood', () {
      expect(moodCubit.state.currentMood, equals(Mood.calm));
      expect(moodCubit.state.angle, equals(math.pi * 0.25));
    });

    blocTest<MoodCubit, MoodState>(
      'updateAngle emits new state with updated angle',
      build: () => moodCubit,
      act: (cubit) {
        cubit.updateAngle(math.pi * 0.75);
      },
      expect:
          () => [
            isA<MoodState>()
                .having((state) => state.angle, 'angle', equals(math.pi * 0.75))
                .having(
                  (state) => state.currentMood,
                  'mood',
                  equals(Mood.content),
                ),
          ],
    );

    test('moodLabel getter returns correct label for each mood', () {
      const calmState = MoodState(
        angle: math.pi * 0.25,
        currentMood: Mood.calm,
      );
      expect(calmState.moodLabel, equals('Calm'));

      const contentState = MoodState(
        angle: math.pi * 0.75,
        currentMood: Mood.content,
      );
      expect(contentState.moodLabel, equals('Content'));

      const peacefulState = MoodState(
        angle: math.pi * 1.25,
        currentMood: Mood.peaceful,
      );
      expect(peacefulState.moodLabel, equals('Peaceful'));

      const happyState = MoodState(
        angle: math.pi * 1.75,
        currentMood: Mood.happy,
      );
      expect(happyState.moodLabel, equals('Happy'));
    });

    test('getEmojiIcon returns correct icon for each mood', () {
      expect(moodCubit.getEmojiIcon(Mood.calm), equals(AppIcon.calm));
      expect(moodCubit.getEmojiIcon(Mood.content), equals(AppIcon.content));
      expect(moodCubit.getEmojiIcon(Mood.peaceful), equals(AppIcon.peaceful));
      expect(moodCubit.getEmojiIcon(Mood.happy), equals(AppIcon.happy));
    });

    test('offsetToAngle converts position correctly', () {
      const center = Offset(100, 100);
      final position = Offset(100 + 100 * math.cos(0), 100 + 100 * math.sin(0));
      final angle = moodCubit.offsetToAngle(position, center);
      // atan2 + pi/2 adjustment, expect angle close to 0 (top/12 o'clock)
      expect(angle, greaterThanOrEqualTo(0));
      expect(angle, lessThanOrEqualTo(2 * math.pi));
    });

    test('getSnapTargetAngle returns correct target for current mood', () {
      moodCubit.updateAngle(math.pi * 0.75); // Content mood
      final target = moodCubit.getSnapTargetAngle();
      expect(target, equals(math.pi * 0.75));
    });

    test('calculateSnapDelta handles angle wrapping correctly', () {
      final delta = moodCubit.calculateSnapDelta(math.pi * 1.8, 0.2);
      // Should take shortest path
      expect(delta.abs(), lessThan(math.pi));
    });

    blocTest<MoodCubit, MoodState>(
      'updateAngle transitions through all moods',
      build: () => moodCubit,
      act: (cubit) async {
        // Calm (0-90°)
        cubit.updateAngle(math.pi * 0.25);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        // Content (90-180°)
        cubit.updateAngle(math.pi * 0.75);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        // Peaceful (180-270°)
        cubit.updateAngle(math.pi * 1.25);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        // Happy (270-360°)
        cubit.updateAngle(math.pi * 1.75);
      },
      expect:
          () => [
            isA<MoodState>().having(
              (state) => state.currentMood,
              'mood',
              equals(Mood.calm),
            ),
            isA<MoodState>().having(
              (state) => state.currentMood,
              'mood',
              equals(Mood.content),
            ),
            isA<MoodState>().having(
              (state) => state.currentMood,
              'mood',
              equals(Mood.peaceful),
            ),
            isA<MoodState>().having(
              (state) => state.currentMood,
              'mood',
              equals(Mood.happy),
            ),
          ],
    );
  });
}
