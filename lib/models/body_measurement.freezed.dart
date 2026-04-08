// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BodyMeasurement _$BodyMeasurementFromJson(Map<String, dynamic> json) {
  return _BodyMeasurement.fromJson(json);
}

/// @nodoc
mixin _$BodyMeasurement {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError; // kg
  double get chest => throw _privateConstructorUsedError; // petto cm
  double get waist => throw _privateConstructorUsedError; // vita/addominali cm
  double get hips => throw _privateConstructorUsedError; // fianchi cm
  double get shoulders => throw _privateConstructorUsedError; // spalle cm
  double get bicepLeft => throw _privateConstructorUsedError; // bicipite sx cm
  double get bicepRight => throw _privateConstructorUsedError; // bicipite dx cm
  double get thighLeft => throw _privateConstructorUsedError; // coscia sx cm
  double get thighRight => throw _privateConstructorUsedError; // coscia dx cm
  double get calfLeft => throw _privateConstructorUsedError; // polpaccio sx cm
  double get calfRight => throw _privateConstructorUsedError; // polpaccio dx cm
  String get notes => throw _privateConstructorUsedError;

  /// Serializes this BodyMeasurement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyMeasurementCopyWith<BodyMeasurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyMeasurementCopyWith<$Res> {
  factory $BodyMeasurementCopyWith(
    BodyMeasurement value,
    $Res Function(BodyMeasurement) then,
  ) = _$BodyMeasurementCopyWithImpl<$Res, BodyMeasurement>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    double weight,
    double chest,
    double waist,
    double hips,
    double shoulders,
    double bicepLeft,
    double bicepRight,
    double thighLeft,
    double thighRight,
    double calfLeft,
    double calfRight,
    String notes,
  });
}

/// @nodoc
class _$BodyMeasurementCopyWithImpl<$Res, $Val extends BodyMeasurement>
    implements $BodyMeasurementCopyWith<$Res> {
  _$BodyMeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? weight = null,
    Object? chest = null,
    Object? waist = null,
    Object? hips = null,
    Object? shoulders = null,
    Object? bicepLeft = null,
    Object? bicepRight = null,
    Object? thighLeft = null,
    Object? thighRight = null,
    Object? calfLeft = null,
    Object? calfRight = null,
    Object? notes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            chest: null == chest
                ? _value.chest
                : chest // ignore: cast_nullable_to_non_nullable
                      as double,
            waist: null == waist
                ? _value.waist
                : waist // ignore: cast_nullable_to_non_nullable
                      as double,
            hips: null == hips
                ? _value.hips
                : hips // ignore: cast_nullable_to_non_nullable
                      as double,
            shoulders: null == shoulders
                ? _value.shoulders
                : shoulders // ignore: cast_nullable_to_non_nullable
                      as double,
            bicepLeft: null == bicepLeft
                ? _value.bicepLeft
                : bicepLeft // ignore: cast_nullable_to_non_nullable
                      as double,
            bicepRight: null == bicepRight
                ? _value.bicepRight
                : bicepRight // ignore: cast_nullable_to_non_nullable
                      as double,
            thighLeft: null == thighLeft
                ? _value.thighLeft
                : thighLeft // ignore: cast_nullable_to_non_nullable
                      as double,
            thighRight: null == thighRight
                ? _value.thighRight
                : thighRight // ignore: cast_nullable_to_non_nullable
                      as double,
            calfLeft: null == calfLeft
                ? _value.calfLeft
                : calfLeft // ignore: cast_nullable_to_non_nullable
                      as double,
            calfRight: null == calfRight
                ? _value.calfRight
                : calfRight // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BodyMeasurementImplCopyWith<$Res>
    implements $BodyMeasurementCopyWith<$Res> {
  factory _$$BodyMeasurementImplCopyWith(
    _$BodyMeasurementImpl value,
    $Res Function(_$BodyMeasurementImpl) then,
  ) = __$$BodyMeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    double weight,
    double chest,
    double waist,
    double hips,
    double shoulders,
    double bicepLeft,
    double bicepRight,
    double thighLeft,
    double thighRight,
    double calfLeft,
    double calfRight,
    String notes,
  });
}

