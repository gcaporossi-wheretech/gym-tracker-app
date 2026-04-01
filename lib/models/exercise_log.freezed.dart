// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExerciseLog _$ExerciseLogFromJson(Map<String, dynamic> json) {
  return _ExerciseLog.fromJson(json);
}

/// @nodoc
mixin _$ExerciseLog {
  String get exercisePlanId => throw _privateConstructorUsedError;
  String get exerciseName => throw _privateConstructorUsedError;
  String get muscleGroup => throw _privateConstructorUsedError;
  List<SetLog> get sets => throw _privateConstructorUsedError;
  bool get skipped => throw _privateConstructorUsedError;
  String? get substitutedFor =>
      throw _privateConstructorUsedError; // nome esercizio originale se sostituito
  String get notes => throw _privateConstructorUsedError;

  /// Serializes this ExerciseLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseLogCopyWith<ExerciseLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseLogCopyWith<$Res> {
  factory $ExerciseLogCopyWith(
    ExerciseLog value,
    $Res Function(ExerciseLog) then,
  ) = _$ExerciseLogCopyWithImpl<$Res, ExerciseLog>;
  @useResult
  $Res call({
    String exercisePlanId,
    String exerciseName,
    String muscleGroup,
    List<SetLog> sets,
    bool skipped,
    String? substitutedFor,
    String notes,
  });
}

/// @nodoc
class _$ExerciseLogCopyWithImpl<$Res, $Val extends ExerciseLog>
    implements $ExerciseLogCopyWith<$Res> {
  _$ExerciseLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercisePlanId = null,
    Object? exerciseName = null,
    Object? muscleGroup = null,
    Object? sets = null,
    Object? skipped = null,
    Object? substitutedFor = freezed,
    Object? notes = null,
  }) {
    return _then(
      _value.copyWith(
            exercisePlanId: null == exercisePlanId
                ? _value.exercisePlanId
                : exercisePlanId // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseName: null == exerciseName
                ? _value.exerciseName
                : exerciseName // ignore: cast_nullable_to_non_nullable
                      as String,
            muscleGroup: null == muscleGroup
                ? _value.muscleGroup
                : muscleGroup // ignore: cast_nullable_to_non_nullable
                      as String,
            sets: null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                      as List<SetLog>,
            skipped: null == skipped
                ? _value.skipped
                : skipped // ignore: cast_nullable_to_non_nullable
                      as bool,
            substitutedFor: freezed == substitutedFor
                ? _value.substitutedFor
                : substitutedFor // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$ExerciseLogImplCopyWith<$Res>
    implements $ExerciseLogCopyWith<$Res> {
  factory _$$ExerciseLogImplCopyWith(
    _$ExerciseLogImpl value,
    $Res Function(_$ExerciseLogImpl) then,
  ) = __$$ExerciseLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String exercisePlanId,
    String exerciseName,
    String muscleGroup,
    List<SetLog> sets,
    bool skipped,
    String? substitutedFor,
    String notes,
  });
}

/// @nodoc
class __$$ExerciseLogImplCopyWithImpl<$Res>
    extends _$ExerciseLogCopyWithImpl<$Res, _$ExerciseLogImpl>
    implements _$$ExerciseLogImplCopyWith<$Res> {
  __$$ExerciseLogImplCopyWithImpl(
    _$ExerciseLogImpl _value,
    $Res Function(_$ExerciseLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercisePlanId = null,
    Object? exerciseName = null,
    Object? muscleGroup = null,
    Object? sets = null,
    Object? skipped = null,
    Object? substitutedFor = freezed,
    Object? notes = null,
  }) {
    return _then(
      _$ExerciseLogImpl(
        exercisePlanId: null == exercisePlanId
            ? _value.exercisePlanId
            : exercisePlanId // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseName: null == exerciseName
            ? _value.exerciseName
            : exerciseName // ignore: cast_nullable_to_non_nullable
                  as String,
        muscleGroup: null == muscleGroup
            ? _value.muscleGroup
            : muscleGroup // ignore: cast_nullable_to_non_nullable
                  as String,
        sets: null == sets
            ? _value._sets
            : sets // ignore: cast_nullable_to_non_nullable
                  as List<SetLog>,
        skipped: null == skipped
            ? _value.skipped
            : skipped // ignore: cast_nullable_to_non_nullable
                  as bool,
        substitutedFor: freezed == substitutedFor
            ? _value.substitutedFor
            : substitutedFor // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$ExerciseLogImpl implements _ExerciseLog {
  const _$ExerciseLogImpl({
    required this.exercisePlanId,
    required this.exerciseName,
    required this.muscleGroup,
    required final List<SetLog> sets,
    this.skipped = false,
    this.substitutedFor,
    this.notes = '',
  }) : _sets = sets;

  factory _$ExerciseLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseLogImplFromJson(json);

  @override
  final String exercisePlanId;
  @override
  final String exerciseName;
  @override
  final String muscleGroup;
  final List<SetLog> _sets;
  @override
  List<SetLog> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  @JsonKey()
  final bool skipped;
  @override
  final String? substitutedFor;
  // nome esercizio originale se sostituito
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'ExerciseLog(exercisePlanId: $exercisePlanId, exerciseName: $exerciseName, muscleGroup: $muscleGroup, sets: $sets, skipped: $skipped, substitutedFor: $substitutedFor, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseLogImpl &&
            (identical(other.exercisePlanId, exercisePlanId) ||
                other.exercisePlanId == exercisePlanId) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.skipped, skipped) || other.skipped == skipped) &&
            (identical(other.substitutedFor, substitutedFor) ||
                other.substitutedFor == substitutedFor) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    exercisePlanId,
    exerciseName,
    muscleGroup,
    const DeepCollectionEquality().hash(_sets),
    skipped,
    substitutedFor,
    notes,
  );

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseLogImplCopyWith<_$ExerciseLogImpl> get copyWith =>
      __$$ExerciseLogImplCopyWithImpl<_$ExerciseLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseLogImplToJson(this);
  }
}

abstract class _ExerciseLog implements ExerciseLog {
  const factory _ExerciseLog({
    required final String exercisePlanId,
    required final String exerciseName,
    required final String muscleGroup,
    required final List<SetLog> sets,
    final bool skipped,
    final String? substitutedFor,
    final String notes,
  }) = _$ExerciseLogImpl;

  factory _ExerciseLog.fromJson(Map<String, dynamic> json) =
      _$ExerciseLogImpl.fromJson;

  @override
  String get exercisePlanId;
  @override
  String get exerciseName;
  @override
  String get muscleGroup;
  @override
  List<SetLog> get sets;
  @override
  bool get skipped;
  @override
  String? get substitutedFor; // nome esercizio originale se sostituito
  @override
  String get notes;

  /// Create a copy of ExerciseLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseLogImplCopyWith<_$ExerciseLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
