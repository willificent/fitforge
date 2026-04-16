import 'package:drift/drift.dart';
import 'package:fitforge/data/database/app_database.dart';

class ExerciseRepository {
  final AppDatabase _database;

  ExerciseRepository(this._database);

  ExerciseDao get _dao => _database.exerciseDao;

  Stream<List<Exercise>> watchAll() => _dao.watchAllExercises();

  Future<List<Exercise>> getAll() => _dao.getAllExercises();

  Future<List<Exercise>> getByBodyPart(String bodyPart) =>
      _dao.getByBodyPart(bodyPart);

  Stream<List<Exercise>> watchFavorites() => _dao.watchFavorites();

  Future<Exercise?> getByName(String name) => _dao.getByName(name);

  Future<void> toggleFavorite(String name, bool isFavorite) =>
      _dao.toggleFavorite(name, isFavorite);

  Future<void> addCustomExercise({
    required String name,
    required String bodyPart,
    required String workoutType,
    required String difficulty,
    int defaultSets = 3,
    String defaultReps = '10, 10, 10',
    int defaultRestSeconds = 90,
    String? equipment,
    String? instructions,
  }) {
    return _dao.insertExercise(
      ExercisesCompanion.insert(
        name: name,
        bodyPart: bodyPart,
        workoutType: workoutType,
        difficulty: difficulty,
        defaultSets: defaultSets,
        defaultReps: defaultReps,
        defaultRestSeconds: defaultRestSeconds,
        equipment: Value(equipment),
        instructions: Value(instructions),
      ),
    );
  }

  Future<void> deleteExercise(String name) => _dao.deleteExercise(name);

  Future<void> seedExercises(List<ExercisesCompanion> entries) =>
      _dao.insertAll(entries);
}
