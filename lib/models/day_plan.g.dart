// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayPlanImpl _$$DayPlanImplFromJson(Map<String, dynamic> json) =>
    _$DayPlanImpl(
      id: json['id'] as String,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      name: json['name'] as String,
      warmup:
          (json['warmup'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExercisePlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasCardio: json['hasCardio'] as bool? ?? true,
      cardioDescription: json['cardioDescription'] as String? ?? '',
    );

Map<String, dynamic> _$$DayPlanImplToJson(_$DayPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayOfWeek': instance.dayOfWeek,
      'name': instance.name,
      'warmup': instance.warmup,
      'exercises': instance.exercises,
      'hasCardio': instance.hasCardio,
      'cardioDescription': instance.cardioDescription,
    };
