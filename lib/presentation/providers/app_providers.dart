import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/data/repositories/workout_repository.dart';
import 'package:fitforge/data/repositories/exercise_repository.dart';
import 'package:fitforge/data/repositories/settings_repository.dart';
import 'package:fitforge/data/seed/exercise_seed.dart';
import 'package:fitforge/data/sync/webdav_sync_service.dart';
import 'package:fitforge/domain/generator/workout_generator.dart';
import 'package:fitforge/domain/generator/progressive_target_calculator.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final exerciseSeedProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  final existing = await db.exerciseDao.getAllExercises();
  if (existing.isEmpty) {
    await db.exerciseDao.insertAll(buildExerciseSeed());
  }
});

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepository(ref.watch(databaseProvider)),
);

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepository(ref.watch(databaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final workoutGeneratorProvider = Provider<WorkoutGenerator>(
  (ref) =>
      WorkoutGenerator(exerciseDao: ref.watch(databaseProvider).exerciseDao),
);

final progressiveTargetProvider = Provider<ProgressiveTargetCalculator>(
  (ref) => ProgressiveTargetCalculator(),
);

final unitProvider = FutureProvider<String>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.getUnit();
});

final themeModeProvider = FutureProvider<ThemeMode>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  final mode = await repo.getThemeMode();
  return switch (mode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});

final webdavSyncProvider = Provider<WebdavSyncService>((ref) {
  return WebdavSyncService(ref.read(settingsRepositoryProvider));
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
