import 'package:drift/drift.dart';
import 'package:fitforge/data/database/app_database.dart';

class WorkoutRepository {
  final AppDatabase _database;

  WorkoutRepository(this._database);

  WorkoutSetDao get _dao => _database.workoutSetDao;

  Stream<List<WorkoutSet>> watchSetsForDate(String date) {
    return _dao.watchSetsForDate(date);
  }

  Future<List<WorkoutSet>> getSetsForDate(String date) {
    return _dao.getSetsForDate(date);
  }

  Stream<List<WorkoutSet>> watchSetsForExercise(String exerciseName) {
    return _dao.watchSetsForExercise(exerciseName);
  }

  Future<List<WorkoutSet>> getAllSetsForMonth(String monthPrefix) {
    return _dao.getSetsForMonth(monthPrefix);
  }

  Future<List<WorkoutSet>> getSetsForDateRange(
    String startDate,
    String endDate,
  ) {
    return _dao.getSetsForDateRange(startDate, endDate);
  }

  Future<WorkoutSet?> getLastSetForExercise(String exerciseName) {
    return _dao.getLastSetForExercise(exerciseName);
  }

  Future<int> logSet({
    required String date,
    required String exerciseName,
    required String bodyPart,
    required double weight,
    required double reps,
    String? comment,
    int? restSeconds,
  }) {
    return _dao.insertSet(
      WorkoutSetsCompanion.insert(
        date: date,
        exerciseName: exerciseName,
        bodyPart: bodyPart,
        weight: weight,
        reps: reps,
        comment: Value(comment),
        restSeconds: Value(restSeconds),
      ),
    );
  }

  Future<void> updateSet({
    required int id,
    required double weight,
    required double reps,
    String? comment,
  }) {
    return _dao.updateSet(
      WorkoutSetsCompanion(
        id: Value(id),
        weight: Value(weight),
        reps: Value(reps),
        comment: Value(comment),
      ),
    );
  }

  Future<void> deleteSet(int id) => _dao.deleteSet(id);

  Future<void> reorderExercises(List<({int id, int order})> updates) {
    return _dao.updateDisplayOrders(updates);
  }

  Future<void> addPlannedExercises({
    required String date,
    required List<({String name, String bodyPart, int sets, String reps})> exercises,
  }) async {
    for (final ex in exercises) {
      final repsList = ex.reps.split(',').map((r) => r.trim()).toList();
      for (int i = 0; i < ex.sets; i++) {
        final rep = i < repsList.length ? repsList[i] : repsList.last;
        await logSet(
          date: date,
          exerciseName: ex.name,
          bodyPart: ex.bodyPart,
          weight: 0,
          reps: double.tryParse(rep) ?? 0,
          comment: 'planned',
        );
      }
    }
  }
}
