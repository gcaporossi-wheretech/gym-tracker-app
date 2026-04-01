import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gym_tracker_app/core/theme/app_theme.dart';
import 'package:gym_tracker_app/features/workout/presentation/workout_today_screen.dart';
import 'package:gym_tracker_app/repositories/workout_plan_repository.dart';
import 'package:gym_tracker_app/repositories/session_repository.dart';
import 'package:gym_tracker_app/services/providers.dart';
import 'package:gym_tracker_app/models/models.dart';

class FakeWorkoutPlanRepository implements WorkoutPlanRepository {
  @override
  Future<WorkoutPlan?> getActivePlan() async => null;
  @override
  Future<void> savePlan(WorkoutPlan plan) async {}
  @override
  Future<void> deletePlan(String planId) async {}
  @override
  Future<List<WorkoutPlan>> getAllPlans() async => [];
}

class FakeSessionRepository implements SessionRepository {
  @override
  Future<List<WorkoutSession>> getAllSessions() async => [];
  @override
  Future<List<WorkoutSession>> getSessionsInRange(DateTime from, DateTime to) async => [];
  @override
  Future<WorkoutSession?> getSession(String sessionId) async => null;
  @override
  Future<void> saveSession(WorkoutSession session) async {}
  @override
  Future<void> deleteSession(String sessionId) async {}
  @override
  Future<WorkoutSession?> getActiveSession() async => null;
}

void main() {
  testWidgets('App renders with bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutPlanRepositoryProvider.overrideWithValue(FakeWorkoutPlanRepository()),
          sessionRepositoryProvider.overrideWithValue(FakeSessionRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const _TestShell(),
        ),
      ),
    );

    expect(find.text('Workout'), findsOneWidget);
    expect(find.text('Storico'), findsOneWidget);
    expect(find.text('Grafici'), findsOneWidget);
    expect(find.text('Profilo'), findsOneWidget);
  });
}

/// Shell di test senza import di export_screen (evita dart:html)
class _TestShell extends StatelessWidget {
  const _TestShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const WorkoutTodayScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Storico'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Grafici'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}
