// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) {
  return _DayPlan.fromJson(json);
}

/// @nodoc
mixin _$DayPlan {
  String get id => throw _privateConstructorUsedError;
  int get dayOfWeek => throw _privateConstructorUsedError; // 1=Monday, 5=Friday
  String get name =>
      throw _privateConstructorUsedError; // es. "Petto + Tricipiti"
  List<String> get warmup => throw _privateConstructorUsedError;
  List<ExercisePlan> get exercises => throw _privateConstructorUsedError;
  bool get hasCardio => throw _privateConstructorUsedError;
  String get cardioDescription => throw _privateConstructorUsedError;

  /// Serializes this DayPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayPlanCopyWith<DayPlan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayPlanCopyWith<$Res> {
  factory $DayPlanCopyWith(DayPlan value, $Res Function(DayPlan) then) =
      _$DayPlanCopyWithImpl<$Res, DayPlan>;
  @useResult
  $Res call({
    String id,
    int dayOfWeek,
    String name,
    List<String> warmup,
    List<ExercisePlan> exercises,
    bool hasCardio,
    String cardioDescription,
  });
}

/// @nodoc
class _$DayPlanCopyWithImpl<$Res, $Val extends DayPlan>
    implements $DayPlanCopyWith<$Res> {
  _$DayPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? name = null,
    Object? warmup = null,
    Object? exercises = null,
    Object? hasCardio = null,
    Object? cardioDescription = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            warmup: null == warmup
                ? _value.warmup
                : warmup // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<ExercisePlan>,
            hasCardio: null == hasCardio
                ? _value.hasCardio
                : hasCardio // ignore: cast_nullable_to_non_nullable
                      as bool,
            cardioDescription: null == cardioDescription
                ? _value.cardioDescription
                : cardioDescription // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayPlanImplCopyWith<$Res> implements $DayPlanCopyWith<$Res> {
  factory _$$DayPlanImplCopyWith(
    _$DayPlanImpl value,
    $Res Function(_$DayPlanImpl) then,
  ) = __$$DayPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int dayOfWeek,
    String name,
    List<String> warmup,
    List<ExercisePlan> exercises,
    bool hasCardio,
    String cardioDescription,
  });
}

/// @nodoc
class __$$DayPlanImplCopyWithImpl<$Res>
    extends _$DayPlanCopyWithImpl<$Res, _$DayPlanImpl>
    implements _$$DayPlanImplCopyWith<$Res> {
  __$$DayPlanImplCopyWithImpl(
    _$DayPlanImpl _value,
    $Res Function(_$DayPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? name = null,
    Object? warmup = null,
    Object? exercises = null,
    Object? hasCardio = null,
    Object? cardioDescription = null,
  }) {
    return _then(
      _$DayPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        warmup: null == warmup
            ? _value._warmup
            : warmup // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<ExercisePlan>,
        hasCardio: null == hasCardio
            ? _value.hasCardio
            : hasCardio // ignore: cast_nullable_to_non_nullable
                  as bool,
        cardioDescription: null == cardioDescription
            ? _value.cardioDescription
            : cardioDescription // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DayPlanImpl implements _DayPlan {
  const _$DayPlanImpl({
    required this.id,
    required this.dayOfWeek,
    required this.name,
    final List<String> warmup = const [],
    required final List<ExercisePlan> exercises,
    this.hasCardio = true,
    this.cardioDescription = '',
  }) : _warmup = warmup,
       _exercises = exercises;

  factory _$DayPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayPlanImplFromJson(json);

  @override
  final String id;
  @override
  final int dayOfWeek;
  // 1=Monday, 5=Friday
  @override
  final String name;
  // es. "Petto + Tricipiti"
  final List<String> _warmup;
  // es. "Petto + Tricipiti"
  @override
  @JsonKey()
  List<String> get warmup {
    if (_warmup is EqualUnmodifiableListView) return _warmup;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warmup);
  }

  final List<ExercisePlan> _exercises;
  @override
  List<ExercisePlan> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  @JsonKey()
  final bool hasCardio;
  @override
  @JsonKey()
  final String cardioDescription;

  @override
  String toString() {
    return 'DayPlan(id: $id, dayOfWeek: $dayOfWeek, name: $name, warmup: $warmup, exercises: $exercises, hasCardio: $hasCardio, cardioDescription: $cardioDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._warmup, _warmup) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.hasCardio, hasCardio) ||
                other.hasCardio == hasCardio) &&
            (identical(other.cardioDescription, cardioDescription) ||
                other.cardioDescription == cardioDescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dayOfWeek,
    name,
    const DeepCollectionEquality().hash(_warmup),
    const DeepCollectionEquality().hash(_exercises),
    hasCardio,
    cardioDescription,
  );

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      __$$DayPlanImplCopyWithImpl<_$DayPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayPlanImplToJson(this);
  }
}

abstract class _DayPlan implements DayPlan {
  const factory _DayPlan({
    required final String id,
    required final int dayOfWeek,
    required final String name,
    final List<String> warmup,
    required final List<ExercisePlan> exercises,
    final bool hasCardio,
    final String cardioDescription,
  }) = _$DayPlanImpl;

  factory _DayPlan.fromJson(Map<String, dynamic> json) = _$DayPlanImpl.fromJson;

  @override
  String get id;
  @override
  int get dayOfWeek; // 1=Monday, 5=Friday
  @override
  String get name; // es. "Petto + Tricipiti"
  @override
  List<String> get warmup;
  @override
  List<ExercisePlan> get exercises;
  @override
  bool get hasCardio;
  @override
  String get cardioDescription;

  /// Create a copy of DayPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayPlanImplCopyWith<_$DayPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
