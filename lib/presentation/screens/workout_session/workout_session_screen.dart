import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/domain/models/workout_generation_request.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final GeneratedWorkout workout;
  final String date;

  const WorkoutSessionScreen({
    super.key,
    required this.workout,
    required this.date,
  });

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  final Set<int> _completedExercises = {};
  bool _isFinished = false;

  List<GeneratedExercise> get _exercises => widget.workout.exercises;
  GeneratedExercise get _currentExercise => _exercises[_currentExerciseIndex];
  bool get _isLastExercise => _currentExerciseIndex == _exercises.length - 1;
  double get _progress =>
      _exercises.isEmpty ? 0 : _completedExercises.length / _exercises.length;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return PopScope(
      canPop: _isFinished,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isFinished) {
          _showExitConfirmDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Exercise ${_currentExerciseIndex + 1} of ${_exercises.length}',
          ),
          actions: [
            TextButton(
              onPressed: () => _showExitConfirmDialog(context),
              child: const Text('Exit'),
            ),
          ],
        ),
        body: _isFinished
            ? _buildFinishedView(cs, tt)
            : _buildExerciseView(cs, tt),
      ),
    );
  }

  Widget _buildExerciseView(ColorScheme cs, TextTheme tt) {
    final exercise = _currentExercise;
    final exerciseFuture = ref
        .read(exerciseRepositoryProvider)
        .getByName(exercise.name);

    return FutureBuilder<Exercise?>(
      future: exerciseFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final dbExercise = snapshot.data;
        if (dbExercise == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: cs.error),
                const SizedBox(height: 16),
                Text('Exercise not found: ${exercise.name}'),
                const SizedBox(height: 8),
                FilledButton(onPressed: _skipToNext, child: const Text('Skip')),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressBar(cs, tt),
              const SizedBox(height: 24),
              _buildExerciseHeader(exercise, cs, tt),
              const SizedBox(height: 16),
              if (exercise.instructions != null) ...[
                _buildInstructions(exercise, cs, tt),
                const SizedBox(height: 16),
              ],
              if (exercise.equipment != null) ...[
                _buildInfoRow(
                  Icons.fitness_center,
                  'Equipment',
                  exercise.equipment!,
                  cs,
                  tt,
                ),
                const SizedBox(height: 8),
              ],
              _buildInfoRow(
                Icons.repeat,
                'Sets',
                '${exercise.defaultSets} sets',
                cs,
                tt,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.format_list_numbered,
                'Reps',
                exercise.defaultReps.join(', '),
                cs,
                tt,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.timer,
                'Rest',
                '${exercise.defaultRestSeconds}s between sets',
                cs,
                tt,
              ),
              if (exercise.targetWeight != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.trending_up,
                  'Target',
                  '${exercise.targetWeight!.toStringAsFixed(1)} x ${exercise.targetReps} reps',
                  cs,
                  tt,
                  isHighlight: true,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => _navigateToLogScreen(dbExercise),
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: const Text('Start Exercise', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 8),
              if (!_isLastExercise)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _skipToNext,
                    child: const Text('Skip This Exercise'),
                  ),
                ),
              if (_completedExercises.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildCompletedList(cs, tt),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            Text(
              '${_completedExercises.length} / ${_exercises.length} completed',
              style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress.clamp(0.0, 1.0),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseHeader(
    GeneratedExercise exercise,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
              radius: 24,
              child: Text(
                '${_currentExerciseIndex + 1}',
                style: tt.headlineSmall,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name, style: tt.titleLarge),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _difficultyColor(
                            exercise.difficulty,
                            cs,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          exercise.difficulty.name,
                          style: tt.labelSmall?.copyWith(
                            color: _difficultyColor(exercise.difficulty, cs),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _muscleGroupLabel(exercise.muscleGroup),
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions(
    GeneratedExercise exercise,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 20, color: cs.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                exercise.instructions!,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ColorScheme cs,
    TextTheme tt, {
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isHighlight ? cs.primary : cs.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: tt.bodyMedium?.copyWith(
              color: isHighlight ? cs.primary : cs.onSurface,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedList(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Completed', style: tt.titleSmall),
        const SizedBox(height: 8),
        ..._completedExercises.map((index) {
          final ex = _exercises[index];
          return ListTile(
            dense: true,
            leading: Icon(Icons.check_circle, color: cs.primary, size: 20),
            title: Text(ex.name, style: tt.bodyMedium),
            trailing: Text(
              '${ex.defaultSets} sets',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFinishedView(ColorScheme cs, TextTheme tt) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration, size: 64, color: cs.primary),
            const SizedBox(height: 24),
            Text('Workout Complete!', style: tt.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'You completed ${_completedExercises.length} of ${_exercises.length} exercises',
              style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.workout.estimatedDuration} min • ${widget.workout.caloriesEstimate} est. calories',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/workout'),
              icon: const Icon(Icons.assignment),
              label: const Text('Back to Workout'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogScreen(Exercise dbExercise) async {
    final logged = await context.push<bool>(
      '/log-workout',
      extra: {'exercise': dbExercise, 'date': widget.date},
    );

    if (logged == true || logged == null) {
      setState(() {
        _completedExercises.add(_currentExerciseIndex);
      });

      if (_isLastExercise) {
        setState(() => _isFinished = true);
      } else {
        _skipToNext();
      }
    }
  }

  void _skipToNext() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    } else {
      setState(() => _isFinished = true);
    }
  }

  void _showExitConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Workout?'),
        content: Text(
          'You\'ve completed ${_completedExercises.length} of ${_exercises.length} exercises. '
          'Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/workout');
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Color _difficultyColor(DifficultyLevel difficulty, ColorScheme cs) {
    return switch (difficulty) {
      DifficultyLevel.beginner => Colors.green,
      DifficultyLevel.intermediate => Colors.orange,
      DifficultyLevel.advanced => Colors.red,
    };
  }

  String _muscleGroupLabel(MuscleGroup mg) {
    return switch (mg) {
      MuscleGroup.chest => 'Chest',
      MuscleGroup.back => 'Back',
      MuscleGroup.legs => 'Legs',
      MuscleGroup.shoulders => 'Shoulders',
      MuscleGroup.arms => 'Arms',
      MuscleGroup.core => 'Core',
      MuscleGroup.fullBody => 'Full Body',
    };
  }
}
