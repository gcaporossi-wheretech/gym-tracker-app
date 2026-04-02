import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_plan.freezed.dart';
part 'exercise_plan.g.dart';

@freezed
class ExercisePlan with _$ExercisePlan {
  const factory ExercisePlan({
    required String id,
    required String name,
    required String equipment,
    required String muscleGroup,
    required int sets,
    required int reps,
    @Default(0) double suggestedWeight,
    @Default(90) int restSeconds,
    @Default(0) double rpe,
    @Default('') String notes,
    @Default('weighted') String exerciseType, // weighted, timed, bodyweight
  }) = _ExercisePlan;

  factory ExercisePlan.fromJson(Map<String, dynamic> json) =>
      _$ExercisePlanFromJson(json);
}
