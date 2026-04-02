// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetLogImpl _$$SetLogImplFromJson(Map<String, dynamic> json) => _$SetLogImpl(
  setNumber: (json['setNumber'] as num).toInt(),
  plannedReps: (json['plannedReps'] as num).toInt(),
  actualReps: (json['actualReps'] as num?)?.toInt() ?? 0,
  weight: (json['weight'] as num?)?.toDouble() ?? 0,
  rpe: (json['rpe'] as num?)?.toDouble() ?? 0,
  notes: json['notes'] as String? ?? '',
  completed: json['completed'] as bool? ?? false,
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SetLogImplToJson(_$SetLogImpl instance) =>
    <String, dynamic>{
      'setNumber': instance.setNumber,
      'plannedReps': instance.plannedReps,
      'actualReps': instance.actualReps,
      'weight': instance.weight,
      'rpe': instance.rpe,
      'notes': instance.notes,
      'completed': instance.completed,
      'durationSeconds': instance.durationSeconds,
    };
