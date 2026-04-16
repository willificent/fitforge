// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutDay _$WorkoutDayFromJson(Map<String, dynamic> json) {
  return _WorkoutDay.fromJson(json);
}

/// @nodoc
mixin _$WorkoutDay {
  String get date => throw _privateConstructorUsedError;
  List<WorkoutExercise> get exercises => throw _privateConstructorUsedError;
  double get dayVolume => throw _privateConstructorUsedError;
  int get totalSets => throw _privateConstructorUsedError;

  /// Serializes this WorkoutDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutDayCopyWith<WorkoutDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutDayCopyWith<$Res> {
  factory $WorkoutDayCopyWith(
    WorkoutDay value,
    $Res Function(WorkoutDay) then,
  ) = _$WorkoutDayCopyWithImpl<$Res, WorkoutDay>;
  @useResult
  $Res call({
    String date,
    List<WorkoutExercise> exercises,
    double dayVolume,
    int totalSets,
  });
}

/// @nodoc
class _$WorkoutDayCopyWithImpl<$Res, $Val extends WorkoutDay>
    implements $WorkoutDayCopyWith<$Res> {
  _$WorkoutDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? exercises = null,
    Object? dayVolume = null,
    Object? totalSets = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<WorkoutExercise>,
            dayVolume: null == dayVolume
                ? _value.dayVolume
                : dayVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            totalSets: null == totalSets
                ? _value.totalSets
                : totalSets // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutDayImplCopyWith<$Res>
    implements $WorkoutDayCopyWith<$Res> {
  factory _$$WorkoutDayImplCopyWith(
    _$WorkoutDayImpl value,
    $Res Function(_$WorkoutDayImpl) then,
  ) = __$$WorkoutDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    List<WorkoutExercise> exercises,
    double dayVolume,
    int totalSets,
  });
}

