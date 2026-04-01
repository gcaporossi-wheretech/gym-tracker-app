// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseLogImpl _$$ExerciseLogImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseLogImpl(
      exercisePlanId: json['exercisePlanId'] as String,
      exerciseName: json['exerciseName'] as String,
      muscleGroup: json['muscleGroup'] as String,
      sets: (json['sets'] as List<dynamic>)
          .map((e) => SetLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      skipped: json['skipped'] as bool? ?? false,
      substitutedFor: json['substitutedFor'] as String?,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$ExerciseLogImplToJson(_$ExerciseLogImpl instance) =>
    <String, dynamic>{
      'exercisePlanId': instance.exercisePlanId,
      'exerciseName': instance.exerciseName,
      'muscleGroup': instance.muscleGroup,
      'sets': instance.sets,
      'skipped': instance.skipped,
      'substitutedFor': instance.substitutedFor,
      'notes': instance.notes,
    };
