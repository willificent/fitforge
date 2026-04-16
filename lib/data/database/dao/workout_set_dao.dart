import 'package:drift/drift.dart';

import 'package:fitforge/data/database/app_database.dart';

part 'workout_set_dao.g.dart';

@DriftAccessor(tables: [WorkoutSets])
class WorkoutSetDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutSetDaoMixin {
  WorkoutSetDao(super.db);

  Stream<List<WorkoutSet>> watchSetsForDate(String date) {
    return (select(workoutSets)..where((t) => t.date.equals(date))).watch();
  }

  Future<List<WorkoutSet>> getSetsForDate(String date) {
    return (select(workoutSets)..where((t) => t.date.equals(date))).get();
  }

  Stream<List<WorkoutSet>> watchSetsForExercise(String exerciseName) {
    return (select(
      workoutSets,
    )..where((t) => t.exerciseName.equals(exerciseName))).watch();
  }

  Future<List<WorkoutSet>> getSetsForExercise(String exerciseName) {
    return (select(
      workoutSets,
    )..where((t) => t.exerciseName.equals(exerciseName))).get();
  }

  Future<WorkoutSet?> getLastSetForExercise(String exerciseName) {
    final query = select(workoutSets)
      ..where((t) => t.exerciseName.equals(exerciseName))
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Stream<List<WorkoutSet>> watchAllSets() => select(workoutSets).watch();

  Future<List<WorkoutSet>> getAllSets() => select(workoutSets).get();

  Future<List<WorkoutSet>> getSetsForMonth(String monthPrefix) {
    return (select(
      workoutSets,
    )..where((t) => t.date.like('$monthPrefix%'))).get();
  }

  Future<int> insertSet(WorkoutSetsCompanion entry) {
    return into(workoutSets).insert(entry);
  }

  Future<void> updateSet(WorkoutSetsCompanion entry) {
    return (update(
      workoutSets,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<int> deleteSet(int id) {
    return (delete(workoutSets)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllSets() => delete(workoutSets).go();
}