/// @nodoc
class __$$BodyMeasurementImplCopyWithImpl<$Res>
    extends _$BodyMeasurementCopyWithImpl<$Res, _$BodyMeasurementImpl>
    implements _$$BodyMeasurementImplCopyWith<$Res> {
  __$$BodyMeasurementImplCopyWithImpl(
    _$BodyMeasurementImpl _value,
    $Res Function(_$BodyMeasurementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? weight = null,
    Object? chest = null,
    Object? waist = null,
    Object? hips = null,
    Object? shoulders = null,
    Object? bicepLeft = null,
    Object? bicepRight = null,
    Object? thighLeft = null,
    Object? thighRight = null,
    Object? calfLeft = null,
    Object? calfRight = null,
    Object? notes = null,
  }) {
    return _then(
      _$BodyMeasurementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        chest: null == chest
            ? _value.chest
            : chest // ignore: cast_nullable_to_non_nullable
                  as double,
        waist: null == waist
            ? _value.waist
            : waist // ignore: cast_nullable_to_non_nullable
                  as double,
        hips: null == hips
            ? _value.hips
            : hips // ignore: cast_nullable_to_non_nullable
                  as double,
        shoulders: null == shoulders
            ? _value.shoulders
            : shoulders // ignore: cast_nullable_to_non_nullable
                  as double,
        bicepLeft: null == bicepLeft
            ? _value.bicepLeft
            : bicepLeft // ignore: cast_nullable_to_non_nullable
                  as double,
        bicepRight: null == bicepRight
            ? _value.bicepRight
            : bicepRight // ignore: cast_nullable_to_non_nullable
                  as double,
        thighLeft: null == thighLeft
            ? _value.thighLeft
            : thighLeft // ignore: cast_nullable_to_non_nullable
                  as double,
        thighRight: null == thighRight
            ? _value.thighRight
            : thighRight // ignore: cast_nullable_to_non_nullable
                  as double,
        calfLeft: null == calfLeft
            ? _value.calfLeft
            : calfLeft // ignore: cast_nullable_to_non_nullable
                  as double,
        calfRight: null == calfRight
            ? _value.calfRight
            : calfRight // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyMeasurementImpl implements _BodyMeasurement {
  const _$BodyMeasurementImpl({
    required this.id,
    required this.date,
    this.weight = 0,
    this.chest = 0,
    this.waist = 0,
    this.hips = 0,
    this.shoulders = 0,
    this.bicepLeft = 0,
    this.bicepRight = 0,
    this.thighLeft = 0,
    this.thighRight = 0,
    this.calfLeft = 0,
    this.calfRight = 0,
    this.notes = '',
  });

  factory _$BodyMeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyMeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final double weight;
  // kg
  @override
  @JsonKey()
  final double chest;
  // petto cm
  @override
  @JsonKey()
  final double waist;
  // vita/addominali cm
  @override
  @JsonKey()
  final double hips;
  // fianchi cm
  @override
  @JsonKey()
  final double shoulders;
  // spalle cm
  @override
  @JsonKey()
  final double bicepLeft;
  // bicipite sx cm
  @override
  @JsonKey()
  final double bicepRight;
  // bicipite dx cm
  @override
  @JsonKey()
  final double thighLeft;
  // coscia sx cm
  @override
  @JsonKey()
  final double thighRight;
  // coscia dx cm
  @override
  @JsonKey()
  final double calfLeft;
  // polpaccio sx cm
  @override
  @JsonKey()
  final double calfRight;
  // polpaccio dx cm
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'BodyMeasurement(id: $id, date: $date, weight: $weight, chest: $chest, waist: $waist, hips: $hips, shoulders: $shoulders, bicepLeft: $bicepLeft, bicepRight: $bicepRight, thighLeft: $thighLeft, thighRight: $thighRight, calfLeft: $calfLeft, calfRight: $calfRight, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyMeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.chest, chest) || other.chest == chest) &&
            (identical(other.waist, waist) || other.waist == waist) &&
            (identical(other.hips, hips) || other.hips == hips) &&
            (identical(other.shoulders, shoulders) ||
                other.shoulders == shoulders) &&
            (identical(other.bicepLeft, bicepLeft) ||
                other.bicepLeft == bicepLeft) &&
            (identical(other.bicepRight, bicepRight) ||
                other.bicepRight == bicepRight) &&
            (identical(other.thighLeft, thighLeft) ||
                other.thighLeft == thighLeft) &&
            (identical(other.thighRight, thighRight) ||
                other.thighRight == thighRight) &&
            (identical(other.calfLeft, calfLeft) ||
                other.calfLeft == calfLeft) &&
            (identical(other.calfRight, calfRight) ||
                other.calfRight == calfRight) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    weight,
    chest,
    waist,
    hips,
    shoulders,
    bicepLeft,
    bicepRight,
    thighLeft,
    thighRight,
    calfLeft,
    calfRight,
    notes,
  );

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyMeasurementImplCopyWith<_$BodyMeasurementImpl> get copyWith =>
      __$$BodyMeasurementImplCopyWithImpl<_$BodyMeasurementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyMeasurementImplToJson(this);
  }
}

abstract class _BodyMeasurement implements BodyMeasurement {
  const factory _BodyMeasurement({
    required final String id,
    required final DateTime date,
    final double weight,
    final double chest,
    final double waist,
    final double hips,
    final double shoulders,
    final double bicepLeft,
    final double bicepRight,
    final double thighLeft,
    final double thighRight,
    final double calfLeft,
    final double calfRight,
    final String notes,
  }) = _$BodyMeasurementImpl;

  factory _BodyMeasurement.fromJson(Map<String, dynamic> json) =
      _$BodyMeasurementImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  double get weight; // kg
  @override
  double get chest; // petto cm
  @override
  double get waist; // vita/addominali cm
  @override
  double get hips; // fianchi cm
  @override
  double get shoulders; // spalle cm
  @override
  double get bicepLeft; // bicipite sx cm
  @override
  double get bicepRight; // bicipite dx cm
  @override
  double get thighLeft; // coscia sx cm
  @override
  double get thighRight; // coscia dx cm
  @override
  double get calfLeft; // polpaccio sx cm
  @override
  double get calfRight; // polpaccio dx cm
  @override
  String get notes;

  /// Create a copy of BodyMeasurement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyMeasurementImplCopyWith<_$BodyMeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
