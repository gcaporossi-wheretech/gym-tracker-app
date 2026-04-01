import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/models.dart';
import '../../../repositories/workout_plan_repository.dart';
import '../../../services/providers.dart';

/// Notifier per le modifiche alla scheda di allenamento.
/// Gestisce: swap giorni, modifica esercizi, skip sedute.
class PlanEditNotifier extends Notifier<void> {
  @override
  void build() {}

  WorkoutPlanRepository get _repo => ref.read(workoutPlanRepositoryProvider);

  /// Scambia due giorni della settimana nella scheda
  Future<void> swapDays(WorkoutPlan plan, int dayA, int dayB) async {
    final days = plan.days.map((d) {
      if (d.dayOfWeek == dayA) {
        return d.copyWith(dayOfWeek: dayB);
      } else if (d.dayOfWeek == dayB) {
        return d.copyWith(dayOfWeek: dayA);
      }
      return d;
    }).toList();

    final updated = plan.copyWith(days: days);
    await _repo.savePlan(updated);
  }

  /// Aggiorna serie/rep/peso di un esercizio
  Future<void> updateExercise({
    required WorkoutPlan plan,
    required String dayId,
    required int exerciseIndex,
    required int sets,
    required int reps,
    required double suggestedWeight,
  }) async {
    final days = plan.days.map((d) {
      if (d.id != dayId) return d;

      final exercises = List<ExercisePlan>.from(d.exercises);
      exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(
        sets: sets,
        reps: reps,
        suggestedWeight: suggestedWeight,
      );
      return d.copyWith(exercises: exercises);
    }).toList();

    final updated = plan.copyWith(days: days);
    await _repo.savePlan(updated);
  }
}

final planEditNotifierProvider = NotifierProvider<PlanEditNotifier, void>(() {
  return PlanEditNotifier();
});
