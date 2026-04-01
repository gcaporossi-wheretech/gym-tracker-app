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
}
