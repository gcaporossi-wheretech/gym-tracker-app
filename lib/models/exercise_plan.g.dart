// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExercisePlanImpl _$$ExercisePlanImplFromJson(Map<String, dynamic> json) =>
    _$ExercisePlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      equipment: json['equipment'] as String,
      muscleGroup: json['muscleGroup'] as String,
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      suggestedWeight: (json['suggestedWeight'] as num?)?.toDouble() ?? 0,
      restSeconds: (json['restSeconds'] as num?)?.toInt() ?? 90,
      rpe: (json['rpe'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? '',
      exerciseType: json['exerciseType'] as String? ?? 'weighted',
    );

Map<String, dynamic> _$$ExercisePlanImplToJson(_$ExercisePlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'equipment': instance.equipment,
      'muscleGroup': instance.muscleGroup,
      'sets': instance.sets,
      'reps': instance.reps,
      'suggestedWeight': instance.suggestedWeight,
      'restSeconds': instance.restSeconds,
      'rpe': instance.rpe,
      'notes': instance.notes,
      'exerciseType': instance.exerciseType,
    };
