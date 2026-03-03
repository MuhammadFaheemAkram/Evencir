import 'package:evencir_project/core/theme/app_theme.dart';
import 'package:evencir_project/features/home/pages/home_page.dart';
import 'package:evencir_project/tab/cubit/date_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// Helper function to create a MaterialApp with theme
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

  group('HomeView Golden Tests', () {
    testGoldens('HomeScreen', (tester) async {
      final widget = _createThemedApp(
        child: BlocProvider(
          create: (context) => DateCubit(),
          child: HomePage(selectedDate: DateTime.now()),
        ),
      );
      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(widget: widget, name: 'light')
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(widget: widget, name: 'dark');

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'home_view');
    });

    testGoldens('HomeView with date selected', (tester) async {
      final dateCubit = DateCubit();
      final widget = _createThemedApp(
        child: BlocProvider<DateCubit>.value(
          value: dateCubit,
          child: HomePage(selectedDate: DateTime(2026, 13, 15)),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(
              widget: widget,
              name: 'light',
              onCreate: (scenarioWidgetKey) async {
                dateCubit.setDate(DateTime(2026, 13, 15));
                await tester.pumpAndSettle();
              },
            )
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(
              widget: widget,
              name: 'dark',
              onCreate: (scenarioWidgetKey) async {
                dateCubit.setDate(DateTime(2026, 13, 15));
                await tester.pumpAndSettle();
              },
            );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'home_view_date_selected');
      dateCubit.close();
    });

    testGoldens('HomeView Calendar Grid', (tester) async {
      final widget = _createThemedApp(
        child: BlocProvider(
          create: (context) => DateCubit(),
          child: HomePage(selectedDate: DateTime.now()),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(widget: widget, name: 'light')
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(widget: widget, name: 'dark');

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'home_view_calendar_grid');
    });

    testGoldens('HomeView Scrolled Content', (tester) async {
      final widget = _createThemedApp(
        child: BlocProvider(
          create: (context) => DateCubit(),
          child: HomePage(selectedDate: DateTime.now()),
        ),
      );

      final builder =
          DeviceBuilder()
            ..overrideDevicesForAllScenarios(devices: light)
            ..addScenario(
              widget: widget,
              name: 'scrolled light',
              onCreate: (scenarioWidgetKey) async {
                await tester.drag(
                  find.byType(SingleChildScrollView).first,
                  const Offset(0, -300),
                );
                await tester.pumpAndSettle();
              },
            )
            ..overrideDevicesForAllScenarios(devices: dark)
            ..addScenario(
              widget: widget,
              name: 'scrolled dark',
              onCreate: (scenarioWidgetKey) async {
                await tester.drag(
                  find.byType(SingleChildScrollView).first,
                  const Offset(0, -300),
                );
                await tester.pumpAndSettle();
              },
            );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'home_view_scrolled');
    });
  });
}
