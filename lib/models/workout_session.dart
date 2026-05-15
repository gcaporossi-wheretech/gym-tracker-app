import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise_log.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

@freezed
class WorkoutSession with _$WorkoutSession {
  const WorkoutSession._();

  const factory WorkoutSession({
    required String id,
    required DateTime date,
    required String dayPlanId,
    required String workoutName,
    required List<ExerciseLog> exercises,
    @Default('') String notes,
    @Default(false) bool completed,
    @Default(0) int durationMinutes,
    @Default(0) int sessionRating, // 1-5
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionFromJson(json);

  /// Volume totale per un gruppo muscolare (serie x rep x peso)
  double totalVolumeFor(String muscleGroup) {
    return exercises
        .where((e) => e.muscleGroup == muscleGroup && !e.skipped)
        .expand((e) => e.sets)
        .where((s) => s.completed)
        .fold(0.0, (sum, s) => sum + (s.weight * s.actualReps));
  }

  /// Numero totale di serie completate
  int get totalCompletedSets => exercises
      .where((e) => !e.skipped)
      .expand((e) => e.sets)
      .where((s) => s.completed)
      .length;

  /// Volume totale della sessione
  double get totalVolume => exercises
      .where((e) => !e.skipped)
      .expand((e) => e.sets)
      .where((s) => s.completed)
      .fold(0.0, (sum, s) => sum + (s.weight * s.actualReps));

  /// Volume totale considerando il peso corporeo per esercizi bodyweight
  /// (quando weight=0, usa bodyweight come carico effettivo).
  double effectiveVolume(double bodyweight) {
    return exercises
        .where((e) => !e.skipped)
        .expand((e) => e.sets)
        .where((s) => s.completed)
        .fold(0.0, (sum, s) {
          final w = s.weight > 0 ? s.weight : bodyweight;
          return sum + (w * s.actualReps);
        });
  }

  /// Volume per gruppo muscolare con bodyweight fallback
  double effectiveVolumeFor(String muscleGroup, double bodyweight) {
    return exercises
        .where((e) => e.muscleGroup == muscleGroup && !e.skipped)
        .expand((e) => e.sets)
        .where((s) => s.completed)
        .fold(0.0, (sum, s) {
          final w = s.weight > 0 ? s.weight : bodyweight;
          return sum + (w * s.actualReps);
        });
  }
}
