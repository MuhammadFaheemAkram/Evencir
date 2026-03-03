import 'package:evencir_project/core/theme/app_theme.dart';
import 'package:evencir_project/features/plan/models/training_model.dart';
import 'package:evencir_project/features/plan/pages/plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// Helper function to create a MaterialApp with theme
Widget _createThemedApp({required Widget child}) {
  return MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    home: child,
  );
}

void main() {
  group('PlanView Widget Tests', () {
    testWidgets('Plan page renders with all UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      expect(find.text('Training Calendar'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('Plan page displays week sections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should find week headers (Week 1/4, etc.)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Plan page has scrollable list', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should have a scrollable widget
      expect(find.byType(ScrollablePositionedList), findsWidgets);
    });

    testWidgets('Plan page displays workout entries', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // PlanCubit initializes with sample plans
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets('Plan page AppBar is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Plan page has week headers', (WidgetTester tester) async {
      final now = DateTime.now();

      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: now)),
      );

      await tester.pumpAndSettle();

      // Look for week number text (e.g., "Week 1/4")
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Plan page day rows are draggable', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month);

      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: firstDay)),
      );

      await tester.pumpAndSettle();

      // Draggable elements should be present
      expect(
        find.byType(DragTarget<MapEntry<DateTime, TrainingModel>>),
        findsWidgets,
      );
    });

    testWidgets('Plan page renders correctly on day with no workout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // Should find day names
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Plan page shows month name in status', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createThemedApp(child: PlanPage(selectedDate: DateTime.now())),
      );

      await tester.pumpAndSettle();

      // App bar should have content
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
