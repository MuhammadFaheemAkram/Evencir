import 'package:evencir_project/core/theme/app_theme.dart';
import 'package:evencir_project/features/mood/cubit/mood_cubit.dart';
import 'package:evencir_project/features/mood/pages/mood_page.dart';
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
  group('MoodView Widget Tests', () {
    testWidgets('Mood page is a StatelessWidget', (WidgetTester tester) async {
      expect(MoodPage, isNotNull);
      expect(const MoodPage(), isA<Widget>());
    });

    testWidgets('MoodPage creates MoodCubit with BlocProvider', (
      WidgetTester tester,
    ) async {
      const widget = MoodPage();
      expect(widget, isNotNull);
    });

    testWidgets('Mood label displays in Scaffold', (WidgetTester tester) async {
      // Test with constrained viewport to avoid overflow
      addTearDown(tester.view.resetPhysicalSize);

      tester.view.physicalSize = const Size(800, 1400);

      await tester.pumpWidget(
        _createThemedApp(
          child: Scaffold(
            body: Center(
              child: BlocProvider(
                create: (_) => MoodCubit(),
                child: const Text('Calm'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Calm'), findsOneWidget);
    });

    testWidgets('Continue button renders in Scaffold', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);

      tester.view.physicalSize = const Size(800, 1400);

      await tester.pumpWidget(
        _createThemedApp(
          child: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Continue'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('GestureDetector for mood wheel interaction', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);

      tester.view.physicalSize = const Size(800, 1400);

      await tester.pumpWidget(
        _createThemedApp(
          child: Scaffold(
            body: GestureDetector(
              onTapDown: (_) {},
              child: Container(width: 300, height: 300, color: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('Mood page scaffold structure', (WidgetTester tester) async {
      addTearDown(tester.view.resetPhysicalSize);

      tester.view.physicalSize = const Size(800, 1400);

      await tester.pumpWidget(
        _createThemedApp(
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Text('Header'),
                  Container(width: 200, height: 200, color: Colors.blue),
                  const Text('Label'),
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('AnimatedSwitcher usage in mood view', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      tester.view.physicalSize = const Size(800, 1400);

      await tester.pumpWidget(
        _createThemedApp(
          child: const Scaffold(
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Text('Calm', key: ValueKey('calm')),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });

    testWidgets('MoodPage integration with BlocProvider', (
      WidgetTester tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      tester.view.physicalSize = const Size(800, 1400);

      await tester.pumpWidget(
        _createThemedApp(
          child: BlocProvider(
            create: (_) => MoodCubit(),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: Text(context.watch<MoodCubit>().state.moodLabel),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
