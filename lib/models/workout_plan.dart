import 'package:freezed_annotation/freezed_annotation.dart';

import 'day_plan.dart';
import 'phase.dart';

part 'workout_plan.freezed.dart';
part 'workout_plan.g.dart';

@freezed
class WorkoutPlan with _$WorkoutPlan {
  const factory WorkoutPlan({
    required String id,
    required String name,
    required DateTime startDate,
    required List<Phase> phases,
    required List<DayPlan> days,
    @Default(12) int totalWeeks,
  }) = _WorkoutPlan;

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanFromJson(json);
}
