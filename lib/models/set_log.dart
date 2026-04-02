import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_log.freezed.dart';
part 'set_log.g.dart';

@freezed
class SetLog with _$SetLog {
  const factory SetLog({
    required int setNumber,
    required int plannedReps,
    @Default(0) int actualReps,
    @Default(0) double weight,
    @Default(0) double rpe,
    @Default('') String notes,
    @Default(false) bool completed,
    @Default(0) int durationSeconds, // per esercizi a tempo (GYM-25)
  }) = _SetLog;

  factory SetLog.fromJson(Map<String, dynamic> json) => _$SetLogFromJson(json);
}
