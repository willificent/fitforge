// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_personal_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExercisePersonalStatsImpl _$$ExercisePersonalStatsImplFromJson(
  Map<String, dynamic> json,
) => _$ExercisePersonalStatsImpl(
  exerciseName: json['exerciseName'] as String,
  bodyPart: json['bodyPart'] as String,
  maxVolume: (json['maxVolume'] as num).toDouble(),
  maxWeight: (json['maxWeight'] as num).toDouble(),
  maxReps: (json['maxReps'] as num).toDouble(),
  estimatedOneRepMax: (json['estimatedOneRepMax'] as num).toDouble(),
  actualOneRepMax: (json['actualOneRepMax'] as num).toDouble(),
  maxVolumeDate: json['maxVolumeDate'] == null
      ? null
      : DateTime.parse(json['maxVolumeDate'] as String),
  maxWeightDate: json['maxWeightDate'] == null
      ? null
      : DateTime.parse(json['maxWeightDate'] as String),
  estimatedOneRepMaxDate: json['estimatedOneRepMaxDate'] == null
      ? null
      : DateTime.parse(json['estimatedOneRepMaxDate'] as String),
  averageSetsPerWeek: (json['averageSetsPerWeek'] as num).toDouble(),
  totalWorkouts: (json['totalWorkouts'] as num).toInt(),
);

Map<String, dynamic> _$$ExercisePersonalStatsImplToJson(
  _$ExercisePersonalStatsImpl instance,
) => <String, dynamic>{
  'exerciseName': instance.exerciseName,
  'bodyPart': instance.bodyPart,
  'maxVolume': instance.maxVolume,
  'maxWeight': instance.maxWeight,
  'maxReps': instance.maxReps,
  'estimatedOneRepMax': instance.estimatedOneRepMax,
  'actualOneRepMax': instance.actualOneRepMax,
  'maxVolumeDate': instance.maxVolumeDate?.toIso8601String(),
  'maxWeightDate': instance.maxWeightDate?.toIso8601String(),
  'estimatedOneRepMaxDate': instance.estimatedOneRepMaxDate?.toIso8601String(),
  'averageSetsPerWeek': instance.averageSetsPerWeek,
  'totalWorkouts': instance.totalWorkouts,
};
