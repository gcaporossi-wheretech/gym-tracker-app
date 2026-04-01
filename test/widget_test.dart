import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gym_tracker_app/main.dart';

void main() {
  testWidgets('App renders with bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: GymTrackerApp()),
    );

    expect(find.text('GymTracker'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Storico'), findsOneWidget);
    expect(find.text('Grafici'), findsOneWidget);
    expect(find.text('Profilo'), findsOneWidget);
  });
}
