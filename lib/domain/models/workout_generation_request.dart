import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_generation_request.freezed.dart';
part 'workout_generation_request.g.dart';

enum WorkoutType { strength, cardio, hiit, flexibility, mixed }

enum DifficultyLevel { beginner, intermediate, advanced }

enum MuscleGroup { chest, back, legs, shoulders, arms, core, fullBody }

@freezed
class WorkoutGenerationRequest with _$WorkoutGenerationRequest {
  const factory WorkoutGenerationRequest({
    required WorkoutType workoutType,
    required int duration,
    required DifficultyLevel difficulty,
    List<MuscleGroup>? targetMuscles,
  }) = _WorkoutGenerationRequest;

  const WorkoutGenerationRequest._();

  factory WorkoutGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkoutGenerationRequestFromJson(json);
}

@freezed
class GeneratedExercise with _$GeneratedExercise {
  const factory GeneratedExercise({
    required String name,
    required MuscleGroup muscleGroup,
    required DifficultyLevel difficulty,
    required int defaultSets,
    required List<int> defaultReps,
    required int defaultRestSeconds,
    String? equipment,
    String? instructions,
    double? targetWeight,
    int? targetReps,
  }) = _GeneratedExercise;

  const GeneratedExercise._();

  factory GeneratedExercise.fromJson(Map<String, dynamic> json) =>
      _$GeneratedExerciseFromJson(json);
}

@freezed
class GeneratedWorkout with _$GeneratedWorkout {
  const factory GeneratedWorkout({
    required String id,
    required WorkoutType workoutType,
    required DifficultyLevel difficulty,
    required List<GeneratedExercise> exercises,
    required int estimatedDuration,
    required int caloriesEstimate,
  }) = _GeneratedWorkout;

  const GeneratedWorkout._();

  factory GeneratedWorkout.fromJson(Map<String, dynamic> json) =>
      _$GeneratedWorkoutFromJson(json);
}
