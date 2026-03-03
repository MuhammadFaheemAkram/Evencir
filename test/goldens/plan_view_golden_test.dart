import 'package:evencir_project/core/theme/app_theme.dart';
import 'package:evencir_project/features/plan/pages/plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  group('PlanView Golden Tests', () {
    testGoldens('PlanView Initial State', (tester) async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month);

      final widget = _createThemedApp(child: PlanPage(selectedDate: firstDay));

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(widget: widget, name: 'initial_light')
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(widget: widget, name: 'initial_dark');

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'plan_view_initial');
    });

    testGoldens('PlanView First Week', (tester) async {
      final firstDay = DateTime(2026, 3);

      final widget = _createThemedApp(child: PlanPage(selectedDate: firstDay));

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(widget: widget, name: 'week_1_light')
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(widget: widget, name: 'week_1_dark');

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'plan_view_week_1');
    });

    testGoldens('PlanView Scrolled Content', (tester) async {
      final firstDay = DateTime(2026, 3);

      final widget = _createThemedApp(child: PlanPage(selectedDate: firstDay));

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(
              widget: widget,
              name: 'scrolled_light',
              onCreate: (scenarioWidgetKey) async {
                await tester.drag(
                  find.byType(ScrollablePositionedList).first,
                  const Offset(0, -300),
                );
                await tester.pumpAndSettle();
              },
            )
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(
              widget: widget,
              name: 'scrolled_dark',
              onCreate: (scenarioWidgetKey) async {
                await tester.drag(
                  find.byType(ScrollablePositionedList).first,
                  const Offset(0, -300),
                );
                await tester.pumpAndSettle();
              },
            );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'plan_view_scrolled');
    });

    testGoldens('PlanView With Workouts', (tester) async {
      final firstDay = DateTime(2026, 3, 8);

      final widget = _createThemedApp(child: PlanPage(selectedDate: firstDay));

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(widget: widget, name: 'with_workouts_light')
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(widget: widget, name: 'with_workouts_dark');

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'plan_view_with_workouts');
    });
  });
}
