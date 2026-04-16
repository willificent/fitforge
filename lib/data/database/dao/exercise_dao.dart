import 'package:drift/drift.dart';

import 'package:fitforge/data/database/app_database.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  Future<List<Exercise>> getAllExercises() => select(exercises).get();

  Stream<List<Exercise>> watchAllExercises() => select(exercises).watch();

  Future<List<Exercise>> getByBodyPart(String bodyPart) {
    return (select(exercises)..where((t) => t.bodyPart.equals(bodyPart))).get();
  }

  Future<List<Exercise>> getFavorites() {
    return (select(exercises)..where((t) => t.isFavorite.equals(true))).get();
  }

  Stream<List<Exercise>> watchFavorites() {
    return (select(exercises)..where((t) => t.isFavorite.equals(true))).watch();
  }

  Future<Exercise?> getByName(String name) {
    return (select(
      exercises,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<void> insertExercise(ExercisesCompanion entry) {
    return into(exercises).insertOnConflictUpdate(entry);
  }

  Future<void> insertAll(List<ExercisesCompanion> entries) {
    return batch((b) => b.insertAllOnConflictUpdate(exercises, entries));
  }

  Future<void> deleteExercise(String name) {
    return (delete(exercises)..where((t) => t.name.equals(name))).go();
  }

  Future<void> toggleFavorite(String name, bool isFavorite) {
    return (update(exercises)..where((t) => t.name.equals(name))).write(
      ExercisesCompanion(isFavorite: Value(isFavorite)),
    );
  }
}
