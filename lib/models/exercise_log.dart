import 'package:freezed_annotation/freezed_annotation.dart';

import 'set_log.dart';

part 'exercise_log.freezed.dart';
part 'exercise_log.g.dart';

@freezed
class ExerciseLog with _$ExerciseLog {
  const factory ExerciseLog({
    required String exercisePlanId,
    required String exerciseName,
    required String muscleGroup,
    required List<SetLog> sets,
    @Default(false) bool skipped,
    String? substitutedFor, // nome esercizio originale se sostituito
    @Default('') String notes,
  }) = _ExerciseLog;

  factory ExerciseLog.fromJson(Map<String, dynamic> json) =>
      _$ExerciseLogFromJson(json);
}
