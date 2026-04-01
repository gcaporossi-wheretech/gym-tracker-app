// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutSessionImpl _$$WorkoutSessionImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSessionImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      dayPlanId: json['dayPlanId'] as String,
      workoutName: json['workoutName'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExerciseLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      sessionRating: (json['sessionRating'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WorkoutSessionImplToJson(
  _$WorkoutSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'dayPlanId': instance.dayPlanId,
  'workoutName': instance.workoutName,
  'exercises': instance.exercises,
  'notes': instance.notes,
  'completed': instance.completed,
  'durationMinutes': instance.durationMinutes,
  'sessionRating': instance.sessionRating,
};
