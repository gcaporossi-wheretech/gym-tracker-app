// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodyMeasurementImpl _$$BodyMeasurementImplFromJson(
  Map<String, dynamic> json,
) => _$BodyMeasurementImpl(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  weight: (json['weight'] as num?)?.toDouble() ?? 0,
  chest: (json['chest'] as num?)?.toDouble() ?? 0,
  waist: (json['waist'] as num?)?.toDouble() ?? 0,
  hips: (json['hips'] as num?)?.toDouble() ?? 0,
  shoulders: (json['shoulders'] as num?)?.toDouble() ?? 0,
  bicepLeft: (json['bicepLeft'] as num?)?.toDouble() ?? 0,
  bicepRight: (json['bicepRight'] as num?)?.toDouble() ?? 0,
  thighLeft: (json['thighLeft'] as num?)?.toDouble() ?? 0,
  thighRight: (json['thighRight'] as num?)?.toDouble() ?? 0,
  calfLeft: (json['calfLeft'] as num?)?.toDouble() ?? 0,
  calfRight: (json['calfRight'] as num?)?.toDouble() ?? 0,
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$$BodyMeasurementImplToJson(
  _$BodyMeasurementImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'weight': instance.weight,
  'chest': instance.chest,
  'waist': instance.waist,
  'hips': instance.hips,
  'shoulders': instance.shoulders,
  'bicepLeft': instance.bicepLeft,
  'bicepRight': instance.bicepRight,
  'thighLeft': instance.thighLeft,
  'thighRight': instance.thighRight,
  'calfLeft': instance.calfLeft,
  'calfRight': instance.calfRight,
  'notes': instance.notes,
};
