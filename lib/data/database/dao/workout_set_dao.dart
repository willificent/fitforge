import 'package:drift/drift.dart';

import 'package:fitforge/data/database/app_database.dart';

part 'workout_set_dao.g.dart';

@DriftAccessor(tables: [WorkoutSets])
class WorkoutSetDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutSetDaoMixin {
  WorkoutSetDao(super.db);

  Stream<List<WorkoutSet>> watchSetsForDate(String date) {
    return (select(workoutSets)
      ..where((t) => t.date.equals(date))
      ..orderBy([
        (t) => OrderingTerm.asc(t.displayOrder),
        (t) => OrderingTerm.asc(t.id),
      ])).watch();
  }

  Future<List<WorkoutSet>> getSetsForDate(String date) {
    return (select(workoutSets)
      ..where((t) => t.date.equals(date))
      ..orderBy([
        (t) => OrderingTerm.asc(t.displayOrder),
        (t) => OrderingTerm.asc(t.id),
      ])).get();
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

  Future<List<WorkoutSet>> getSetsForDateRange(
    String startDate,
    String endDate,
  ) {
    return (select(workoutSets)..where(
          (t) =>
              t.date.isBiggerOrEqualValue(startDate) &
              t.date.isSmallerOrEqualValue(endDate),
        ))
        .get();
  }

  Future<int> insertSet(WorkoutSetsCompanion entry) {
    return into(workoutSets).insert(entry);
  }

  Future<void> updateSet(WorkoutSetsCompanion entry) {
    return (update(
      workoutSets,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<void> updateDisplayOrders(List<({int id, int order})> updates) {
    return transaction(() async {
      for (final u in updates) {
        await (update(workoutSets)..where((t) => t.id.equals(u.id))).write(
          WorkoutSetsCompanion(displayOrder: Value(u.order)),
        );
      }
    });
  }

  Future<int> deleteSet(int id) {
    return (delete(workoutSets)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllSets() => delete(workoutSets).go();
}
