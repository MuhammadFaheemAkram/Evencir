import 'package:evencir_project/core/theme/app_theme.dart';
import 'package:evencir_project/features/mood/cubit/mood_cubit.dart';
import 'package:evencir_project/features/mood/pages/mood_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Widget _createThemedApp({required Widget child}) {
  return MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    home: child,
    debugShowCheckedModeBanner: false,
  );
}

void main() {
  const List<Device> light = [
    Device.phone,
    Device(name: 'iPhone11', size: Size(414, 896)),
    Device(name: 'iPhone14 Pro Max', size: Size(430, 932)),
  ];

  const List<Device> dark = [
    Device(name: 'phone', size: Size(375, 667), brightness: Brightness.dark),
    Device(name: 'iPhone11', size: Size(414, 896), brightness: Brightness.dark),
    Device(
      name: 'iPhone14 Pro Max',
      size: Size(430, 932),
      brightness: Brightness.dark,
    ),
  ];
  group('MoodView Golden Tests', () {
    testGoldens('MoodView Initial State', (tester) async {
      final widget = _createThemedApp(
        child: BlocProvider(
          create: (_) => MoodCubit(),
          child: const MoodView(),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(widget: widget, name: 'calm_mood_light')
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(widget: widget, name: 'calm_mood_dark');

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'mood_view_calm');
    });

    testGoldens('MoodView Content Mood', (tester) async {
      final moodCubit = MoodCubit();
      final widget = _createThemedApp(
        child: BlocProvider<MoodCubit>.value(
          value: moodCubit,
          child: const MoodView(),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(
              widget: widget,
              name: 'content_mood_light',
              onCreate: (scenarioWidgetKey) async {
                moodCubit.updateAngle(3.14159 * 0.75);
                await tester.pumpAndSettle();
              },
            )
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(
              widget: widget,
              name: 'content_mood_dark',
              onCreate: (scenarioWidgetKey) async {
                moodCubit.updateAngle(3.14159 * 0.75);
                await tester.pumpAndSettle();
              },
            );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'mood_view_content');
      moodCubit.close();
    });

    testGoldens('MoodView Happy Mood', (tester) async {
      final moodCubit = MoodCubit();
      final widget = _createThemedApp(
        child: BlocProvider<MoodCubit>.value(
          value: moodCubit,
          child: const MoodView(),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(
              widget: widget,
              name: 'happy_mood_light',
              onCreate: (scenarioWidgetKey) async {
                moodCubit.updateAngle(3.14159 * 1.75);
                await tester.pumpAndSettle();
              },
            )
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(
              widget: widget,
              name: 'happy_mood_dark',
              onCreate: (scenarioWidgetKey) async {
                moodCubit.updateAngle(3.14159 * 1.75);
                await tester.pumpAndSettle();
              },
            );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'mood_view_happy');
      moodCubit.close();
    });

    testGoldens('MoodView Peaceful Mood', (tester) async {
      final moodCubit = MoodCubit();
      final widget = _createThemedApp(
        child: BlocProvider<MoodCubit>.value(
          value: moodCubit,
          child: const MoodView(),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(
              widget: widget,
              name: 'peaceful_mood_light',
              onCreate: (scenarioWidgetKey) async {
                moodCubit.updateAngle(3.14159 * 1.25);
                await tester.pumpAndSettle();
              },
            )
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(
              widget: widget,
              name: 'peaceful_mood_dark',
              onCreate: (scenarioWidgetKey) async {
                moodCubit.updateAngle(3.14159 * 1.25);
                await tester.pumpAndSettle();
              },
            );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'mood_view_peaceful');
      moodCubit.close();
    });
  });
}
