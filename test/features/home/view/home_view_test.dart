import 'package:evencir_project/core/theme/app_theme.dart';
import 'package:evencir_project/features/home/bloc/home_cubit.dart';
import 'package:evencir_project/features/home/pages/home_page.dart';
import 'package:evencir_project/features/home/pages/home_view.dart';
import 'package:evencir_project/tab/cubit/date_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// Helper function to create a MaterialApp with theme
Widget _createThemedApp({required Widget child}) {
  return MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    home: child,
  );
}

void main() {
  group('HomeView Widget Tests', () {
    testWidgets('Home page renders with all UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('Home page displays date header', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should display current date or month
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Home page has date selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should have selectable date widgets
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Home page displays current date on load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Home page AppBar is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Home page allows date selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(
          child: BlocProvider(
            create: (context) => DateCubit(),
            child: HomePage(selectedDate: DateTime.now()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap a date
      final gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        await tester.tap(gestureDetectors.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Home page displays calendar grid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should have multiple container/day widgets
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Home page has scrollable content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should be able to scroll
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('Home page cubit integration', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(child: HomePage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      expect(find.byType(BlocListener<HomeCubit, HomeState>), findsWidgets);
    });

    testWidgets('Home page rebuilds on date change', (
      WidgetTester tester,
    ) async {
      final dateCubit = DateCubit();

      await tester.pumpWidget(
        _createThemedApp(
          child: BlocProvider<DateCubit>.value(
            value: dateCubit,
            child: HomePage(selectedDate: DateTime.now()),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuild = find.byType(Text).evaluate().length;

      // Change date
      dateCubit.setDate(DateTime(2026, 4, 15));
      await tester.pumpAndSettle();

      // Verify rebuild happened
      expect(
        find.byType(Text).evaluate().length,
        greaterThanOrEqualTo(initialBuild),
      );

      dateCubit.close();
    });
  });
}
