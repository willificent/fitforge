// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_personal_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExercisePersonalStats _$ExercisePersonalStatsFromJson(
  Map<String, dynamic> json,
) {
  return _ExercisePersonalStats.fromJson(json);
}

/// @nodoc
mixin _$ExercisePersonalStats {
  String get exerciseName => throw _privateConstructorUsedError;
  String get bodyPart => throw _privateConstructorUsedError;
  double get maxVolume => throw _privateConstructorUsedError;
  double get maxWeight => throw _privateConstructorUsedError;
  double get maxReps => throw _privateConstructorUsedError;
  double get estimatedOneRepMax => throw _privateConstructorUsedError;
  double get actualOneRepMax => throw _privateConstructorUsedError;
  DateTime? get maxVolumeDate => throw _privateConstructorUsedError;
  DateTime? get maxWeightDate => throw _privateConstructorUsedError;
  DateTime? get estimatedOneRepMaxDate => throw _privateConstructorUsedError;
  double get averageSetsPerWeek => throw _privateConstructorUsedError;
  int get totalWorkouts => throw _privateConstructorUsedError;

  /// Serializes this ExercisePersonalStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExercisePersonalStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExercisePersonalStatsCopyWith<ExercisePersonalStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExercisePersonalStatsCopyWith<$Res> {
  factory $ExercisePersonalStatsCopyWith(
    ExercisePersonalStats value,
    $Res Function(ExercisePersonalStats) then,
  ) = _$ExercisePersonalStatsCopyWithImpl<$Res, ExercisePersonalStats>;
  @useResult
  $Res call({
    String exerciseName,
    String bodyPart,
    double maxVolume,
    double maxWeight,
    double maxReps,
    double estimatedOneRepMax,
    double actualOneRepMax,
    DateTime? maxVolumeDate,
    DateTime? maxWeightDate,
    DateTime? estimatedOneRepMaxDate,
    double averageSetsPerWeek,
    int totalWorkouts,
  });
}

/// @nodoc
class _$ExercisePersonalStatsCopyWithImpl<
  $Res,
  $Val extends ExercisePersonalStats
