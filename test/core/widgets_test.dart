import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gym_tracker_app/core/widgets/widgets.dart';
import 'package:gym_tracker_app/core/theme/app_theme.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('GlassmorphismCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlassmorphismCard(child: Text('Test Content')),
      ));
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('responds to tap when onTap is provided', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        GlassmorphismCard(
          onTap: () => tapped = true,
          child: const Text('Tap me'),
        ),
      ));
      await tester.tap(find.text('Tap me'));
      expect(tapped, true);
    });
  });

  group('GlowButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        GlowButton(label: 'Inizia Workout', onPressed: () {}),
      ));
      expect(find.text('Inizia Workout'), findsOneWidget);
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        GlowButton(
          label: 'Start',
          icon: Icons.fitness_center,
          onPressed: () {},
        ),
      ));
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('is disabled when enabled is false', (tester) async {
      var pressed = false;
      await tester.pumpWidget(wrapWithTheme(
        GlowButton(
          label: 'Disabled',
          onPressed: () => pressed = true,
          enabled: false,
        ),
      ));
      await tester.tap(find.text('Disabled'));
      expect(pressed, false);
    });
  });

  group('NeonText', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const NeonText('PR!'),
      ));
      expect(find.text('PR!'), findsOneWidget);
    });
  });

  group('GradientText', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GradientText('GymTracker'),
      ));
      expect(find.text('GymTracker'), findsOneWidget);
    });
  });

  group('BigNumber', () {
    testWidgets('renders value and unit', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const BigNumber('75', unit: 'kg'),
      ));
      expect(find.text('75'), findsOneWidget);
      expect(find.text('kg'), findsOneWidget);
    });

    testWidgets('renders without unit', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const BigNumber('12'),
      ));
      expect(find.text('12'), findsOneWidget);
    });
  });
}
