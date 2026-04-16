import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/data/repositories/exercise_repository.dart';
import 'package:fitforge/data/seed/exercise_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late ExerciseRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.exerciseDao.insertAll(buildExerciseSeed());
    repo = ExerciseRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExerciseRepository', () {
    test('getAll returns seeded exercises', () async {
      final exercises = await repo.getAll();
      expect(exercises.length, greaterThan(80));
    });

    test('getByBodyPart filters correctly', () async {
      final chestExercises = await repo.getByBodyPart('Chest');
      for (final e in chestExercises) {
        expect(e.bodyPart, 'Chest');
      }
      expect(chestExercises.length, greaterThan(5));
    });

    test('getByName returns matching exercise', () async {
      final exercise = await repo.getByName('Push-ups');
      expect(exercise, isNotNull);
      expect(exercise!.name, 'Push-ups');
      expect(exercise.workoutType, 'strength');
      expect(exercise.difficulty, 'beginner');
    });

    test('getByName returns null for unknown exercise', () async {
      final exercise = await repo.getByName('Nonexistent Exercise');
      expect(exercise, isNull);
    });

    test('addCustomExercise inserts a new exercise', () async {
      await repo.addCustomExercise(
        name: 'My Custom Exercise',
        bodyPart: 'Arms',
        workoutType: 'strength',
        difficulty: 'intermediate',
      );

      final exercise = await repo.getByName('My Custom Exercise');
      expect(exercise, isNotNull);
      expect(exercise!.bodyPart, 'Arms');
    });

    test('toggleFavorite updates favorite status', () async {
      final pushups = await repo.getByName('Push-ups');
      expect(pushups!.isFavorite, false);

      await repo.toggleFavorite('Push-ups', true);

      final updated = await repo.getByName('Push-ups');
      expect(updated!.isFavorite, true);
    });

    test('deleteExercise removes an exercise', () async {
      await repo.deleteExercise('Push-ups');
      final exercise = await repo.getByName('Push-ups');
      expect(exercise, isNull);
    });

    test('seed data covers all workout types', () async {
      final exercises = await repo.getAll();
      final types = exercises.map((e) => e.workoutType).toSet();
      expect(types.contains('strength'), true);
      expect(types.contains('cardio'), true);
      expect(types.contains('hiit'), true);
      expect(types.contains('flexibility'), true);
    });

    test('seed data covers all body parts', () async {
      final exercises = await repo.getAll();
      final parts = exercises.map((e) => e.bodyPart).toSet();
      expect(parts.contains('Chest'), true);
      expect(parts.contains('Back'), true);
      expect(parts.contains('Legs'), true);
      expect(parts.contains('Shoulders'), true);
      expect(parts.contains('Arms'), true);
      expect(parts.contains('Core'), true);
    });
  });
}
