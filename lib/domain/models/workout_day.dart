import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_day.freezed.dart';
part 'workout_day.g.dart';

@freezed
class WorkoutDay with _$WorkoutDay {
  const factory WorkoutDay({
    required String date,
    required List<WorkoutExercise> exercises,
    required double dayVolume,
    required int totalSets,
  }) = _WorkoutDay;

  const WorkoutDay._();

  factory WorkoutDay.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDayFromJson(json);
}

@freezed
class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String exerciseName,
    required String bodyPart,
    required String date,
    required List<WorkoutSetRecord> sets,
    required double volume,
    required double estimatedOneRepMax,
    required double maxWeight,
    required double maxReps,
    required bool volumePR,
    required bool estimatedOneRepMaxPR,
    required bool harderThanLastTime,
  }) = _WorkoutExercise;

  const WorkoutExercise._();

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);
}

@freezed
class WorkoutSetRecord with _$WorkoutSetRecord {
  const factory WorkoutSetRecord({
    required int id,
    required String date,
    required String exerciseName,
    required String bodyPart,
    required double weight,
    required double reps,
    String? comment,
    int? restSeconds,
    double? targetWeight,
    double? targetReps,
  }) = _WorkoutSetRecord;

  const WorkoutSetRecord._();

  double get volume => weight * reps;

  double get estimatedOneRepMax => weight * (1 + reps / 30);

  factory WorkoutSetRecord.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetRecordFromJson(json);
}
