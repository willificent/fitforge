import 'package:flutter_test/flutter_test.dart';

import 'package:fitforge/domain/generator/progressive_target_calculator.dart';
import 'package:fitforge/domain/models/workout_day.dart';

void main() {
  group('ProgressiveTargetCalculator', () {
    late ProgressiveTargetCalculator calculator;

    setUp(() {
      calculator = ProgressiveTargetCalculator();
    });

    test('returns null for empty history', () {
      final result = calculator.calculate([]);
      expect(result, isNull);
    });

    test('increases weight when target reps hit', () {
      final history = [
        WorkoutSetRecord(
          id: 1,
          date: '2026-04-14',
          exerciseName: 'Bench Press',
          bodyPart: 'Chest',
          weight: 100.0,
          reps: 10,
          targetReps: 10,
        ),
      ];

      final result = calculator.calculate(history);

      expect(result, isNotNull);
      expect(result!.targetWeight, greaterThan(100.0));
      expect(result.targetReps, lessThan(10));
    });

    test('keeps same weight when target reps missed', () {
      final history = [
        WorkoutSetRecord(
          id: 1,
          date: '2026-04-14',
          exerciseName: 'Bench Press',
          bodyPart: 'Chest',
          weight: 100.0,
          reps: 7,
          targetReps: 10,
        ),
      ];

      final result = calculator.calculate(history);

      expect(result, isNotNull);
      expect(result!.targetWeight, 100.0);
      expect(result.targetReps, lessThan(7));
    });

    test('rounds weight to nearest 2.5', () {
      final history = [
        WorkoutSetRecord(
          id: 1,
          date: '2026-04-14',
          exerciseName: 'Bench Press',
          bodyPart: 'Chest',
          weight: 103.0,
          reps: 10,
          targetReps: 10,
        ),
      ];

      final result = calculator.calculate(history);

      expect(result, isNotNull);
      final remainder = result!.targetWeight % 2.5;
      expect(remainder, closeTo(0, 0.01));
    });

    test('reps are clamped between min and max', () {
      final veryHighRepHistory = [
        WorkoutSetRecord(
          id: 1,
          date: '2026-04-14',
          exerciseName: 'Plank',
          bodyPart: 'Core',
          weight: 0,
          reps: 19,
          targetReps: 20,
        ),
      ];

      final result = calculator.calculate(veryHighRepHistory);

      expect(result, isNotNull);
      expect(result!.targetReps, lessThanOrEqualTo(20));
      expect(result.targetReps, greaterThanOrEqualTo(4));
    });

    test('uses last session from history for calculation', () {
      final history = [
        WorkoutSetRecord(
          id: 1,
          date: '2026-04-10',
          exerciseName: 'Squat',
          bodyPart: 'Legs',
          weight: 200.0,
          reps: 5,
          targetReps: 5,
        ),
        WorkoutSetRecord(
          id: 2,
          date: '2026-04-14',
          exerciseName: 'Squat',
          bodyPart: 'Legs',
          weight: 210.0,
          reps: 8,
          targetReps: 10,
        ),
      ];

      final result = calculator.calculate(history);

      expect(result, isNotNull);
      expect(result!.targetWeight, 210.0);
      expect(result.targetReps, lessThan(8));
    });
  });
}
