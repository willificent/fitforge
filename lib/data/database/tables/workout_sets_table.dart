import 'package:drift/drift.dart';

class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get exerciseName => text()();
  TextColumn get bodyPart => text()();
  RealColumn get weight => real()();
  RealColumn get reps => real()();
  TextColumn get comment => text().nullable()();
  IntColumn get restSeconds => integer().nullable()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
