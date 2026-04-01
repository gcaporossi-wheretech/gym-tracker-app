// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Phase _$PhaseFromJson(Map<String, dynamic> json) {
  return _Phase.fromJson(json);
}

/// @nodoc
mixin _$Phase {
  int get number => throw _privateConstructorUsedError; // 1, 2, 3
  String get name =>
      throw _privateConstructorUsedError; // es. "Costruire le Fondamenta"
  int get weekStart => throw _privateConstructorUsedError; // 1, 5, 9
  int get weekEnd => throw _privateConstructorUsedError; // 4, 8, 12
  String get description => throw _privateConstructorUsedError;
  int get deloadWeek => throw _privateConstructorUsedError;

  /// Serializes this Phase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhaseCopyWith<Phase> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhaseCopyWith<$Res> {
  factory $PhaseCopyWith(Phase value, $Res Function(Phase) then) =
      _$PhaseCopyWithImpl<$Res, Phase>;
  @useResult
  $Res call({
    int number,
    String name,
    int weekStart,
    int weekEnd,
    String description,
    int deloadWeek,
  });
}

/// @nodoc
class _$PhaseCopyWithImpl<$Res, $Val extends Phase>
    implements $PhaseCopyWith<$Res> {
  _$PhaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? name = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? description = null,
    Object? deloadWeek = null,
  }) {
    return _then(
      _value.copyWith(
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            weekStart: null == weekStart
                ? _value.weekStart
                : weekStart // ignore: cast_nullable_to_non_nullable
                      as int,
            weekEnd: null == weekEnd
                ? _value.weekEnd
                : weekEnd // ignore: cast_nullable_to_non_nullable
                      as int,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            deloadWeek: null == deloadWeek
                ? _value.deloadWeek
                : deloadWeek // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhaseImplCopyWith<$Res> implements $PhaseCopyWith<$Res> {
  factory _$$PhaseImplCopyWith(
    _$PhaseImpl value,
    $Res Function(_$PhaseImpl) then,
  ) = __$$PhaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int number,
    String name,
    int weekStart,
    int weekEnd,
    String description,
    int deloadWeek,
  });
}

/// @nodoc
class __$$PhaseImplCopyWithImpl<$Res>
    extends _$PhaseCopyWithImpl<$Res, _$PhaseImpl>
    implements _$$PhaseImplCopyWith<$Res> {
  __$$PhaseImplCopyWithImpl(
    _$PhaseImpl _value,
    $Res Function(_$PhaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? name = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? description = null,
    Object? deloadWeek = null,
  }) {
    return _then(
      _$PhaseImpl(
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        weekStart: null == weekStart
            ? _value.weekStart
            : weekStart // ignore: cast_nullable_to_non_nullable
                  as int,
        weekEnd: null == weekEnd
            ? _value.weekEnd
            : weekEnd // ignore: cast_nullable_to_non_nullable
                  as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        deloadWeek: null == deloadWeek
            ? _value.deloadWeek
            : deloadWeek // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhaseImpl implements _Phase {
  const _$PhaseImpl({
    required this.number,
    required this.name,
    required this.weekStart,
    required this.weekEnd,
    this.description = '',
    this.deloadWeek = 4,
  });

  factory _$PhaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhaseImplFromJson(json);

  @override
  final int number;
  // 1, 2, 3
  @override
  final String name;
  // es. "Costruire le Fondamenta"
  @override
  final int weekStart;
  // 1, 5, 9
  @override
  final int weekEnd;
  // 4, 8, 12
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int deloadWeek;

  @override
  String toString() {
    return 'Phase(number: $number, name: $name, weekStart: $weekStart, weekEnd: $weekEnd, description: $description, deloadWeek: $deloadWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhaseImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deloadWeek, deloadWeek) ||
                other.deloadWeek == deloadWeek));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    number,
    name,
    weekStart,
    weekEnd,
    description,
    deloadWeek,
  );

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhaseImplCopyWith<_$PhaseImpl> get copyWith =>
      __$$PhaseImplCopyWithImpl<_$PhaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhaseImplToJson(this);
  }
}

abstract class _Phase implements Phase {
  const factory _Phase({
    required final int number,
    required final String name,
    required final int weekStart,
    required final int weekEnd,
    final String description,
    final int deloadWeek,
  }) = _$PhaseImpl;

  factory _Phase.fromJson(Map<String, dynamic> json) = _$PhaseImpl.fromJson;

  @override
  int get number; // 1, 2, 3
  @override
  String get name; // es. "Costruire le Fondamenta"
  @override
  int get weekStart; // 1, 5, 9
  @override
  int get weekEnd; // 4, 8, 12
  @override
  String get description;
  @override
  int get deloadWeek;

  /// Create a copy of Phase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhaseImplCopyWith<_$PhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
