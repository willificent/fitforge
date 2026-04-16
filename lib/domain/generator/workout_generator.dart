import 'dart:math';

import 'package:uuid/uuid.dart';

import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/domain/models/workout_generation_request.dart';

class WorkoutGenerator {
  final ExerciseDao _exerciseDao;
  final Random _random;
  final Uuid _uuid;

  WorkoutGenerator({
    required ExerciseDao exerciseDao,
    Random? random,
    Uuid? uuid,
  }) : _exerciseDao = exerciseDao,
       _random = random ?? Random(),
       _uuid = uuid ?? const Uuid();

  Future<GeneratedWorkout> generate(WorkoutGenerationRequest request) async {
    final allExercises = await _exerciseDao.getAllExercises();
    final filtered = _filterExercises(allExercises, request);
    final count = _calculateExerciseCount(request.duration, filtered.length);
    final selected = _selectExercises(filtered, count);
    final exercises = selected.map(_toGeneratedExercise).toList();
    final calories = _estimateCalories(request.duration, request.difficulty);

    return GeneratedWorkout(
      id: _uuid.v4(),
      workoutType: request.workoutType,
      difficulty: request.difficulty,
      exercises: exercises,
      estimatedDuration: request.duration,
      caloriesEstimate: calories,
    );
  }

  List<Exercise> _filterExercises(
    List<Exercise> exercises,
    WorkoutGenerationRequest request,
  ) {
    return exercises.where((e) {
      if (!_matchesWorkoutType(e.workoutType, request.workoutType)) {
        return false;
      }

      if (!_matchesDifficulty(e.difficulty, request.difficulty)) {
        return false;
      }

      if (request.targetMuscles != null && request.targetMuscles!.isNotEmpty) {
        final muscleGroup = _bodyPartToMuscleGroup(e.bodyPart);
        if (!request.targetMuscles!.contains(muscleGroup)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool _matchesWorkoutType(String exerciseType, WorkoutType requested) {
    if (requested == WorkoutType.mixed) {
      return exerciseType == WorkoutType.strength.name ||
          exerciseType == WorkoutType.cardio.name ||
          exerciseType == WorkoutType.hiit.name;
    }
    return exerciseType == requested.name;
  }

  bool _matchesDifficulty(
    String exerciseDifficulty,
    DifficultyLevel requested,
  ) {
    const order = [
      DifficultyLevel.beginner,
      DifficultyLevel.intermediate,
      DifficultyLevel.advanced,
    ];
    final exerciseIdx = order.indexWhere((d) => d.name == exerciseDifficulty);
    final requestedIdx = order.indexOf(requested);
    if (exerciseIdx < 0 || requestedIdx < 0) return true;
    return exerciseIdx <= requestedIdx;
  }

  MuscleGroup _bodyPartToMuscleGroup(String bodyPart) {
    return switch (bodyPart.toLowerCase()) {
      'chest' => MuscleGroup.chest,
      'back' => MuscleGroup.back,
      'legs' => MuscleGroup.legs,
      'shoulders' => MuscleGroup.shoulders,
      'biceps' || 'triceps' || 'arms' => MuscleGroup.arms,
      'abs' || 'core' => MuscleGroup.core,
      _ => MuscleGroup.fullBody,
    };
  }

  int _calculateExerciseCount(int duration, int availableCount) {
    final count = max(
      AppConstants.minExercisesPerWorkout,
      duration ~/ AppConstants.exerciseCountDivisor,
    );
    return min(count, availableCount);
  }

  List<Exercise> _selectExercises(List<Exercise> exercises, int count) {
    if (count >= exercises.length) return exercises;
    final copy = List<Exercise>.from(exercises)..shuffle(_random);
    return copy.take(count).toList();
  }

  GeneratedExercise _toGeneratedExercise(Exercise e) {
    final defaultReps = e.defaultReps.split(',').map(int.parse).toList();
    return GeneratedExercise(
      name: e.name,
      muscleGroup: _bodyPartToMuscleGroup(e.bodyPart),
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == e.difficulty,
        orElse: () => DifficultyLevel.beginner,
      ),
      defaultSets: e.defaultSets,
      defaultReps: defaultReps,
      defaultRestSeconds: e.defaultRestSeconds,
      equipment: e.equipment,
      instructions: e.instructions,
    );
  }

  int _estimateCalories(int duration, DifficultyLevel difficulty) {
    final rate = switch (difficulty) {
      DifficultyLevel.beginner => AppConstants.caloriesPerMinuteBeginner,
      DifficultyLevel.intermediate =>
        AppConstants.caloriesPerMinuteIntermediate,
      DifficultyLevel.advanced => AppConstants.caloriesPerMinuteAdvanced,
    };
    return duration * rate;
  }
}
