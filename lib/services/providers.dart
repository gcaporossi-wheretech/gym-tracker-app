import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/measurement_repository.dart';
import '../repositories/workout_plan_repository.dart';
import '../repositories/session_repository.dart';
import 'workout_plan_service.dart';

/// Repository providers
final workoutPlanRepositoryProvider = Provider<WorkoutPlanRepository>((ref) {
  throw UnimplementedError('Must be overridden at app startup');
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  throw UnimplementedError('Must be overridden at app startup');
});

final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  throw UnimplementedError('Must be overridden at app startup');
});

/// Service providers
final workoutPlanServiceProvider = Provider<WorkoutPlanService>((ref) {
  return WorkoutPlanService(ref.watch(workoutPlanRepositoryProvider));
});

/// Active workout plan
final activePlanProvider = FutureProvider<WorkoutPlan>((ref) async {
  final service = ref.watch(workoutPlanServiceProvider);
  return service.getOrLoadActivePlan();
});

/// Today's workout
final todayPlanProvider = Provider<DayPlan?>((ref) {
  final planAsync = ref.watch(activePlanProvider);
  return planAsync.whenOrNull(
    data: (plan) {
      final service = ref.read(workoutPlanServiceProvider);
      return service.getTodayPlan(plan);
    },
  );
});

/// Program position (week, phase, deload)
final programPositionProvider = Provider<ProgramPosition?>((ref) {
  final planAsync = ref.watch(activePlanProvider);
  return planAsync.whenOrNull(
    data: (plan) {
      final service = ref.read(workoutPlanServiceProvider);
      return service.getProgramPosition(plan);
    },
  );
});
