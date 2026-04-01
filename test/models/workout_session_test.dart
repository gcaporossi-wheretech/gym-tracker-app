import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/models/models.dart';

void main() {
  group('WorkoutSession', () {
    late WorkoutSession session;

    setUp(() {
      session = WorkoutSession(
        id: 'session-1',
        date: DateTime(2026, 4, 7),
        dayPlanId: 'day-monday',
        workoutName: 'Petto + Tricipiti',
        exercises: [
          const ExerciseLog(
            exercisePlanId: 'ex-1',
            exerciseName: 'Panca inclinata',
            muscleGroup: 'chest',
            sets: [
              SetLog(setNumber: 1, plannedReps: 8, actualReps: 8, weight: 50, completed: true),
              SetLog(setNumber: 2, plannedReps: 8, actualReps: 8, weight: 50, completed: true),
              SetLog(setNumber: 3, plannedReps: 8, actualReps: 6, weight: 50, completed: true),
            ],
          ),
          const ExerciseLog(
            exercisePlanId: 'ex-2',
            exerciseName: 'Push down',
            muscleGroup: 'triceps',
            sets: [
              SetLog(setNumber: 1, plannedReps: 12, actualReps: 12, weight: 30, completed: true),
              SetLog(setNumber: 2, plannedReps: 12, actualReps: 10, weight: 30, completed: true),
            ],
          ),
          const ExerciseLog(
            exercisePlanId: 'ex-3',
            exerciseName: 'Croci',
            muscleGroup: 'chest',
            skipped: true,
            sets: [],
          ),
        ],
        completed: true,
        durationMinutes: 75,
      );
    });

    test('should calculate total volume for chest', () {
      // (8*50) + (8*50) + (6*50) = 400 + 400 + 300 = 1100
      expect(session.totalVolumeFor('chest'), 1100);
    });

    test('should calculate total volume for triceps', () {
      // (12*30) + (10*30) = 360 + 300 = 660
      expect(session.totalVolumeFor('triceps'), 660);
    });

    test('should exclude skipped exercises from volume', () {
      // Croci is skipped, should not count
      expect(session.totalVolumeFor('chest'), 1100); // only panca inclinata
    });

    test('should count total completed sets', () {
      // 3 from panca + 2 from push down = 5 (croci skipped)
      expect(session.totalCompletedSets, 5);
    });

    test('should calculate total volume', () {
      // 1100 (chest) + 660 (triceps) = 1760
      expect(session.totalVolume, 1760);
    });

    test('should serialize to JSON and back', () {
      // Use jsonEncode/jsonDecode for proper round-trip with nested lists
      final jsonString = jsonEncode(session.toJson());
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final restored = WorkoutSession.fromJson(decoded);

      expect(restored.id, session.id);
      expect(restored.workoutName, 'Petto + Tricipiti');
      expect(restored.exercises.length, 3);
      expect(restored.totalCompletedSets, 5);
    });

    test('should return zero volume for non-existent muscle group', () {
      expect(session.totalVolumeFor('legs'), 0);
    });
  });

  group('WorkoutPlan', () {
    test('should serialize to JSON and back via jsonEncode', () {
      final plan = WorkoutPlan(
        id: 'plan-1',
        name: 'Scheda Aprile 2026',
        startDate: DateTime(2026, 4, 1),
        totalWeeks: 12,
        phases: const [
          Phase(
            number: 1,
            name: 'Costruire le Fondamenta',
            weekStart: 1,
            weekEnd: 4,
          ),
        ],
        days: const [
          DayPlan(
            id: 'day-1',
            dayOfWeek: 1,
            name: 'Petto + Tricipiti',
            exercises: [
              ExercisePlan(
                id: 'ex-1',
                name: 'Panca inclinata',
                equipment: 'Bilanciere',
                muscleGroup: 'chest',
                sets: 4,
                reps: 8,
                suggestedWeight: 40,
                restSeconds: 120,
                rpe: 8,
              ),
            ],
          ),
        ],
      );

      final jsonString = jsonEncode(plan.toJson());
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final restored = WorkoutPlan.fromJson(decoded);

      expect(restored.name, 'Scheda Aprile 2026');
      expect(restored.days.length, 1);
      expect(restored.days.first.exercises.first.name, 'Panca inclinata');
      expect(restored.phases.first.name, 'Costruire le Fondamenta');
    });
  });
}
