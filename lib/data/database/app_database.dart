import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/exercises_table.dart';
import 'tables/workout_sets_table.dart';
import 'tables/settings_table.dart';
import 'dao/exercise_dao.dart';
import 'dao/workout_set_dao.dart';
import 'dao/settings_dao.dart';

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
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      await m.createAll();
    },
  );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = p.join(dbFolder.path, 'fitforge.db');
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      return NativeDatabase.createInBackground(io.File(file));
    });
  }
}
