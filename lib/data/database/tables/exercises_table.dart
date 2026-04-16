import 'package:drift/drift.dart';

class Exercises extends Table {
  TextColumn get name => text()();
  TextColumn get bodyPart => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get workoutType => text()();
  TextColumn get difficulty => text()();
  IntColumn get defaultSets => integer()();
  TextColumn get defaultReps => text()();
  IntColumn get defaultRestSeconds => integer()();
  TextColumn get equipment => text().nullable()();
  TextColumn get instructions => text().nullable()();

  @override
  Set<Column> get primaryKey => {name};
}
