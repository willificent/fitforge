import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/data/seed/exercise_seed.dart';
import 'package:fitforge/domain/generator/workout_generator.dart';
import 'package:fitforge/domain/models/workout_generation_request.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late WorkoutGenerator generator;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.exerciseDao.insertAll(buildExerciseSeed());
    generator = WorkoutGenerator(exerciseDao: db.exerciseDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('WorkoutGenerator', () {
    test('generate returns a workout with exercises', () async {
      final request = WorkoutGenerationRequest(
        workoutType: WorkoutType.strength,
        duration: 30,
        difficulty: DifficultyLevel.intermediate,
      );

      final workout = await generator.generate(request);

      expect(workout.id, isNotEmpty);
      expect(workout.exercises, isNotEmpty);
      expect(workout.workoutType, WorkoutType.strength);
      expect(workout.estimatedDuration, 30);
      expect(workout.caloriesEstimate, greaterThan(0));
    });

    test('beginner difficulty only returns beginner exercises', () async {
      final request = WorkoutGenerationRequest(
        workoutType: WorkoutType.strength,
        duration: 30,
        difficulty: DifficultyLevel.beginner,
      );

      final workout = await generator.generate(request);

      for (final exercise in workout.exercises) {
        expect(exercise.difficulty, DifficultyLevel.beginner);
      }
    });

    test('flexibility type returns flexibility exercises', () async {
      final request = WorkoutGenerationRequest(
        workoutType: WorkoutType.flexibility,
        duration: 15,
        difficulty: DifficultyLevel.beginner,
      );

      final workout = await generator.generate(request);

      expect(workout.exercises, isNotEmpty);
      for (final exercise in workout.exercises) {
        expect(exercise.muscleGroup, isIn(MuscleGroup.values));
      }
    });

    test('mixed type includes strength, cardio, and hiit', () async {
      final request = WorkoutGenerationRequest(
        workoutType: WorkoutType.mixed,
        duration: 45,
        difficulty: DifficultyLevel.intermediate,
      );

      final workout = await generator.generate(request);

      expect(workout.exercises, isNotEmpty);
    });

    test('target muscles filters by muscle group', () async {
      final request = WorkoutGenerationRequest(
        workoutType: WorkoutType.strength,
        duration: 30,
        difficulty: DifficultyLevel.intermediate,
        targetMuscles: [MuscleGroup.chest],
      );

      final workout = await generator.generate(request);

      for (final exercise in workout.exercises) {
        expect(exercise.muscleGroup, MuscleGroup.chest);
      }
    });

    test('short duration returns minimum 3 exercises', () async {
      final request = WorkoutGenerationRequest(
        workoutType: WorkoutType.strength,
        duration: 15,
        difficulty: DifficultyLevel.beginner,
      );

      final workout = await generator.generate(request);

      expect(workout.exercises.length, greaterThanOrEqualTo(3));
    });

    test('calories estimate varies by difficulty', () async {
      final beginnerRequest = WorkoutGenerationRequest(
        workoutType: WorkoutType.strength,
        duration: 30,
        difficulty: DifficultyLevel.beginner,
      );
      final advancedRequest = WorkoutGenerationRequest(
        workoutType: WorkoutType.strength,
        duration: 30,
        difficulty: DifficultyLevel.advanced,
      );

      final beginnerWorkout = await generator.generate(beginnerRequest);
      final advancedWorkout = await generator.generate(advancedRequest);

      expect(
        advancedWorkout.caloriesEstimate,
        greaterThan(beginnerWorkout.caloriesEstimate),
      );
    });
  });
}
