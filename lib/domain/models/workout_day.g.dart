// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutDayImpl _$$WorkoutDayImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutDayImpl(
      date: json['date'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      dayVolume: (json['dayVolume'] as num).toDouble(),
      totalSets: (json['totalSets'] as num).toInt(),
    );

Map<String, dynamic> _$$WorkoutDayImplToJson(_$WorkoutDayImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'exercises': instance.exercises,
      'dayVolume': instance.dayVolume,
      'totalSets': instance.totalSets,
    };

_$WorkoutExerciseImpl _$$WorkoutExerciseImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutExerciseImpl(
  exerciseName: json['exerciseName'] as String,
  bodyPart: json['bodyPart'] as String,
  date: json['date'] as String,
  sets: (json['sets'] as List<dynamic>)
      .map((e) => WorkoutSetRecord.fromJson(e as Map<String, dynamic>))
      .toList(),
  volume: (json['volume'] as num).toDouble(),
  estimatedOneRepMax: (json['estimatedOneRepMax'] as num).toDouble(),
  maxWeight: (json['maxWeight'] as num).toDouble(),
  maxReps: (json['maxReps'] as num).toDouble(),
  volumePR: json['volumePR'] as bool,
  estimatedOneRepMaxPR: json['estimatedOneRepMaxPR'] as bool,
  harderThanLastTime: json['harderThanLastTime'] as bool,
);

Map<String, dynamic> _$$WorkoutExerciseImplToJson(
  _$WorkoutExerciseImpl instance,
) => <String, dynamic>{
  'exerciseName': instance.exerciseName,
  'bodyPart': instance.bodyPart,
  'date': instance.date,
  'sets': instance.sets,
  'volume': instance.volume,
  'estimatedOneRepMax': instance.estimatedOneRepMax,
  'maxWeight': instance.maxWeight,
  'maxReps': instance.maxReps,
  'volumePR': instance.volumePR,
  'estimatedOneRepMaxPR': instance.estimatedOneRepMaxPR,
  'harderThanLastTime': instance.harderThanLastTime,
};

_$WorkoutSetRecordImpl _$$WorkoutSetRecordImplFromJson(
  Map<String, dynamic> json,
) => _$WorkoutSetRecordImpl(
  id: (json['id'] as num).toInt(),
  date: json['date'] as String,
  exerciseName: json['exerciseName'] as String,
  bodyPart: json['bodyPart'] as String,
  weight: (json['weight'] as num).toDouble(),
  reps: (json['reps'] as num).toDouble(),
  comment: json['comment'] as String?,
  restSeconds: (json['restSeconds'] as num?)?.toInt(),
  targetWeight: (json['targetWeight'] as num?)?.toDouble(),
  targetReps: (json['targetReps'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$WorkoutSetRecordImplToJson(
  _$WorkoutSetRecordImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'exerciseName': instance.exerciseName,
  'bodyPart': instance.bodyPart,
  'weight': instance.weight,
  'reps': instance.reps,
  'comment': instance.comment,
  'restSeconds': instance.restSeconds,
  'targetWeight': instance.targetWeight,
  'targetReps': instance.targetReps,
};
