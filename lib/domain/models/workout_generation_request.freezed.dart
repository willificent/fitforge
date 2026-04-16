// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_generation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkoutGenerationRequest _$WorkoutGenerationRequestFromJson(
  Map<String, dynamic> json,
) {
  return _WorkoutGenerationRequest.fromJson(json);
}

/// @nodoc
mixin _$WorkoutGenerationRequest {
  WorkoutType get workoutType => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  List<MuscleGroup>? get targetMuscles => throw _privateConstructorUsedError;

  /// Serializes this WorkoutGenerationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutGenerationRequestCopyWith<WorkoutGenerationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutGenerationRequestCopyWith<$Res> {
  factory $WorkoutGenerationRequestCopyWith(
    WorkoutGenerationRequest value,
    $Res Function(WorkoutGenerationRequest) then,
  ) = _$WorkoutGenerationRequestCopyWithImpl<$Res, WorkoutGenerationRequest>;
  @useResult
  $Res call({
    WorkoutType workoutType,
    int duration,
    DifficultyLevel difficulty,
    List<MuscleGroup>? targetMuscles,
  });
}

/// @nodoc
class _$WorkoutGenerationRequestCopyWithImpl<
  $Res,
  $Val extends WorkoutGenerationRequest
>
    implements $WorkoutGenerationRequestCopyWith<$Res> {
  _$WorkoutGenerationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutType = null,
    Object? duration = null,
    Object? difficulty = null,
    Object? targetMuscles = freezed,
  }) {
    return _then(
      _value.copyWith(
            workoutType: null == workoutType
                ? _value.workoutType
                : workoutType // ignore: cast_nullable_to_non_nullable
                      as WorkoutType,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as DifficultyLevel,
            targetMuscles: freezed == targetMuscles
                ? _value.targetMuscles
                : targetMuscles // ignore: cast_nullable_to_non_nullable
                      as List<MuscleGroup>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutGenerationRequestImplCopyWith<$Res>
    implements $WorkoutGenerationRequestCopyWith<$Res> {
  factory _$$WorkoutGenerationRequestImplCopyWith(
    _$WorkoutGenerationRequestImpl value,
    $Res Function(_$WorkoutGenerationRequestImpl) then,
  ) = __$$WorkoutGenerationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WorkoutType workoutType,
    int duration,
    DifficultyLevel difficulty,
    List<MuscleGroup>? targetMuscles,
  });
}

/// @nodoc
class __$$WorkoutGenerationRequestImplCopyWithImpl<$Res>
    extends
        _$WorkoutGenerationRequestCopyWithImpl<
          $Res,
          _$WorkoutGenerationRequestImpl
        >
    implements _$$WorkoutGenerationRequestImplCopyWith<$Res> {
  __$$WorkoutGenerationRequestImplCopyWithImpl(
    _$WorkoutGenerationRequestImpl _value,
    $Res Function(_$WorkoutGenerationRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutType = null,
    Object? duration = null,
    Object? difficulty = null,
    Object? targetMuscles = freezed,
  }) {
    return _then(
      _$WorkoutGenerationRequestImpl(
        workoutType: null == workoutType
            ? _value.workoutType
            : workoutType // ignore: cast_nullable_to_non_nullable
                  as WorkoutType,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as DifficultyLevel,
        targetMuscles: freezed == targetMuscles
            ? _value._targetMuscles
            : targetMuscles // ignore: cast_nullable_to_non_nullable
                  as List<MuscleGroup>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutGenerationRequestImpl extends _WorkoutGenerationRequest {
  const _$WorkoutGenerationRequestImpl({
    required this.workoutType,
    required this.duration,
    required this.difficulty,
    final List<MuscleGroup>? targetMuscles,
  }) : _targetMuscles = targetMuscles,
       super._();

  factory _$WorkoutGenerationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutGenerationRequestImplFromJson(json);

  @override
  final WorkoutType workoutType;
  @override
  final int duration;
  @override
  final DifficultyLevel difficulty;
  final List<MuscleGroup>? _targetMuscles;
  @override
  List<MuscleGroup>? get targetMuscles {
    final value = _targetMuscles;
    if (value == null) return null;
    if (_targetMuscles is EqualUnmodifiableListView) return _targetMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WorkoutGenerationRequest(workoutType: $workoutType, duration: $duration, difficulty: $difficulty, targetMuscles: $targetMuscles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutGenerationRequestImpl &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._targetMuscles,
              _targetMuscles,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    workoutType,
    duration,
    difficulty,
    const DeepCollectionEquality().hash(_targetMuscles),
  );

  /// Create a copy of WorkoutGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutGenerationRequestImplCopyWith<_$WorkoutGenerationRequestImpl>
  get copyWith =>
      __$$WorkoutGenerationRequestImplCopyWithImpl<
        _$WorkoutGenerationRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutGenerationRequestImplToJson(this);
  }
}

abstract class _WorkoutGenerationRequest extends WorkoutGenerationRequest {
  const factory _WorkoutGenerationRequest({
    required final WorkoutType workoutType,
    required final int duration,
    required final DifficultyLevel difficulty,
    final List<MuscleGroup>? targetMuscles,
  }) = _$WorkoutGenerationRequestImpl;
  const _WorkoutGenerationRequest._() : super._();

  factory _WorkoutGenerationRequest.fromJson(Map<String, dynamic> json) =
      _$WorkoutGenerationRequestImpl.fromJson;

  @override
  WorkoutType get workoutType;
  @override
  int get duration;
  @override
  DifficultyLevel get difficulty;
  @override
  List<MuscleGroup>? get targetMuscles;

  /// Create a copy of WorkoutGenerationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutGenerationRequestImplCopyWith<_$WorkoutGenerationRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

GeneratedExercise _$GeneratedExerciseFromJson(Map<String, dynamic> json) {
  return _GeneratedExercise.fromJson(json);
}

/// @nodoc
mixin _$GeneratedExercise {
  String get name => throw _privateConstructorUsedError;
  MuscleGroup get muscleGroup => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  int get defaultSets => throw _privateConstructorUsedError;
  List<int> get defaultReps => throw _privateConstructorUsedError;
  int get defaultRestSeconds => throw _privateConstructorUsedError;
  String? get equipment => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  int? get targetReps => throw _privateConstructorUsedError;

  /// Serializes this GeneratedExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneratedExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneratedExerciseCopyWith<GeneratedExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratedExerciseCopyWith<$Res> {
  factory $GeneratedExerciseCopyWith(
    GeneratedExercise value,
    $Res Function(GeneratedExercise) then,
  ) = _$GeneratedExerciseCopyWithImpl<$Res, GeneratedExercise>;
  @useResult
  $Res call({
    String name,
    MuscleGroup muscleGroup,
    DifficultyLevel difficulty,
    int defaultSets,
    List<int> defaultReps,
    int defaultRestSeconds,
    String? equipment,
    String? instructions,
    double? targetWeight,
    int? targetReps,
  });
}

/// @nodoc
class _$GeneratedExerciseCopyWithImpl<$Res, $Val extends GeneratedExercise>
    implements $GeneratedExerciseCopyWith<$Res> {
  _$GeneratedExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneratedExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? muscleGroup = null,
    Object? difficulty = null,
    Object? defaultSets = null,
    Object? defaultReps = null,
    Object? defaultRestSeconds = null,
    Object? equipment = freezed,
    Object? instructions = freezed,
    Object? targetWeight = freezed,
    Object? targetReps = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            muscleGroup: null == muscleGroup
                ? _value.muscleGroup
                : muscleGroup // ignore: cast_nullable_to_non_nullable
                      as MuscleGroup,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as DifficultyLevel,
            defaultSets: null == defaultSets
                ? _value.defaultSets
                : defaultSets // ignore: cast_nullable_to_non_nullable
                      as int,
            defaultReps: null == defaultReps
                ? _value.defaultReps
                : defaultReps // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            defaultRestSeconds: null == defaultRestSeconds
                ? _value.defaultRestSeconds
                : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            equipment: freezed == equipment
                ? _value.equipment
                : equipment // ignore: cast_nullable_to_non_nullable
                      as String?,
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetWeight: freezed == targetWeight
                ? _value.targetWeight
                : targetWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            targetReps: freezed == targetReps
                ? _value.targetReps
                : targetReps // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeneratedExerciseImplCopyWith<$Res>
    implements $GeneratedExerciseCopyWith<$Res> {
  factory _$$GeneratedExerciseImplCopyWith(
    _$GeneratedExerciseImpl value,
    $Res Function(_$GeneratedExerciseImpl) then,
  ) = __$$GeneratedExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    MuscleGroup muscleGroup,
    DifficultyLevel difficulty,
    int defaultSets,
    List<int> defaultReps,
    int defaultRestSeconds,
    String? equipment,
    String? instructions,
    double? targetWeight,
    int? targetReps,
  });
}

/// @nodoc
class __$$GeneratedExerciseImplCopyWithImpl<$Res>
    extends _$GeneratedExerciseCopyWithImpl<$Res, _$GeneratedExerciseImpl>
    implements _$$GeneratedExerciseImplCopyWith<$Res> {
  __$$GeneratedExerciseImplCopyWithImpl(
    _$GeneratedExerciseImpl _value,
    $Res Function(_$GeneratedExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeneratedExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? muscleGroup = null,
    Object? difficulty = null,
    Object? defaultSets = null,
    Object? defaultReps = null,
    Object? defaultRestSeconds = null,
    Object? equipment = freezed,
    Object? instructions = freezed,
    Object? targetWeight = freezed,
    Object? targetReps = freezed,
  }) {
    return _then(
      _$GeneratedExerciseImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        muscleGroup: null == muscleGroup
            ? _value.muscleGroup
            : muscleGroup // ignore: cast_nullable_to_non_nullable
                  as MuscleGroup,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as DifficultyLevel,
        defaultSets: null == defaultSets
            ? _value.defaultSets
            : defaultSets // ignore: cast_nullable_to_non_nullable
                  as int,
        defaultReps: null == defaultReps
            ? _value._defaultReps
            : defaultReps // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        defaultRestSeconds: null == defaultRestSeconds
            ? _value.defaultRestSeconds
            : defaultRestSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        equipment: freezed == equipment
            ? _value.equipment
            : equipment // ignore: cast_nullable_to_non_nullable
                  as String?,
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetWeight: freezed == targetWeight
            ? _value.targetWeight
            : targetWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        targetReps: freezed == targetReps
            ? _value.targetReps
            : targetReps // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneratedExerciseImpl extends _GeneratedExercise {
  const _$GeneratedExerciseImpl({
    required this.name,
    required this.muscleGroup,
    required this.difficulty,
    required this.defaultSets,
    required final List<int> defaultReps,
    required this.defaultRestSeconds,
    this.equipment,
    this.instructions,
    this.targetWeight,
    this.targetReps,
  }) : _defaultReps = defaultReps,
       super._();

  factory _$GeneratedExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneratedExerciseImplFromJson(json);

  @override
  final String name;
  @override
  final MuscleGroup muscleGroup;
  @override
  final DifficultyLevel difficulty;
  @override
  final int defaultSets;
  final List<int> _defaultReps;
  @override
  List<int> get defaultReps {
    if (_defaultReps is EqualUnmodifiableListView) return _defaultReps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultReps);
  }

  @override
  final int defaultRestSeconds;
  @override
  final String? equipment;
  @override
  final String? instructions;
  @override
  final double? targetWeight;
  @override
  final int? targetReps;

  @override
  String toString() {
    return 'GeneratedExercise(name: $name, muscleGroup: $muscleGroup, difficulty: $difficulty, defaultSets: $defaultSets, defaultReps: $defaultReps, defaultRestSeconds: $defaultRestSeconds, equipment: $equipment, instructions: $instructions, targetWeight: $targetWeight, targetReps: $targetReps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratedExerciseImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.defaultSets, defaultSets) ||
                other.defaultSets == defaultSets) &&
            const DeepCollectionEquality().equals(
              other._defaultReps,
              _defaultReps,
            ) &&
            (identical(other.defaultRestSeconds, defaultRestSeconds) ||
                other.defaultRestSeconds == defaultRestSeconds) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    muscleGroup,
    difficulty,
    defaultSets,
    const DeepCollectionEquality().hash(_defaultReps),
    defaultRestSeconds,
    equipment,
    instructions,
    targetWeight,
    targetReps,
  );

  /// Create a copy of GeneratedExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratedExerciseImplCopyWith<_$GeneratedExerciseImpl> get copyWith =>
      __$$GeneratedExerciseImplCopyWithImpl<_$GeneratedExerciseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneratedExerciseImplToJson(this);
  }
}

abstract class _GeneratedExercise extends GeneratedExercise {
  const factory _GeneratedExercise({
    required final String name,
    required final MuscleGroup muscleGroup,
    required final DifficultyLevel difficulty,
    required final int defaultSets,
    required final List<int> defaultReps,
    required final int defaultRestSeconds,
    final String? equipment,
    final String? instructions,
    final double? targetWeight,
    final int? targetReps,
  }) = _$GeneratedExerciseImpl;
  const _GeneratedExercise._() : super._();

  factory _GeneratedExercise.fromJson(Map<String, dynamic> json) =
      _$GeneratedExerciseImpl.fromJson;

  @override
  String get name;
  @override
  MuscleGroup get muscleGroup;
  @override
  DifficultyLevel get difficulty;
  @override
  int get defaultSets;
  @override
  List<int> get defaultReps;
  @override
  int get defaultRestSeconds;
  @override
  String? get equipment;
  @override
  String? get instructions;
  @override
  double? get targetWeight;
  @override
  int? get targetReps;

  /// Create a copy of GeneratedExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratedExerciseImplCopyWith<_$GeneratedExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeneratedWorkout _$GeneratedWorkoutFromJson(Map<String, dynamic> json) {
  return _GeneratedWorkout.fromJson(json);
}

/// @nodoc
mixin _$GeneratedWorkout {
  String get id => throw _privateConstructorUsedError;
  WorkoutType get workoutType => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;
  List<GeneratedExercise> get exercises => throw _privateConstructorUsedError;
  int get estimatedDuration => throw _privateConstructorUsedError;
  int get caloriesEstimate => throw _privateConstructorUsedError;

  /// Serializes this GeneratedWorkout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneratedWorkout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneratedWorkoutCopyWith<GeneratedWorkout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneratedWorkoutCopyWith<$Res> {
  factory $GeneratedWorkoutCopyWith(
    GeneratedWorkout value,
    $Res Function(GeneratedWorkout) then,
  ) = _$GeneratedWorkoutCopyWithImpl<$Res, GeneratedWorkout>;
  @useResult
  $Res call({
    String id,
    WorkoutType workoutType,
    DifficultyLevel difficulty,
    List<GeneratedExercise> exercises,
    int estimatedDuration,
    int caloriesEstimate,
  });
}

/// @nodoc
class _$GeneratedWorkoutCopyWithImpl<$Res, $Val extends GeneratedWorkout>
    implements $GeneratedWorkoutCopyWith<$Res> {
  _$GeneratedWorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneratedWorkout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutType = null,
    Object? difficulty = null,
    Object? exercises = null,
    Object? estimatedDuration = null,
    Object? caloriesEstimate = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            workoutType: null == workoutType
                ? _value.workoutType
                : workoutType // ignore: cast_nullable_to_non_nullable
                      as WorkoutType,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as DifficultyLevel,
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<GeneratedExercise>,
            estimatedDuration: null == estimatedDuration
                ? _value.estimatedDuration
                : estimatedDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            caloriesEstimate: null == caloriesEstimate
                ? _value.caloriesEstimate
                : caloriesEstimate // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeneratedWorkoutImplCopyWith<$Res>
    implements $GeneratedWorkoutCopyWith<$Res> {
  factory _$$GeneratedWorkoutImplCopyWith(
    _$GeneratedWorkoutImpl value,
    $Res Function(_$GeneratedWorkoutImpl) then,
  ) = __$$GeneratedWorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    WorkoutType workoutType,
    DifficultyLevel difficulty,
    List<GeneratedExercise> exercises,
    int estimatedDuration,
    int caloriesEstimate,
  });
}

/// @nodoc
class __$$GeneratedWorkoutImplCopyWithImpl<$Res>
    extends _$GeneratedWorkoutCopyWithImpl<$Res, _$GeneratedWorkoutImpl>
    implements _$$GeneratedWorkoutImplCopyWith<$Res> {
  __$$GeneratedWorkoutImplCopyWithImpl(
    _$GeneratedWorkoutImpl _value,
    $Res Function(_$GeneratedWorkoutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeneratedWorkout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutType = null,
    Object? difficulty = null,
    Object? exercises = null,
    Object? estimatedDuration = null,
    Object? caloriesEstimate = null,
  }) {
    return _then(
      _$GeneratedWorkoutImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        workoutType: null == workoutType
            ? _value.workoutType
            : workoutType // ignore: cast_nullable_to_non_nullable
                  as WorkoutType,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as DifficultyLevel,
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<GeneratedExercise>,
        estimatedDuration: null == estimatedDuration
            ? _value.estimatedDuration
            : estimatedDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        caloriesEstimate: null == caloriesEstimate
            ? _value.caloriesEstimate
            : caloriesEstimate // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneratedWorkoutImpl extends _GeneratedWorkout {
  const _$GeneratedWorkoutImpl({
    required this.id,
    required this.workoutType,
    required this.difficulty,
    required final List<GeneratedExercise> exercises,
    required this.estimatedDuration,
    required this.caloriesEstimate,
  }) : _exercises = exercises,
       super._();

  factory _$GeneratedWorkoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneratedWorkoutImplFromJson(json);

  @override
  final String id;
  @override
  final WorkoutType workoutType;
  @override
  final DifficultyLevel difficulty;
  final List<GeneratedExercise> _exercises;
  @override
  List<GeneratedExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  final int estimatedDuration;
  @override
  final int caloriesEstimate;

  @override
  String toString() {
    return 'GeneratedWorkout(id: $id, workoutType: $workoutType, difficulty: $difficulty, exercises: $exercises, estimatedDuration: $estimatedDuration, caloriesEstimate: $caloriesEstimate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratedWorkoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.caloriesEstimate, caloriesEstimate) ||
                other.caloriesEstimate == caloriesEstimate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    workoutType,
    difficulty,
    const DeepCollectionEquality().hash(_exercises),
    estimatedDuration,
    caloriesEstimate,
  );

  /// Create a copy of GeneratedWorkout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratedWorkoutImplCopyWith<_$GeneratedWorkoutImpl> get copyWith =>
      __$$GeneratedWorkoutImplCopyWithImpl<_$GeneratedWorkoutImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneratedWorkoutImplToJson(this);
  }
}

abstract class _GeneratedWorkout extends GeneratedWorkout {
  const factory _GeneratedWorkout({
    required final String id,
    required final WorkoutType workoutType,
    required final DifficultyLevel difficulty,
    required final List<GeneratedExercise> exercises,
    required final int estimatedDuration,
    required final int caloriesEstimate,
  }) = _$GeneratedWorkoutImpl;
  const _GeneratedWorkout._() : super._();

  factory _GeneratedWorkout.fromJson(Map<String, dynamic> json) =
      _$GeneratedWorkoutImpl.fromJson;

  @override
  String get id;
  @override
  WorkoutType get workoutType;
  @override
  DifficultyLevel get difficulty;
  @override
  List<GeneratedExercise> get exercises;
  @override
  int get estimatedDuration;
  @override
  int get caloriesEstimate;

  /// Create a copy of GeneratedWorkout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratedWorkoutImplCopyWith<_$GeneratedWorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
