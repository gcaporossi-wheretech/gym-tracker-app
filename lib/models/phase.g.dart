// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhaseImpl _$$PhaseImplFromJson(Map<String, dynamic> json) => _$PhaseImpl(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  weekStart: (json['weekStart'] as num).toInt(),
  weekEnd: (json['weekEnd'] as num).toInt(),
  description: json['description'] as String? ?? '',
  deloadWeek: (json['deloadWeek'] as num?)?.toInt() ?? 4,
);

Map<String, dynamic> _$$PhaseImplToJson(_$PhaseImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'weekStart': instance.weekStart,
      'weekEnd': instance.weekEnd,
      'description': instance.description,
      'deloadWeek': instance.deloadWeek,
    };