/// @nodoc
class __$$WorkoutDayImplCopyWithImpl<$Res>
    extends _$WorkoutDayCopyWithImpl<$Res, _$WorkoutDayImpl>
    implements _$$WorkoutDayImplCopyWith<$Res> {
  __$$WorkoutDayImplCopyWithImpl(
    _$WorkoutDayImpl _value,
    $Res Function(_$WorkoutDayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? exercises = null,
    Object? dayVolume = null,
    Object? totalSets = null,
  }) {
    return _then(
      _$WorkoutDayImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<WorkoutExercise>,
        dayVolume: null == dayVolume
            ? _value.dayVolume
            : dayVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        totalSets: null == totalSets
            ? _value.totalSets
            : totalSets // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutDayImpl extends _WorkoutDay {
  const _$WorkoutDayImpl({
    required this.date,
    required final List<WorkoutExercise> exercises,
    required this.dayVolume,
    required this.totalSets,
  }) : _exercises = exercises,
       super._();

  factory _$WorkoutDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutDayImplFromJson(json);

  @override
  final String date;
  final List<WorkoutExercise> _exercises;
  @override
  List<WorkoutExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  final double dayVolume;
  @override
  final int totalSets;

  @override
  String toString() {
    return 'WorkoutDay(date: $date, exercises: $exercises, dayVolume: $dayVolume, totalSets: $totalSets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.dayVolume, dayVolume) ||
                other.dayVolume == dayVolume) &&
            (identical(other.totalSets, totalSets) ||
                other.totalSets == totalSets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    const DeepCollectionEquality().hash(_exercises),
    dayVolume,
    totalSets,
  );

  /// Create a copy of WorkoutDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutDayImplCopyWith<_$WorkoutDayImpl> get copyWith =>
      __$$WorkoutDayImplCopyWithImpl<_$WorkoutDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutDayImplToJson(this);
  }
}

abstract class _WorkoutDay extends WorkoutDay {
  const factory _WorkoutDay({
    required final String date,
    required final List<WorkoutExercise> exercises,
    required final double dayVolume,
    required final int totalSets,
  }) = _$WorkoutDayImpl;
  const _WorkoutDay._() : super._();

  factory _WorkoutDay.fromJson(Map<String, dynamic> json) =
      _$WorkoutDayImpl.fromJson;

  @override
  String get date;
  @override
  List<WorkoutExercise> get exercises;
  @override
  double get dayVolume;
  @override
  int get totalSets;

  /// Create a copy of WorkoutDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutDayImplCopyWith<_$WorkoutDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExercise _$WorkoutExerciseFromJson(Map<String, dynamic> json) {
  return _WorkoutExercise.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExercise {
  String get exerciseName => throw _privateConstructorUsedError;
  String get bodyPart => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  List<WorkoutSetRecord> get sets => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;
  double get estimatedOneRepMax => throw _privateConstructorUsedError;
  double get maxWeight => throw _privateConstructorUsedError;
  double get maxReps => throw _privateConstructorUsedError;
  bool get volumePR => throw _privateConstructorUsedError;
  bool get estimatedOneRepMaxPR => throw _privateConstructorUsedError;
  bool get harderThanLastTime => throw _privateConstructorUsedError;

  /// Serializes this WorkoutExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExerciseCopyWith<WorkoutExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseCopyWith<$Res> {
  factory $WorkoutExerciseCopyWith(
    WorkoutExercise value,
    $Res Function(WorkoutExercise) then,
  ) = _$WorkoutExerciseCopyWithImpl<$Res, WorkoutExercise>;
  @useResult
  $Res call({
    String exerciseName,
    String bodyPart,
    String date,
    List<WorkoutSetRecord> sets,
    double volume,
    double estimatedOneRepMax,
    double maxWeight,
    double maxReps,
    bool volumePR,
    bool estimatedOneRepMaxPR,
    bool harderThanLastTime,
  });
}

/// @nodoc
class _$WorkoutExerciseCopyWithImpl<$Res, $Val extends WorkoutExercise>
    implements $WorkoutExerciseCopyWith<$Res> {
  _$WorkoutExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseName = null,
    Object? bodyPart = null,
    Object? date = null,
    Object? sets = null,
    Object? volume = null,
    Object? estimatedOneRepMax = null,
    Object? maxWeight = null,
    Object? maxReps = null,
    Object? volumePR = null,
    Object? estimatedOneRepMaxPR = null,
    Object? harderThanLastTime = null,
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
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            sets: null == sets
                ? _value.sets
                : sets // ignore: cast_nullable_to_non_nullable
                      as List<WorkoutSetRecord>,
            volume: null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedOneRepMax: null == estimatedOneRepMax
                ? _value.estimatedOneRepMax
                : estimatedOneRepMax // ignore: cast_nullable_to_non_nullable
                      as double,
            maxWeight: null == maxWeight
                ? _value.maxWeight
                : maxWeight // ignore: cast_nullable_to_non_nullable
                      as double,
            maxReps: null == maxReps
                ? _value.maxReps
                : maxReps // ignore: cast_nullable_to_non_nullable
                      as double,
            volumePR: null == volumePR
                ? _value.volumePR
                : volumePR // ignore: cast_nullable_to_non_nullable
                      as bool,
            estimatedOneRepMaxPR: null == estimatedOneRepMaxPR
                ? _value.estimatedOneRepMaxPR
                : estimatedOneRepMaxPR // ignore: cast_nullable_to_non_nullable
                      as bool,
            harderThanLastTime: null == harderThanLastTime
                ? _value.harderThanLastTime
                : harderThanLastTime // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutExerciseImplCopyWith<$Res>
    implements $WorkoutExerciseCopyWith<$Res> {
  factory _$$WorkoutExerciseImplCopyWith(
    _$WorkoutExerciseImpl value,
    $Res Function(_$WorkoutExerciseImpl) then,
  ) = __$$WorkoutExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String exerciseName,
    String bodyPart,
    String date,
    List<WorkoutSetRecord> sets,
    double volume,
    double estimatedOneRepMax,
    double maxWeight,
    double maxReps,
    bool volumePR,
    bool estimatedOneRepMaxPR,
    bool harderThanLastTime,
  });
}

/// @nodoc
class __$$WorkoutExerciseImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseCopyWithImpl<$Res, _$WorkoutExerciseImpl>
    implements _$$WorkoutExerciseImplCopyWith<$Res> {
  __$$WorkoutExerciseImplCopyWithImpl(
    _$WorkoutExerciseImpl _value,
    $Res Function(_$WorkoutExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseName = null,
    Object? bodyPart = null,
    Object? date = null,
    Object? sets = null,
    Object? volume = null,
    Object? estimatedOneRepMax = null,
    Object? maxWeight = null,
    Object? maxReps = null,
    Object? volumePR = null,
    Object? estimatedOneRepMaxPR = null,
    Object? harderThanLastTime = null,
  }) {
    return _then(
      _$WorkoutExerciseImpl(
        exerciseName: null == exerciseName
            ? _value.exerciseName
            : exerciseName // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyPart: null == bodyPart
            ? _value.bodyPart
            : bodyPart // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        sets: null == sets
            ? _value._sets
            : sets // ignore: cast_nullable_to_non_nullable
                  as List<WorkoutSetRecord>,
        volume: null == volume
            ? _value.volume
            : volume // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedOneRepMax: null == estimatedOneRepMax
            ? _value.estimatedOneRepMax
            : estimatedOneRepMax // ignore: cast_nullable_to_non_nullable
                  as double,
        maxWeight: null == maxWeight
            ? _value.maxWeight
            : maxWeight // ignore: cast_nullable_to_non_nullable
                  as double,
        maxReps: null == maxReps
            ? _value.maxReps
            : maxReps // ignore: cast_nullable_to_non_nullable
                  as double,
        volumePR: null == volumePR
            ? _value.volumePR
            : volumePR // ignore: cast_nullable_to_non_nullable
                  as bool,
        estimatedOneRepMaxPR: null == estimatedOneRepMaxPR
            ? _value.estimatedOneRepMaxPR
            : estimatedOneRepMaxPR // ignore: cast_nullable_to_non_nullable
                  as bool,
        harderThanLastTime: null == harderThanLastTime
            ? _value.harderThanLastTime
            : harderThanLastTime // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExerciseImpl extends _WorkoutExercise {
  const _$WorkoutExerciseImpl({
    required this.exerciseName,
    required this.bodyPart,
    required this.date,
    required final List<WorkoutSetRecord> sets,
    required this.volume,
    required this.estimatedOneRepMax,
    required this.maxWeight,
    required this.maxReps,
    required this.volumePR,
    required this.estimatedOneRepMaxPR,
    required this.harderThanLastTime,
  }) : _sets = sets,
       super._();

  factory _$WorkoutExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseImplFromJson(json);

  @override
  final String exerciseName;
  @override
  final String bodyPart;
  @override
  final String date;
  final List<WorkoutSetRecord> _sets;
  @override
  List<WorkoutSetRecord> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  final double volume;
  @override
  final double estimatedOneRepMax;
  @override
  final double maxWeight;
  @override
  final double maxReps;
  @override
  final bool volumePR;
  @override
  final bool estimatedOneRepMaxPR;
  @override
  final bool harderThanLastTime;

  @override
  String toString() {
    return 'WorkoutExercise(exerciseName: $exerciseName, bodyPart: $bodyPart, date: $date, sets: $sets, volume: $volume, estimatedOneRepMax: $estimatedOneRepMax, maxWeight: $maxWeight, maxReps: $maxReps, volumePR: $volumePR, estimatedOneRepMaxPR: $estimatedOneRepMaxPR, harderThanLastTime: $harderThanLastTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseImpl &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.bodyPart, bodyPart) ||
                other.bodyPart == bodyPart) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.estimatedOneRepMax, estimatedOneRepMax) ||
                other.estimatedOneRepMax == estimatedOneRepMax) &&
            (identical(other.maxWeight, maxWeight) ||
                other.maxWeight == maxWeight) &&
            (identical(other.maxReps, maxReps) || other.maxReps == maxReps) &&
            (identical(other.volumePR, volumePR) ||
                other.volumePR == volumePR) &&
            (identical(other.estimatedOneRepMaxPR, estimatedOneRepMaxPR) ||
                other.estimatedOneRepMaxPR == estimatedOneRepMaxPR) &&
            (identical(other.harderThanLastTime, harderThanLastTime) ||
                other.harderThanLastTime == harderThanLastTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    exerciseName,
    bodyPart,
    date,
    const DeepCollectionEquality().hash(_sets),
    volume,
    estimatedOneRepMax,
    maxWeight,
    maxReps,
    volumePR,
    estimatedOneRepMaxPR,
    harderThanLastTime,
  );

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      __$$WorkoutExerciseImplCopyWithImpl<_$WorkoutExerciseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseImplToJson(this);
  }
}

abstract class _WorkoutExercise extends WorkoutExercise {
  const factory _WorkoutExercise({
    required final String exerciseName,
    required final String bodyPart,
    required final String date,
    required final List<WorkoutSetRecord> sets,
    required final double volume,
    required final double estimatedOneRepMax,
    required final double maxWeight,
    required final double maxReps,
    required final bool volumePR,
    required final bool estimatedOneRepMaxPR,
    required final bool harderThanLastTime,
  }) = _$WorkoutExerciseImpl;
  const _WorkoutExercise._() : super._();

  factory _WorkoutExercise.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseImpl.fromJson;

  @override
  String get exerciseName;
  @override
  String get bodyPart;
  @override
  String get date;
  @override
  List<WorkoutSetRecord> get sets;
  @override
  double get volume;
  @override
  double get estimatedOneRepMax;
  @override
  double get maxWeight;
  @override
  double get maxReps;
  @override
  bool get volumePR;
  @override
  bool get estimatedOneRepMaxPR;
  @override
  bool get harderThanLastTime;

  /// Create a copy of WorkoutExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExerciseImplCopyWith<_$WorkoutExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutSetRecord _$WorkoutSetRecordFromJson(Map<String, dynamic> json) {
  return _WorkoutSetRecord.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSetRecord {
  int get id => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get exerciseName => throw _privateConstructorUsedError;
  String get bodyPart => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double get reps => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  int? get restSeconds => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  double? get targetReps => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSetRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSetRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSetRecordCopyWith<WorkoutSetRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSetRecordCopyWith<$Res> {
  factory $WorkoutSetRecordCopyWith(
    WorkoutSetRecord value,
    $Res Function(WorkoutSetRecord) then,
  ) = _$WorkoutSetRecordCopyWithImpl<$Res, WorkoutSetRecord>;
  @useResult
  $Res call({
    int id,
    String date,
    String exerciseName,
    String bodyPart,
    double weight,
    double reps,
    String? comment,
    int? restSeconds,
    double? targetWeight,
    double? targetReps,
  });
}

/// @nodoc
class _$WorkoutSetRecordCopyWithImpl<$Res, $Val extends WorkoutSetRecord>
    implements $WorkoutSetRecordCopyWith<$Res> {
  _$WorkoutSetRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSetRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? exerciseName = null,
    Object? bodyPart = null,
    Object? weight = null,
    Object? reps = null,
    Object? comment = freezed,
    Object? restSeconds = freezed,
    Object? targetWeight = freezed,
    Object? targetReps = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            exerciseName: null == exerciseName
                ? _value.exerciseName
                : exerciseName // ignore: cast_nullable_to_non_nullable
                      as String,
            bodyPart: null == bodyPart
                ? _value.bodyPart
                : bodyPart // ignore: cast_nullable_to_non_nullable
                      as String,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            reps: null == reps
                ? _value.reps
                : reps // ignore: cast_nullable_to_non_nullable
                      as double,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            restSeconds: freezed == restSeconds
                ? _value.restSeconds
                : restSeconds // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetWeight: freezed == targetWeight
                ? _value.targetWeight
                : targetWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            targetReps: freezed == targetReps
                ? _value.targetReps
                : targetReps // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutSetRecordImplCopyWith<$Res>
    implements $WorkoutSetRecordCopyWith<$Res> {
  factory _$$WorkoutSetRecordImplCopyWith(
    _$WorkoutSetRecordImpl value,
    $Res Function(_$WorkoutSetRecordImpl) then,
  ) = __$$WorkoutSetRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String date,
    String exerciseName,
    String bodyPart,
    double weight,
    double reps,
    String? comment,
    int? restSeconds,
    double? targetWeight,
    double? targetReps,
  });
}

/// @nodoc
class __$$WorkoutSetRecordImplCopyWithImpl<$Res>
    extends _$WorkoutSetRecordCopyWithImpl<$Res, _$WorkoutSetRecordImpl>
    implements _$$WorkoutSetRecordImplCopyWith<$Res> {
  __$$WorkoutSetRecordImplCopyWithImpl(
    _$WorkoutSetRecordImpl _value,
    $Res Function(_$WorkoutSetRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSetRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? exerciseName = null,
    Object? bodyPart = null,
    Object? weight = null,
    Object? reps = null,
    Object? comment = freezed,
    Object? restSeconds = freezed,
    Object? targetWeight = freezed,
    Object? targetReps = freezed,
  }) {
    return _then(
      _$WorkoutSetRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        exerciseName: null == exerciseName
            ? _value.exerciseName
            : exerciseName // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyPart: null == bodyPart
            ? _value.bodyPart
            : bodyPart // ignore: cast_nullable_to_non_nullable
                  as String,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        reps: null == reps
            ? _value.reps
            : reps // ignore: cast_nullable_to_non_nullable
                  as double,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        restSeconds: freezed == restSeconds
            ? _value.restSeconds
            : restSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetWeight: freezed == targetWeight
            ? _value.targetWeight
            : targetWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        targetReps: freezed == targetReps
            ? _value.targetReps
            : targetReps // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSetRecordImpl extends _WorkoutSetRecord {
  const _$WorkoutSetRecordImpl({
    required this.id,
    required this.date,
    required this.exerciseName,
    required this.bodyPart,
    required this.weight,
    required this.reps,
    this.comment,
    this.restSeconds,
    this.targetWeight,
    this.targetReps,
  }) : super._();

  factory _$WorkoutSetRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSetRecordImplFromJson(json);

  @override
  final int id;
  @override
  final String date;
  @override
  final String exerciseName;
  @override
  final String bodyPart;
  @override
  final double weight;
  @override
  final double reps;
  @override
  final String? comment;
  @override
  final int? restSeconds;
  @override
  final double? targetWeight;
  @override
  final double? targetReps;

  @override
  String toString() {
    return 'WorkoutSetRecord(id: $id, date: $date, exerciseName: $exerciseName, bodyPart: $bodyPart, weight: $weight, reps: $reps, comment: $comment, restSeconds: $restSeconds, targetWeight: $targetWeight, targetReps: $targetReps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSetRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.bodyPart, bodyPart) ||
                other.bodyPart == bodyPart) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    exerciseName,
    bodyPart,
    weight,
    reps,
    comment,
    restSeconds,
    targetWeight,
    targetReps,
  );

  /// Create a copy of WorkoutSetRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSetRecordImplCopyWith<_$WorkoutSetRecordImpl> get copyWith =>
      __$$WorkoutSetRecordImplCopyWithImpl<_$WorkoutSetRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSetRecordImplToJson(this);
  }
}

abstract class _WorkoutSetRecord extends WorkoutSetRecord {
  const factory _WorkoutSetRecord({
    required final int id,
    required final String date,
    required final String exerciseName,
    required final String bodyPart,
    required final double weight,
    required final double reps,
    final String? comment,
    final int? restSeconds,
    final double? targetWeight,
    final double? targetReps,
  }) = _$WorkoutSetRecordImpl;
  const _WorkoutSetRecord._() : super._();

  factory _WorkoutSetRecord.fromJson(Map<String, dynamic> json) =
      _$WorkoutSetRecordImpl.fromJson;

  @override
  int get id;
  @override
  String get date;
  @override
  String get exerciseName;
  @override
  String get bodyPart;
  @override
  double get weight;
  @override
  double get reps;
  @override
  String? get comment;
  @override
  int? get restSeconds;
  @override
  double? get targetWeight;
  @override
  double? get targetReps;

  /// Create a copy of WorkoutSetRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSetRecordImplCopyWith<_$WorkoutSetRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
