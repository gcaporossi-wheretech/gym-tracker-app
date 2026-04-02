// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExercisePlan _$ExercisePlanFromJson(Map<String, dynamic> json) {
  return _ExercisePlan.fromJson(json);
}

/// @nodoc
mixin _$ExercisePlan {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get equipment => throw _privateConstructorUsedError;
  String get muscleGroup => throw _privateConstructorUsedError;
  int get sets => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;
  double get suggestedWeight => throw _privateConstructorUsedError;
  int get restSeconds => throw _privateConstructorUsedError;
  double get rpe => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get exerciseType => throw _privateConstructorUsedError;

  /// Serializes this ExercisePlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExercisePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExercisePlanCopyWith<ExercisePlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExercisePlanCopyWith<$Res> {
  factory $ExercisePlanCopyWith(
    ExercisePlan value,
    $Res Function(ExercisePlan) then,
  ) = _$ExercisePlanCopyWithImpl<$Res, ExercisePlan>;
  @useResult
  $Res call({
    String id,
    String name,
    String equipment,
    String muscleGroup,
    int sets,
    int reps,
    double suggestedWeight,
    int restSeconds,
    double rpe,
    String notes,
    String exerciseType,
  });
}

/// @nodoc
class _$ExercisePlanCopyWithImpl<$Res, $Val extends ExercisePlan>
    implements $ExercisePlanCopyWith<$Res> {
  _$ExercisePlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExercisePlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? equipment = null,
    Object? muscleGroup = null,
    Object? sets = null,
    Object? reps = null,
    Object? suggestedWeight = null,
    Object? restSeconds = null,
    Object? rpe = null,
    Object? notes = null,
    Object? exerciseType = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            equipment: null == equipment
                ? _value.equipment
                : equipment // ignore: cast_nullable_to_non_nullable
                      as String,
            muscleGroup: null == muscleGroup
                ? _value.muscleGroup
                : muscleGroup // ignore: cast_nullable_to_non_nullable
                      as String,
            sets: null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                      as int,
            reps: null == reps
                ? _value.reps
                : reps // ignore: cast_nullable_to_non_nullable
                      as int,
            suggestedWeight: null == suggestedWeight
                ? _value.suggestedWeight
                : suggestedWeight // ignore: cast_nullable_to_non_nullable
                      as double,
            restSeconds: null == restSeconds
                ? _value.restSeconds
                : restSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            rpe: null == rpe
                ? _value.rpe
                : rpe // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseType: null == exerciseType
                ? _value.exerciseType
                : exerciseType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExercisePlanImplCopyWith<$Res>
    implements $ExercisePlanCopyWith<$Res> {
  factory _$$ExercisePlanImplCopyWith(
    _$ExercisePlanImpl value,
    $Res Function(_$ExercisePlanImpl) then,
  ) = __$$ExercisePlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String equipment,
    String muscleGroup,
    int sets,
    int reps,
    double suggestedWeight,
    int restSeconds,
    double rpe,
    String notes,
    String exerciseType,
  });
}

/// @nodoc
class __$$ExercisePlanImplCopyWithImpl<$Res>
    extends _$ExercisePlanCopyWithImpl<$Res, _$ExercisePlanImpl>
    implements _$$ExercisePlanImplCopyWith<$Res> {
  __$$ExercisePlanImplCopyWithImpl(
    _$ExercisePlanImpl _value,
    $Res Function(_$ExercisePlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExercisePlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? equipment = null,
    Object? muscleGroup = null,
    Object? sets = null,
    Object? reps = null,
    Object? suggestedWeight = null,
    Object? restSeconds = null,
    Object? rpe = null,
    Object? notes = null,
    Object? exerciseType = null,
  }) {
    return _then(
      _$ExercisePlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        equipment: null == equipment
            ? _value.equipment
            : equipment // ignore: cast_nullable_to_non_nullable
                  as String,
        muscleGroup: null == muscleGroup
            ? _value.muscleGroup
            : muscleGroup // ignore: cast_nullable_to_non_nullable
                  as String,
        sets: null == sets
            ? _value.sets
            : sets // ignore: cast_nullable_to_non_nullable
                  as int,
        reps: null == reps
            ? _value.reps
            : reps // ignore: cast_nullable_to_non_nullable
                  as int,
        suggestedWeight: null == suggestedWeight
            ? _value.suggestedWeight
            : suggestedWeight // ignore: cast_nullable_to_non_nullable
                  as double,
        restSeconds: null == restSeconds
            ? _value.restSeconds
            : restSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        rpe: null == rpe
            ? _value.rpe
            : rpe // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseType: null == exerciseType
            ? _value.exerciseType
            : exerciseType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExercisePlanImpl implements _ExercisePlan {
  const _$ExercisePlanImpl({
    required this.id,
    required this.name,
    required this.equipment,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    this.suggestedWeight = 0,
    this.restSeconds = 90,
    this.rpe = 0,
    this.notes = '',
    this.exerciseType = 'weighted',
  });

  factory _$ExercisePlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExercisePlanImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String equipment;
  @override
  final String muscleGroup;
  @override
  final int sets;
  @override
  final int reps;
  @override
  @JsonKey()
  final double suggestedWeight;
  @override
  @JsonKey()
  final int restSeconds;
  @override
  @JsonKey()
  final double rpe;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String exerciseType;

  @override
  String toString() {
    return 'ExercisePlan(id: $id, name: $name, equipment: $equipment, muscleGroup: $muscleGroup, sets: $sets, reps: $reps, suggestedWeight: $suggestedWeight, restSeconds: $restSeconds, rpe: $rpe, notes: $notes, exerciseType: $exerciseType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExercisePlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.suggestedWeight, suggestedWeight) ||
                other.suggestedWeight == suggestedWeight) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.rpe, rpe) || other.rpe == rpe) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.exerciseType, exerciseType) ||
                other.exerciseType == exerciseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    equipment,
    muscleGroup,
    sets,
    reps,
    suggestedWeight,
    restSeconds,
    rpe,
    notes,
    exerciseType,
  );

  /// Create a copy of ExercisePlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExercisePlanImplCopyWith<_$ExercisePlanImpl> get copyWith =>
      __$$ExercisePlanImplCopyWithImpl<_$ExercisePlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExercisePlanImplToJson(this);
  }
}

abstract class _ExercisePlan implements ExercisePlan {
  const factory _ExercisePlan({
    required final String id,
    required final String name,
    required final String equipment,
    required final String muscleGroup,
    required final int sets,
    required final int reps,
    final double suggestedWeight,
    final int restSeconds,
    final double rpe,
    final String notes,
    final String exerciseType,
  }) = _$ExercisePlanImpl;

  factory _ExercisePlan.fromJson(Map<String, dynamic> json) =
      _$ExercisePlanImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get equipment;
  @override
  String get muscleGroup;
  @override
  int get sets;
  @override
  int get reps;
  @override
  double get suggestedWeight;
  @override
  int get restSeconds;
  @override
  double get rpe;
  @override
  String get notes;
  @override
  String get exerciseType;

  /// Create a copy of ExercisePlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExercisePlanImplCopyWith<_$ExercisePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
