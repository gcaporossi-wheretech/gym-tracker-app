import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_measurement.freezed.dart';
part 'body_measurement.g.dart';

@freezed
class BodyMeasurement with _$BodyMeasurement {
  const factory BodyMeasurement({
    required String id,
    required DateTime date,
    @Default(0) double weight, // kg
    @Default(0) double chest, // petto cm
    @Default(0) double waist, // vita/addominali cm
    @Default(0) double hips, // fianchi cm
    @Default(0) double shoulders, // spalle cm
    @Default(0) double bicepLeft, // bicipite sx cm
    @Default(0) double bicepRight, // bicipite dx cm
    @Default(0) double thighLeft, // coscia sx cm
    @Default(0) double thighRight, // coscia dx cm
    @Default(0) double calfLeft, // polpaccio sx cm
    @Default(0) double calfRight, // polpaccio dx cm
    @Default('') String notes,
  }) = _BodyMeasurement;

  factory BodyMeasurement.fromJson(Map<String, dynamic> json) =>
      _$BodyMeasurementFromJson(json);
}
