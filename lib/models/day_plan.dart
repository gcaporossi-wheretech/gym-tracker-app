import 'package:freezed_annotation/freezed_annotation.dart';

import 'exercise_plan.dart';

part 'day_plan.freezed.dart';
part 'day_plan.g.dart';

@freezed
class DayPlan with _$DayPlan {
  const factory DayPlan({
    required String id,
    required int dayOfWeek, // 1=Monday, 5=Friday
    required String name, // es. "Petto + Tricipiti"
    @Default([]) List<String> warmup,
    required List<ExercisePlan> exercises,
    @Default(true) bool hasCardio,
    @Default('') String cardioDescription,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, dynamic> json) =>
      _$DayPlanFromJson(json);
}
