import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_personal_stats.freezed.dart';
part 'exercise_personal_stats.g.dart';

@freezed
class ExercisePersonalStats with _$ExercisePersonalStats {
  const factory ExercisePersonalStats({
    required String exerciseName,
    required String bodyPart,
    required double maxVolume,
    required double maxWeight,
    required double maxReps,
    required double estimatedOneRepMax,
    required double actualOneRepMax,
    required DateTime? maxVolumeDate,
    required DateTime? maxWeightDate,
    required DateTime? estimatedOneRepMaxDate,
    required double averageSetsPerWeek,
    required int totalWorkouts,
  }) = _ExercisePersonalStats;

  const ExercisePersonalStats._();

  factory ExercisePersonalStats.fromJson(Map<String, dynamic> json) =>
      _$ExercisePersonalStatsFromJson(json);
}
