import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/domain/models/workout_day.dart';

class TargetResult {
  final double targetWeight;
  final int targetReps;

  const TargetResult({required this.targetWeight, required this.targetReps});
}

class ProgressiveTargetCalculator {
  final double weightIncreaseRate;
  final int repIncreaseStep;
  final double weightRoundStep;

  ProgressiveTargetCalculator({
    this.weightIncreaseRate = AppConstants.defaultWeightIncreaseRate,
    this.repIncreaseStep = AppConstants.defaultRepIncreaseStep,
    this.weightRoundStep = AppConstants.weightRoundStep,
  });

  TargetResult? calculate(List<WorkoutSetRecord> history) {
    if (history.isEmpty) return null;

    final avgWeight = history.last.weight;
    final avgReps = history.last.reps;

    final hitTarget =
        history.last.targetReps != null && avgReps >= history.last.targetReps!;

    if (hitTarget) {
      return TargetResult(
        targetWeight: _roundToNearest(avgWeight * (1 + weightIncreaseRate)),
        targetReps: (avgReps - AppConstants.defaultRepDropStep).toInt().clamp(
          AppConstants.minReps,
          AppConstants.maxReps,
        ),
      );
    } else {
      return TargetResult(
        targetWeight: avgWeight,
        targetReps: (avgReps - repIncreaseStep).toInt().clamp(
          AppConstants.minReps,
          AppConstants.maxReps,
        ),
      );
    }
  }

  Future<TargetResult?> calculateForExercise(
    WorkoutSetDao dao,
    String exerciseName,
  ) async {
    final sets = await dao.getSetsForExercise(exerciseName);
    if (sets.isEmpty) return null;

    final last = sets.last;
    final avgWeight = last.weight;
    final avgReps = last.reps;

    return TargetResult(
      targetWeight: avgWeight,
      targetReps: (avgReps - repIncreaseStep).toInt().clamp(
        AppConstants.minReps,
        AppConstants.maxReps,
      ),
    );
  }

  double _roundToNearest(double value) {
    return (value / weightRoundStep).round() * weightRoundStep;
  }
}