>
    implements $ExercisePersonalStatsCopyWith<$Res> {
  _$ExercisePersonalStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExercisePersonalStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseName = null,
    Object? bodyPart = null,
    Object? maxVolume = null,
    Object? maxWeight = null,
    Object? maxReps = null,
    Object? estimatedOneRepMax = null,
    Object? actualOneRepMax = null,
    Object? maxVolumeDate = freezed,
    Object? maxWeightDate = freezed,
    Object? estimatedOneRepMaxDate = freezed,
    Object? averageSetsPerWeek = null,
    Object? totalWorkouts = null,
  }) {
    return _then(
      _value.copyWith(
            exerciseName: null == exerciseName
                ? _value.exerciseName
                : exerciseName // ignore: cast_nullable_to_non_nullable
                      as String,
            bodyPart: null == bodyPart
                ? _value.bodyPart
                : bodyPart // ignore: cast_nullable_to_non_nullable
                      as String,
            maxVolume: null == maxVolume
                ? _value.maxVolume
                : maxVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            maxWeight: null == maxWeight
                ? _value.maxWeight
                : maxWeight // ignore: cast_nullable_to_non_nullable
                      as double,
            maxReps: null == maxReps
                ? _value.maxReps
                : maxReps // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedOneRepMax: null == estimatedOneRepMax
                ? _value.estimatedOneRepMax
                : estimatedOneRepMax // ignore: cast_nullable_to_non_nullable
                      as double,
            actualOneRepMax: null == actualOneRepMax
                ? _value.actualOneRepMax
                : actualOneRepMax // ignore: cast_nullable_to_non_nullable
                      as double,
            maxVolumeDate: freezed == maxVolumeDate
                ? _value.maxVolumeDate
                : maxVolumeDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            maxWeightDate: freezed == maxWeightDate
                ? _value.maxWeightDate
                : maxWeightDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            estimatedOneRepMaxDate: freezed == estimatedOneRepMaxDate
                ? _value.estimatedOneRepMaxDate
                : estimatedOneRepMaxDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            averageSetsPerWeek: null == averageSetsPerWeek
                ? _value.averageSetsPerWeek
                : averageSetsPerWeek // ignore: cast_nullable_to_non_nullable
                      as double,
            totalWorkouts: null == totalWorkouts
                ? _value.totalWorkouts
                : totalWorkouts // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExercisePersonalStatsImplCopyWith<$Res>
    implements $ExercisePersonalStatsCopyWith<$Res> {
  factory _$$ExercisePersonalStatsImplCopyWith(
    _$ExercisePersonalStatsImpl value,
    $Res Function(_$ExercisePersonalStatsImpl) then,
  ) = __$$ExercisePersonalStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String exerciseName,
    String bodyPart,
    double maxVolume,
    double maxWeight,
    double maxReps,
    double estimatedOneRepMax,
    double actualOneRepMax,
    DateTime? maxVolumeDate,
    DateTime? maxWeightDate,
    DateTime? estimatedOneRepMaxDate,
    double averageSetsPerWeek,
    int totalWorkouts,
  });
}

/// @nodoc
class __$$ExercisePersonalStatsImplCopyWithImpl<$Res>
    extends
        _$ExercisePersonalStatsCopyWithImpl<$Res, _$ExercisePersonalStatsImpl>
    implements _$$ExercisePersonalStatsImplCopyWith<$Res> {
  __$$ExercisePersonalStatsImplCopyWithImpl(
    _$ExercisePersonalStatsImpl _value,
    $Res Function(_$ExercisePersonalStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExercisePersonalStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseName = null,
    Object? bodyPart = null,
    Object? maxVolume = null,
    Object? maxWeight = null,
    Object? maxReps = null,
    Object? estimatedOneRepMax = null,
    Object? actualOneRepMax = null,
    Object? maxVolumeDate = freezed,
    Object? maxWeightDate = freezed,
    Object? estimatedOneRepMaxDate = freezed,
    Object? averageSetsPerWeek = null,
    Object? totalWorkouts = null,
  }) {
    return _then(
      _$ExercisePersonalStatsImpl(
        exerciseName: null == exerciseName
            ? _value.exerciseName
            : exerciseName // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyPart: null == bodyPart
            ? _value.bodyPart
            : bodyPart // ignore: cast_nullable_to_non_nullable
                  as String,
        maxVolume: null == maxVolume
            ? _value.maxVolume
            : maxVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        maxWeight: null == maxWeight
            ? _value.maxWeight
            : maxWeight // ignore: cast_nullable_to_non_nullable
                  as double,
        maxReps: null == maxReps
            ? _value.maxReps
            : maxReps // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedOneRepMax: null == estimatedOneRepMax
            ? _value.estimatedOneRepMax
            : estimatedOneRepMax // ignore: cast_nullable_to_non_nullable
                  as double,
        actualOneRepMax: null == actualOneRepMax
            ? _value.actualOneRepMax
            : actualOneRepMax // ignore: cast_nullable_to_non_nullable
                  as double,
        maxVolumeDate: freezed == maxVolumeDate
            ? _value.maxVolumeDate
            : maxVolumeDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        maxWeightDate: freezed == maxWeightDate
            ? _value.maxWeightDate
            : maxWeightDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        estimatedOneRepMaxDate: freezed == estimatedOneRepMaxDate
            ? _value.estimatedOneRepMaxDate
            : estimatedOneRepMaxDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        averageSetsPerWeek: null == averageSetsPerWeek
            ? _value.averageSetsPerWeek
            : averageSetsPerWeek // ignore: cast_nullable_to_non_nullable
                  as double,
        totalWorkouts: null == totalWorkouts
            ? _value.totalWorkouts
            : totalWorkouts // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExercisePersonalStatsImpl extends _ExercisePersonalStats {
  const _$ExercisePersonalStatsImpl({
    required this.exerciseName,
    required this.bodyPart,
    required this.maxVolume,
    required this.maxWeight,
    required this.maxReps,
    required this.estimatedOneRepMax,
    required this.actualOneRepMax,
    required this.maxVolumeDate,
    required this.maxWeightDate,
    required this.estimatedOneRepMaxDate,
    required this.averageSetsPerWeek,
    required this.totalWorkouts,
  }) : super._();

  factory _$ExercisePersonalStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExercisePersonalStatsImplFromJson(json);

  @override
  final String exerciseName;
  @override
  final String bodyPart;
  @override
  final double maxVolume;
  @override
  final double maxWeight;
  @override
  final double maxReps;
  @override
  final double estimatedOneRepMax;
  @override
  final double actualOneRepMax;
  @override
  final DateTime? maxVolumeDate;
  @override
  final DateTime? maxWeightDate;
  @override
  final DateTime? estimatedOneRepMaxDate;
  @override
  final double averageSetsPerWeek;
  @override
  final int totalWorkouts;

  @override
  String toString() {
    return 'ExercisePersonalStats(exerciseName: $exerciseName, bodyPart: $bodyPart, maxVolume: $maxVolume, maxWeight: $maxWeight, maxReps: $maxReps, estimatedOneRepMax: $estimatedOneRepMax, actualOneRepMax: $actualOneRepMax, maxVolumeDate: $maxVolumeDate, maxWeightDate: $maxWeightDate, estimatedOneRepMaxDate: $estimatedOneRepMaxDate, averageSetsPerWeek: $averageSetsPerWeek, totalWorkouts: $totalWorkouts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExercisePersonalStatsImpl &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.bodyPart, bodyPart) ||
                other.bodyPart == bodyPart) &&
            (identical(other.maxVolume, maxVolume) ||
                other.maxVolume == maxVolume) &&
            (identical(other.maxWeight, maxWeight) ||
                other.maxWeight == maxWeight) &&
            (identical(other.maxReps, maxReps) || other.maxReps == maxReps) &&
            (identical(other.estimatedOneRepMax, estimatedOneRepMax) ||
                other.estimatedOneRepMax == estimatedOneRepMax) &&
            (identical(other.actualOneRepMax, actualOneRepMax) ||
                other.actualOneRepMax == actualOneRepMax) &&
            (identical(other.maxVolumeDate, maxVolumeDate) ||
                other.maxVolumeDate == maxVolumeDate) &&
            (identical(other.maxWeightDate, maxWeightDate) ||
                other.maxWeightDate == maxWeightDate) &&
            (identical(other.estimatedOneRepMaxDate, estimatedOneRepMaxDate) ||
                other.estimatedOneRepMaxDate == estimatedOneRepMaxDate) &&
            (identical(other.averageSetsPerWeek, averageSetsPerWeek) ||
                other.averageSetsPerWeek == averageSetsPerWeek) &&
            (identical(other.totalWorkouts, totalWorkouts) ||
                other.totalWorkouts == totalWorkouts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    exerciseName,
    bodyPart,
    maxVolume,
    maxWeight,
    maxReps,
    estimatedOneRepMax,
    actualOneRepMax,
    maxVolumeDate,
    maxWeightDate,
    estimatedOneRepMaxDate,
    averageSetsPerWeek,
    totalWorkouts,
  );

  /// Create a copy of ExercisePersonalStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExercisePersonalStatsImplCopyWith<_$ExercisePersonalStatsImpl>
  get copyWith =>
      __$$ExercisePersonalStatsImplCopyWithImpl<_$ExercisePersonalStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExercisePersonalStatsImplToJson(this);
  }
}

abstract class _ExercisePersonalStats extends ExercisePersonalStats {
  const factory _ExercisePersonalStats({
    required final String exerciseName,
    required final String bodyPart,
    required final double maxVolume,
    required final double maxWeight,
    required final double maxReps,
    required final double estimatedOneRepMax,
    required final double actualOneRepMax,
    required final DateTime? maxVolumeDate,
    required final DateTime? maxWeightDate,
    required final DateTime? estimatedOneRepMaxDate,
    required final double averageSetsPerWeek,
    required final int totalWorkouts,
  }) = _$ExercisePersonalStatsImpl;
  const _ExercisePersonalStats._() : super._();

  factory _ExercisePersonalStats.fromJson(Map<String, dynamic> json) =
      _$ExercisePersonalStatsImpl.fromJson;

  @override
  String get exerciseName;
  @override
  String get bodyPart;
  @override
  double get maxVolume;
  @override
  double get maxWeight;
  @override
  double get maxReps;
  @override
  double get estimatedOneRepMax;
  @override
  double get actualOneRepMax;
  @override
  DateTime? get maxVolumeDate;
  @override
  DateTime? get maxWeightDate;
  @override
  DateTime? get estimatedOneRepMaxDate;
  @override
  double get averageSetsPerWeek;
  @override
  int get totalWorkouts;

  /// Create a copy of ExercisePersonalStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExercisePersonalStatsImplCopyWith<_$ExercisePersonalStatsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
