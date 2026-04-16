// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_generation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutGenerationRequestImpl _$$WorkoutGenerationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutGenerationRequestImpl(
  workoutType: $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
  duration: (json['duration'] as num).toInt(),
  difficulty: $enumDecode(_$DifficultyLevelEnumMap, json['difficulty']),
  targetMuscles: (json['targetMuscles'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$MuscleGroupEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$$WorkoutGenerationRequestImplToJson(
  _$WorkoutGenerationRequestImpl instance,
) => <String, dynamic>{
  'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
  'duration': instance.duration,
  'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
  'targetMuscles': instance.targetMuscles
      ?.map((e) => _$MuscleGroupEnumMap[e]!)
      .toList(),
};

const _$WorkoutTypeEnumMap = {
  WorkoutType.strength: 'strength',
  WorkoutType.cardio: 'cardio',
  WorkoutType.hiit: 'hiit',
  WorkoutType.flexibility: 'flexibility',
  WorkoutType.mixed: 'mixed',
};

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.beginner: 'beginner',
  DifficultyLevel.intermediate: 'intermediate',
  DifficultyLevel.advanced: 'advanced',
};

const _$MuscleGroupEnumMap = {
  MuscleGroup.chest: 'chest',
  MuscleGroup.back: 'back',
  MuscleGroup.legs: 'legs',
  MuscleGroup.shoulders: 'shoulders',
  MuscleGroup.arms: 'arms',
  MuscleGroup.core: 'core',
  MuscleGroup.fullBody: 'fullBody',
};

_$GeneratedExerciseImpl _$$GeneratedExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$GeneratedExerciseImpl(
  name: json['name'] as String,
  muscleGroup: $enumDecode(_$MuscleGroupEnumMap, json['muscleGroup']),
  difficulty: $enumDecode(_$DifficultyLevelEnumMap, json['difficulty']),
  defaultSets: (json['defaultSets'] as num).toInt(),
  defaultReps: (json['defaultReps'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  defaultRestSeconds: (json['defaultRestSeconds'] as num).toInt(),
  equipment: json['equipment'] as String?,
  instructions: json['instructions'] as String?,
  targetWeight: (json['targetWeight'] as num?)?.toDouble(),
  targetReps: (json['targetReps'] as num?)?.toInt(),
);

Map<String, dynamic> _$$GeneratedExerciseImplToJson(
  _$GeneratedExerciseImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'muscleGroup': _$MuscleGroupEnumMap[instance.muscleGroup]!,
  'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
  'defaultSets': instance.defaultSets,
  'defaultReps': instance.defaultReps,
  'defaultRestSeconds': instance.defaultRestSeconds,
  'equipment': instance.equipment,
  'instructions': instance.instructions,
  'targetWeight': instance.targetWeight,
  'targetReps': instance.targetReps,
};

_$GeneratedWorkoutImpl _$$GeneratedWorkoutImplFromJson(
  Map<String, dynamic> json,
) => _$GeneratedWorkoutImpl(
  id: json['id'] as String,
  workoutType: $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
  difficulty: $enumDecode(_$DifficultyLevelEnumMap, json['difficulty']),
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => GeneratedExercise.fromJson(e as Map<String, dynamic>))
      .toList(),
  estimatedDuration: (json['estimatedDuration'] as num).toInt(),
  caloriesEstimate: (json['caloriesEstimate'] as num).toInt(),
);

Map<String, dynamic> _$$GeneratedWorkoutImplToJson(
  _$GeneratedWorkoutImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
  'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
  'exercises': instance.exercises,
  'estimatedDuration': instance.estimatedDuration,
  'caloriesEstimate': instance.caloriesEstimate,
};
