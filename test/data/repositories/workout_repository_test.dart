import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/data/repositories/workout_repository.dart';
import 'package:fitforge/data/seed/exercise_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late WorkoutRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.exerciseDao.insertAll(buildExerciseSeed());
    repo = WorkoutRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('WorkoutRepository', () {
    test('logSet inserts a workout set', () async {
      final id = await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Bench Press',
        bodyPart: 'Chest',
        weight: 135.0,
        reps: 10,
      );

      expect(id, greaterThan(0));

      final sets = await repo.getSetsForDate('2026-04-15');
      expect(sets.length, 1);
      expect(sets.first.exerciseName, 'Bench Press');
      expect(sets.first.weight, 135.0);
      expect(sets.first.reps, 10);
    });

    test('getSetsForDate returns empty list when no sets exist', () async {
      final sets = await repo.getSetsForDate('2026-01-01');
      expect(sets, isEmpty);
    });

    test('getLastSetForExercise returns most recent set', () async {
      await repo.logSet(
        date: '2026-04-14',
        exerciseName: 'Squat',
        bodyPart: 'Legs',
        weight: 225.0,
        reps: 5,
      );
      await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Squat',
        bodyPart: 'Legs',
        weight: 235.0,
        reps: 5,
      );

      final last = await repo.getLastSetForExercise('Squat');
      expect(last, isNotNull);
      expect(last!.weight, 235.0);
    });

    test('getLastSetForExercise returns null for unknown exercise', () async {
      final result = await repo.getLastSetForExercise('Nonexistent Exercise');
      expect(result, isNull);
    });

    test('updateSet modifies an existing set', () async {
      final id = await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Deadlift',
        bodyPart: 'Back',
        weight: 315.0,
        reps: 5,
      );

      await repo.updateSet(id: id, weight: 325.0, reps: 3);

      final sets = await repo.getSetsForDate('2026-04-15');
      expect(sets.first.weight, 325.0);
      expect(sets.first.reps, 3);
    });

    test('deleteSet removes a set', () async {
      final id = await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Bench Press',
        bodyPart: 'Chest',
        weight: 135.0,
        reps: 10,
      );

      await repo.deleteSet(id);

      final sets = await repo.getSetsForDate('2026-04-15');
      expect(sets, isEmpty);
    });

    test('multiple sets on same date', () async {
      await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Bench Press',
        bodyPart: 'Chest',
        weight: 135.0,
        reps: 10,
      );
      await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Bench Press',
        bodyPart: 'Chest',
        weight: 145.0,
        reps: 8,
      );
      await repo.logSet(
        date: '2026-04-15',
        exerciseName: 'Squat',
        bodyPart: 'Legs',
        weight: 225.0,
        reps: 5,
      );

      final sets = await repo.getSetsForDate('2026-04-15');
      expect(sets.length, 3);
    });
  });
}
