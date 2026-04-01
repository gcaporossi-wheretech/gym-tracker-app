import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/models/models.dart';
import 'package:gym_tracker_app/services/workout_plan_service.dart';
import 'package:gym_tracker_app/repositories/workout_plan_repository.dart';

/// In-memory implementation for testing
class InMemoryWorkoutPlanRepository implements WorkoutPlanRepository {
  final Map<String, WorkoutPlan> _plans = {};
  String? _activeId;

  @override
  Future<WorkoutPlan?> getActivePlan() async {
    if (_activeId == null) return null;
    return _plans[_activeId];
  }

  @override
  Future<void> savePlan(WorkoutPlan plan) async {
    _plans[plan.id] = plan;
    _activeId ??= plan.id;
  }

  @override
  Future<void> deletePlan(String planId) async {
    _plans.remove(planId);
    if (_activeId == planId) _activeId = null;
  }

  @override
  Future<List<WorkoutPlan>> getAllPlans() async => _plans.values.toList();
}

void main() {
  group('WorkoutPlanService', () {
    late WorkoutPlanService service;
    late InMemoryWorkoutPlanRepository repo;

    setUp(() {
      repo = InMemoryWorkoutPlanRepository();
      service = WorkoutPlanService(repo);
    });

    WorkoutPlan createTestPlan({DateTime? startDate}) {
      return WorkoutPlan(
        id: 'test-plan',
        name: 'Test Plan',
        startDate: startDate ?? DateTime(2026, 4, 1),
        totalWeeks: 12,
        phases: const [
          Phase(number: 1, name: 'Fase 1', weekStart: 1, weekEnd: 4),
          Phase(number: 2, name: 'Fase 2', weekStart: 5, weekEnd: 8),
          Phase(number: 3, name: 'Fase 3', weekStart: 9, weekEnd: 12),
        ],
        days: const [
          DayPlan(
            id: 'monday',
            dayOfWeek: 1,
            name: 'Petto + Tricipiti',
            exercises: [
              ExercisePlan(
                id: 'ex1',
                name: 'Panca',
                equipment: 'Bilanciere',
                muscleGroup: 'chest',
                sets: 4,
                reps: 8,
              ),
            ],
          ),
          DayPlan(
            id: 'tuesday',
            dayOfWeek: 2,
            name: 'Dorso + Bicipiti',
            exercises: [],
          ),
          DayPlan(
            id: 'wednesday',
            dayOfWeek: 3,
            name: 'Gambe',
            exercises: [],
          ),
          DayPlan(
            id: 'thursday',
            dayOfWeek: 4,
            name: 'Spalle',
            exercises: [],
          ),
          DayPlan(
            id: 'friday',
            dayOfWeek: 5,
            name: 'Braccia',
            exercises: [],
          ),
        ],
      );
    }

    test('getDayPlan returns correct day', () {
      final plan = createTestPlan();
      final monday = service.getDayPlan(plan, 1);
      expect(monday?.name, 'Petto + Tricipiti');

      final friday = service.getDayPlan(plan, 5);
      expect(friday?.name, 'Braccia');
    });

    test('getDayPlan returns null for weekend', () {
      final plan = createTestPlan();
      expect(service.getDayPlan(plan, 6), isNull); // Saturday
      expect(service.getDayPlan(plan, 7), isNull); // Sunday
    });

    test('getCurrentWeek calculates correctly', () {
      // Week 1: starts April 1
      final plan = createTestPlan(startDate: DateTime.now());
      expect(service.getCurrentWeek(plan), 1);

      // 14 days ago = week 3
      final plan2 = createTestPlan(
        startDate: DateTime.now().subtract(const Duration(days: 14)),
      );
      expect(service.getCurrentWeek(plan2), 3);
    });

    test('getCurrentWeek clamps to totalWeeks', () {
      // Started 100 days ago = well past 12 weeks
      final plan = createTestPlan(
        startDate: DateTime.now().subtract(const Duration(days: 100)),
      );
      expect(service.getCurrentWeek(plan), 12);
    });

    test('getCurrentPhase returns correct phase', () {
      // Week 1 = Phase 1
      final plan = createTestPlan(startDate: DateTime.now());
      final phase = service.getCurrentPhase(plan);
      expect(phase?.number, 1);
      expect(phase?.name, 'Fase 1');
    });

    test('isDeloadWeek identifies deload weeks', () {
      // Week 4 (28 days in)
      final plan4 = createTestPlan(
        startDate: DateTime.now().subtract(const Duration(days: 21)),
      );
      expect(service.isDeloadWeek(plan4), true);

      // Week 3 (14 days in)
      final plan3 = createTestPlan(
        startDate: DateTime.now().subtract(const Duration(days: 14)),
      );
      expect(service.isDeloadWeek(plan3), false);
    });

    test('getProgramPosition returns complete info', () {
      final plan = createTestPlan(startDate: DateTime.now());
      final pos = service.getProgramPosition(plan);

      expect(pos.week, 1);
      expect(pos.totalWeeks, 12);
      expect(pos.phase?.name, 'Fase 1');
      expect(pos.isDeload, false);
      expect(pos.progressPercentage, closeTo(0.083, 0.01));
    });

    test('getOrLoadActivePlan returns saved plan', () async {
      final plan = createTestPlan();
      await repo.savePlan(plan);

      final result = await service.getOrLoadActivePlan();
      expect(result.name, 'Test Plan');
    });
  });

  group('scheda_aprile_2026.json', () {
    test('JSON file parses correctly into WorkoutPlan', () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Load the actual JSON asset
      final jsonString = await rootBundle
          .loadString('assets/data/scheda_aprile_2026.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final plan = WorkoutPlan.fromJson(json);

      expect(plan.name, 'Scheda Aprile 2026 - Ricomposizione Corporea');
      expect(plan.totalWeeks, 12);
      expect(plan.phases.length, 3);
      expect(plan.days.length, 5);
    });

    test('JSON has all 5 days with correct exercises count', () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      final jsonString = await rootBundle
          .loadString('assets/data/scheda_aprile_2026.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final plan = WorkoutPlan.fromJson(json);

      // Monday: 7 exercises
      final mon = plan.days.firstWhere((d) => d.dayOfWeek == 1);
      expect(mon.name, 'Petto + Tricipiti');
      expect(mon.exercises.length, 7);

      // Tuesday: 8 exercises
      final tue = plan.days.firstWhere((d) => d.dayOfWeek == 2);
      expect(tue.name, 'Dorso + Bicipiti');
      expect(tue.exercises.length, 8);

      // Wednesday: 9 exercises
      final wed = plan.days.firstWhere((d) => d.dayOfWeek == 3);
      expect(wed.name, 'Gambe + Core');
      expect(wed.exercises.length, 9);

      // Thursday: 8 exercises
      final thu = plan.days.firstWhere((d) => d.dayOfWeek == 4);
      expect(thu.name, 'Spalle + Trapezi + Core');
      expect(thu.exercises.length, 8);

      // Friday: 10 exercises
      final fri = plan.days.firstWhere((d) => d.dayOfWeek == 5);
      expect(fri.name, 'Upper Pump + Braccia + Core');
      expect(fri.exercises.length, 10);
    });

    test('JSON exercises have all required fields populated', () async {
      TestWidgetsFlutterBinding.ensureInitialized();

      final jsonString = await rootBundle
          .loadString('assets/data/scheda_aprile_2026.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final plan = WorkoutPlan.fromJson(json);

      for (final day in plan.days) {
        for (final ex in day.exercises) {
          expect(ex.id, isNotEmpty, reason: '${ex.name} missing id');
          expect(ex.name, isNotEmpty, reason: 'exercise missing name');
          expect(ex.equipment, isNotEmpty, reason: '${ex.name} missing equipment');
          expect(ex.muscleGroup, isNotEmpty, reason: '${ex.name} missing muscleGroup');
          expect(ex.sets, greaterThan(0), reason: '${ex.name} sets must be > 0');
          expect(ex.reps, greaterThan(0), reason: '${ex.name} reps must be > 0');
        }
      }
    });
  });
}
