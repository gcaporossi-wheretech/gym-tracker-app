// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutPlan _$WorkoutPlanFromJson(Map<String, dynamic> json) {
  return _WorkoutPlan.fromJson(json);
}

/// @nodoc
mixin _$WorkoutPlan {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  List<Phase> get phases => throw _privateConstructorUsedError;
  List<DayPlan> get days => throw _privateConstructorUsedError;
  int get totalWeeks => throw _privateConstructorUsedError;

  /// Serializes this WorkoutPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutPlanCopyWith<WorkoutPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutPlanCopyWith<$Res> {
  factory $WorkoutPlanCopyWith(
    WorkoutPlan value,
    $Res Function(WorkoutPlan) then,
  ) = _$WorkoutPlanCopyWithImpl<$Res, WorkoutPlan>;
  @useResult
  $Res call({
    String id,
    String name,
    DateTime startDate,
    List<Phase> phases,
    List<DayPlan> days,
    int totalWeeks,
  });
}

/// @nodoc
class _$WorkoutPlanCopyWithImpl<$Res, $Val extends WorkoutPlan>
    implements $WorkoutPlanCopyWith<$Res> {
  _$WorkoutPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? phases = null,
    Object? days = null,
    Object? totalWeeks = null,
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
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            phases: null == phases
                ? _value.phases
                : phases // ignore: cast_nullable_to_non_nullable
                      as List<Phase>,
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as List<DayPlan>,
            totalWeeks: null == totalWeeks
                ? _value.totalWeeks
                : totalWeeks // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutPlanImplCopyWith<$Res>
    implements $WorkoutPlanCopyWith<$Res> {
  factory _$$WorkoutPlanImplCopyWith(
    _$WorkoutPlanImpl value,
    $Res Function(_$WorkoutPlanImpl) then,
  ) = __$$WorkoutPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    DateTime startDate,
    List<Phase> phases,
    List<DayPlan> days,
    int totalWeeks,
  });
}

/// @nodoc
class __$$WorkoutPlanImplCopyWithImpl<$Res>
    extends _$WorkoutPlanCopyWithImpl<$Res, _$WorkoutPlanImpl>
    implements _$$WorkoutPlanImplCopyWith<$Res> {
  __$$WorkoutPlanImplCopyWithImpl(
    _$WorkoutPlanImpl _value,
    $Res Function(_$WorkoutPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? startDate = null,
    Object? phases = null,
    Object? days = null,
    Object? totalWeeks = null,
  }) {
    return _then(
      _$WorkoutPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        phases: null == phases
            ? _value._phases
            : phases // ignore: cast_nullable_to_non_nullable
                  as List<Phase>,
        days: null == days
            ? _value._days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<DayPlan>,
        totalWeeks: null == totalWeeks
            ? _value.totalWeeks
            : totalWeeks // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutPlanImpl implements _WorkoutPlan {
  const _$WorkoutPlanImpl({
    required this.id,
    required this.name,
    required this.startDate,
    required final List<Phase> phases,
    required final List<DayPlan> days,
    this.totalWeeks = 12,
  }) : _phases = phases,
       _days = days;

  factory _$WorkoutPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime startDate;
  final List<Phase> _phases;
  @override
  List<Phase> get phases {
    if (_phases is EqualUnmodifiableListView) return _phases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phases);
  }

  final List<DayPlan> _days;
  @override
  List<DayPlan> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  @JsonKey()
  final int totalWeeks;

  @override
  String toString() {
    return 'WorkoutPlan(id: $id, name: $name, startDate: $startDate, phases: $phases, days: $days, totalWeeks: $totalWeeks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            const DeepCollectionEquality().equals(other._phases, _phases) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.totalWeeks, totalWeeks) ||
                other.totalWeeks == totalWeeks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    startDate,
    const DeepCollectionEquality().hash(_phases),
    const DeepCollectionEquality().hash(_days),
    totalWeeks,
  );

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutPlanImplCopyWith<_$WorkoutPlanImpl> get copyWith =>
      __$$WorkoutPlanImplCopyWithImpl<_$WorkoutPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutPlanImplToJson(this);
  }
}

abstract class _WorkoutPlan implements WorkoutPlan {
  const factory _WorkoutPlan({
    required final String id,
    required final String name,
    required final DateTime startDate,
    required final List<Phase> phases,
    required final List<DayPlan> days,
    final int totalWeeks,
  }) = _$WorkoutPlanImpl;

  factory _WorkoutPlan.fromJson(Map<String, dynamic> json) =
      _$WorkoutPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get startDate;
  @override
  List<Phase> get phases;
  @override
  List<DayPlan> get days;
  @override
  int get totalWeeks;

  /// Create a copy of WorkoutPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutPlanImplCopyWith<_$WorkoutPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
