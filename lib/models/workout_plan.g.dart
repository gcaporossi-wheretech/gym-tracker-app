// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutPlanImpl _$$WorkoutPlanImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutPlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      phases: (json['phases'] as List<dynamic>)
          .map((e) => Phase.fromJson(e as Map<String, dynamic>))
          .toList(),
      days: (json['days'] as List<dynamic>)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalWeeks: (json['totalWeeks'] as num?)?.toInt() ?? 12,
    );

Map<String, dynamic> _$$WorkoutPlanImplToJson(_$WorkoutPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'phases': instance.phases,
      'days': instance.days,
      'totalWeeks': instance.totalWeeks,
    };
