// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SetLog _$SetLogFromJson(Map<String, dynamic> json) {
  return _SetLog.fromJson(json);
}

/// @nodoc
mixin _$SetLog {
  int get setNumber => throw _privateConstructorUsedError;
  int get plannedReps => throw _privateConstructorUsedError;
  int get actualReps => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double get rpe => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;

  /// Serializes this SetLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetLogCopyWith<SetLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetLogCopyWith<$Res> {
  factory $SetLogCopyWith(SetLog value, $Res Function(SetLog) then) =
      _$SetLogCopyWithImpl<$Res, SetLog>;
  @useResult
  $Res call({
    int setNumber,
    int plannedReps,
    int actualReps,
    double weight,
    double rpe,
    String notes,
    bool completed,
    int durationSeconds,
  });
}

/// @nodoc
class _$SetLogCopyWithImpl<$Res, $Val extends SetLog>
    implements $SetLogCopyWith<$Res> {
  _$SetLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? plannedReps = null,
    Object? actualReps = null,
    Object? weight = null,
    Object? rpe = null,
    Object? notes = null,
    Object? completed = null,
    Object? durationSeconds = null,
  }) {
    return _then(
      _value.copyWith(
            setNumber: null == setNumber
                ? _value.setNumber
                : setNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            plannedReps: null == plannedReps
                ? _value.plannedReps
                : plannedReps // ignore: cast_nullable_to_non_nullable
                      as int,
            actualReps: null == actualReps
                ? _value.actualReps
                : actualReps // ignore: cast_nullable_to_non_nullable
                      as int,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            rpe: null == rpe
                ? _value.rpe
                : rpe // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SetLogImplCopyWith<$Res> implements $SetLogCopyWith<$Res> {
  factory _$$SetLogImplCopyWith(
    _$SetLogImpl value,
    $Res Function(_$SetLogImpl) then,
  ) = __$$SetLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int setNumber,
    int plannedReps,
    int actualReps,
    double weight,
    double rpe,
    String notes,
    bool completed,
    int durationSeconds,
  });
}

/// @nodoc
class __$$SetLogImplCopyWithImpl<$Res>
    extends _$SetLogCopyWithImpl<$Res, _$SetLogImpl>
    implements _$$SetLogImplCopyWith<$Res> {
  __$$SetLogImplCopyWithImpl(
    _$SetLogImpl _value,
    $Res Function(_$SetLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SetLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? plannedReps = null,
    Object? actualReps = null,
    Object? weight = null,
    Object? rpe = null,
    Object? notes = null,
    Object? completed = null,
    Object? durationSeconds = null,
  }) {
    return _then(
      _$SetLogImpl(
        setNumber: null == setNumber
            ? _value.setNumber
            : setNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        plannedReps: null == plannedReps
            ? _value.plannedReps
            : plannedReps // ignore: cast_nullable_to_non_nullable
                  as int,
        actualReps: null == actualReps
            ? _value.actualReps
            : actualReps // ignore: cast_nullable_to_non_nullable
                  as int,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        rpe: null == rpe
            ? _value.rpe
            : rpe // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SetLogImpl implements _SetLog {
  const _$SetLogImpl({
    required this.setNumber,
    required this.plannedReps,
    this.actualReps = 0,
    this.weight = 0,
    this.rpe = 0,
    this.notes = '',
    this.completed = false,
    this.durationSeconds = 0,
  });

  factory _$SetLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetLogImplFromJson(json);

  @override
  final int setNumber;
  @override
  final int plannedReps;
  @override
  @JsonKey()
  final int actualReps;
  @override
  @JsonKey()
  final double weight;
  @override
  @JsonKey()
  final double rpe;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final int durationSeconds;

  @override
  String toString() {
    return 'SetLog(setNumber: $setNumber, plannedReps: $plannedReps, actualReps: $actualReps, weight: $weight, rpe: $rpe, notes: $notes, completed: $completed, durationSeconds: $durationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetLogImpl &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.plannedReps, plannedReps) ||
                other.plannedReps == plannedReps) &&
            (identical(other.actualReps, actualReps) ||
                other.actualReps == actualReps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.rpe, rpe) || other.rpe == rpe) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    setNumber,
    plannedReps,
    actualReps,
    weight,
    rpe,
    notes,
    completed,
    durationSeconds,
  );

  /// Create a copy of SetLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetLogImplCopyWith<_$SetLogImpl> get copyWith =>
      __$$SetLogImplCopyWithImpl<_$SetLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetLogImplToJson(this);
  }
}

abstract class _SetLog implements SetLog {
  const factory _SetLog({
    required final int setNumber,
    required final int plannedReps,
    final int actualReps,
    final double weight,
    final double rpe,
    final String notes,
    final bool completed,
    final int durationSeconds,
  }) = _$SetLogImpl;

  factory _SetLog.fromJson(Map<String, dynamic> json) = _$SetLogImpl.fromJson;

  @override
  int get setNumber;
  @override
  int get plannedReps;
  @override
  int get actualReps;
  @override
  double get weight;
  @override
  double get rpe;
  @override
  String get notes;
  @override
  bool get completed;
  @override
  int get durationSeconds;

  /// Create a copy of SetLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetLogImplCopyWith<_$SetLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
