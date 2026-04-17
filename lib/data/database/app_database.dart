import 'package:drift/drift.dart';

import 'tables/exercises_table.dart';
import 'tables/workout_sets_table.dart';
import 'tables/settings_table.dart';
import 'dao/exercise_dao.dart';
import 'dao/workout_set_dao.dart';
import 'dao/settings_dao.dart';
import 'database_setup.dart' as setup;

export 'dao/exercise_dao.dart';
export 'dao/workout_set_dao.dart';
export 'dao/settings_dao.dart';
export 'tables/exercises_table.dart';
export 'tables/workout_sets_table.dart';
export 'tables/settings_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Exercises, WorkoutSets, Settings],
  daos: [ExerciseDao, WorkoutSetDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(setup.openConnection());

  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(exercises, exercises.isBodyweight);
      }
      await m.createAll();
    },
  );
}
