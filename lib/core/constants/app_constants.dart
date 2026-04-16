abstract class AppConstants {
  AppConstants._();

  static const appName = 'FitForge';

  static const defaultWeightIncreaseRate = 0.05;
  static const defaultRepIncreaseStep = 2;
  static const defaultRepDropStep = 2;
  static const weightRoundStep = 2.5;
  static const minReps = 4;
  static const maxReps = 20;

  static const defaultUnit = 'lbs';
  static const defaultProgressionType = 'linear';

  static const defaultRestSeconds = 90;
  static const restTimerTickInterval = 1000;

  static const exerciseCountDivisor = 7;
  static const minExercisesPerWorkout = 3;

  static const caloriesPerMinuteBeginner = 5;
  static const caloriesPerMinuteIntermediate = 7;
  static const caloriesPerMinuteAdvanced = 10;

  static const webdavBackupPrefix = 'fitforge_';
  static const csvDateFormat = 'yyyy-MM-dd';
}
