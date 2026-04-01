// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) {
  return _WorkoutSession.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSession {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get dayPlanId => throw _privateConstructorUsedError;
  String get workoutName => throw _privateConstructorUsedError;
  List<ExerciseLog> get exercises => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  int get sessionRating => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSessionCopyWith<WorkoutSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionCopyWith<$Res> {
  factory $WorkoutSessionCopyWith(
    WorkoutSession value,
    $Res Function(WorkoutSession) then,
  ) = _$WorkoutSessionCopyWithImpl<$Res, WorkoutSession>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    String dayPlanId,
    String workoutName,
    List<ExerciseLog> exercises,
    String notes,
    bool completed,
    int durationMinutes,
    int sessionRating,
  });
}

/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res, $Val extends WorkoutSession>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dayPlanId = null,
    Object? workoutName = null,
    Object? exercises = null,
    Object? notes = null,
    Object? completed = null,
    Object? durationMinutes = null,
    Object? sessionRating = null,
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
            dayPlanId: null == dayPlanId
                ? _value.dayPlanId
                : dayPlanId // ignore: cast_nullable_to_non_nullable
                      as String,
            workoutName: null == workoutName
                ? _value.workoutName
                : workoutName // ignore: cast_nullable_to_non_nullable
                      as String,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<ExerciseLog>,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionRating: null == sessionRating
                ? _value.sessionRating
                : sessionRating // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutSessionImplCopyWith<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  factory _$$WorkoutSessionImplCopyWith(
    _$WorkoutSessionImpl value,
    $Res Function(_$WorkoutSessionImpl) then,
  ) = __$$WorkoutSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    String dayPlanId,
    String workoutName,
    List<ExerciseLog> exercises,
    String notes,
    bool completed,
    int durationMinutes,
    int sessionRating,
  });
}

/// @nodoc
class __$$WorkoutSessionImplCopyWithImpl<$Res>
    extends _$WorkoutSessionCopyWithImpl<$Res, _$WorkoutSessionImpl>
    implements _$$WorkoutSessionImplCopyWith<$Res> {
  __$$WorkoutSessionImplCopyWithImpl(
    _$WorkoutSessionImpl _value,
    $Res Function(_$WorkoutSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? dayPlanId = null,
    Object? workoutName = null,
    Object? exercises = null,
    Object? notes = null,
    Object? completed = null,
    Object? durationMinutes = null,
    Object? sessionRating = null,
  }) {
    return _then(
      _$WorkoutSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dayPlanId: null == dayPlanId
            ? _value.dayPlanId
            : dayPlanId // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutName: null == workoutName
            ? _value.workoutName
            : workoutName // ignore: cast_nullable_to_non_nullable
                  as String,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<ExerciseLog>,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionRating: null == sessionRating
            ? _value.sessionRating
            : sessionRating // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSessionImpl extends _WorkoutSession {
  const _$WorkoutSessionImpl({
    required this.id,
    required this.date,
    required this.dayPlanId,
    required this.workoutName,
    required final List<ExerciseLog> exercises,
    this.notes = '',
    this.completed = false,
    this.durationMinutes = 0,
    this.sessionRating = 0,
  }) : _exercises = exercises,
       super._();

  factory _$WorkoutSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSessionImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String dayPlanId;
  @override
  final String workoutName;
  final List<ExerciseLog> _exercises;
  @override
  List<ExerciseLog> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final int durationMinutes;
  @override
  @JsonKey()
  final int sessionRating;

  @override
  String toString() {
    return 'WorkoutSession(id: $id, date: $date, dayPlanId: $dayPlanId, workoutName: $workoutName, exercises: $exercises, notes: $notes, completed: $completed, durationMinutes: $durationMinutes, sessionRating: $sessionRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dayPlanId, dayPlanId) ||
                other.dayPlanId == dayPlanId) &&
            (identical(other.workoutName, workoutName) ||
                other.workoutName == workoutName) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.sessionRating, sessionRating) ||
                other.sessionRating == sessionRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    dayPlanId,
    workoutName,
    const DeepCollectionEquality().hash(_exercises),
    notes,
    completed,
    durationMinutes,
    sessionRating,
  );

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      __$$WorkoutSessionImplCopyWithImpl<_$WorkoutSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSessionImplToJson(this);
  }
}

abstract class _WorkoutSession extends WorkoutSession {
  const factory _WorkoutSession({
    required final String id,
    required final DateTime date,
    required final String dayPlanId,
    required final String workoutName,
    required final List<ExerciseLog> exercises,
    final String notes,
    final bool completed,
    final int durationMinutes,
    final int sessionRating,
  }) = _$WorkoutSessionImpl;
  const _WorkoutSession._() : super._();

  factory _WorkoutSession.fromJson(Map<String, dynamic> json) =
      _$WorkoutSessionImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get dayPlanId;
  @override
  String get workoutName;
  @override
  List<ExerciseLog> get exercises;
  @override
  String get notes;
  @override
  bool get completed;
  @override
  int get durationMinutes;
  @override
  int get sessionRating;

  /// Create a copy of WorkoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
