import '../models/workout_plan.dart';

/// Repository astratto per la gestione delle schede di allenamento
abstract class WorkoutPlanRepository {
  Future<WorkoutPlan?> getActivePlan();
  Future<void> savePlan(WorkoutPlan plan);
  Future<void> deletePlan(String planId);
  Future<List<WorkoutPlan>> getAllPlans();
}
