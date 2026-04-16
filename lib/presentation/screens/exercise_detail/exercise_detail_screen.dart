import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  String get _dateKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          IconButton(
            icon: Icon(
              exercise.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: exercise.isFavorite ? cs.primary : null,
            ),
            onPressed: () async {
              await ref
                  .read(exerciseRepositoryProvider)
                  .toggleFavorite(exercise.name, !exercise.isFavorite);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      exercise.isFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(cs, tt),
            const SizedBox(height: 16),
            _buildDetails(cs, tt),
            if (exercise.instructions != null) ...[
              const SizedBox(height: 16),
              _buildInstructions(cs, tt),
            ],
            const SizedBox(height: 16),
            _buildPersonalRecords(ref, cs, tt),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.go(
                    '/log-workout',
                    extra: {'exercise': exercise, 'date': _dateKey},
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Log This Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs, TextTheme tt) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _typeColor(
                      exercise.workoutType,
                      cs,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exercise.workoutType.toUpperCase(),
                    style: tt.labelMedium?.copyWith(
                      color: _typeColor(exercise.workoutType, cs),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _difficultyColor(
                      exercise.difficulty,
                      cs,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exercise.difficulty,
                    style: tt.labelMedium?.copyWith(
                      color: _difficultyColor(exercise.difficulty, cs),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(exercise.bodyPart, style: tt.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(ColorScheme cs, TextTheme tt) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(
              Icons.repeat,
              'Sets',
              '${exercise.defaultSets}',
              cs,
              tt,
            ),
            const Divider(),
            _buildDetailRow(
              Icons.format_list_numbered,
              'Reps',
              exercise.defaultReps,
              cs,
              tt,
            ),
            const Divider(),
            _buildDetailRow(
              Icons.timer,
              'Rest',
              '${exercise.defaultRestSeconds}s',
              cs,
              tt,
            ),
            if (exercise.equipment != null) ...[
              const Divider(),
              _buildDetailRow(
                Icons.fitness_center,
                'Equipment',
                exercise.equipment!,
                cs,
                tt,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const Spacer(),
          Text(
            value,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(ColorScheme cs, TextTheme tt) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text('Instructions', style: tt.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exercise.instructions!,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalRecords(WidgetRef ref, ColorScheme cs, TextTheme tt) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text('Personal Records', style: tt.titleSmall),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<WorkoutSet?>(
              future: ref
                  .read(workoutRepositoryProvider)
                  .getLastSetForExercise(exercise.name),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text(
                    'No records yet',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  );
                }
                final last = snapshot.data!;
                return Column(
                  children: [
                    _buildDetailRow(
                      Icons.trending_up,
                      'Last Weight',
                      '${last.weight}',
                      cs,
                      tt,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      Icons.repeat,
                      'Last Reps',
                      '${last.reps.toInt()}',
                      cs,
                      tt,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      Icons.calculate,
                      'Est. 1RM',
                      '${(last.weight * (1 + last.reps / 30)).toStringAsFixed(1)}',
                      cs,
                      tt,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Last Done',
                      last.date,
                      cs,
                      tt,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String type, ColorScheme cs) {
    return switch (type) {
      'strength' => Colors.deepPurple,
      'cardio' => Colors.blue,
      'hiit' => Colors.red,
      'flexibility' => Colors.teal,
      _ => cs.primary,
    };
  }

  Color _difficultyColor(String difficulty, ColorScheme cs) {
    return switch (difficulty) {
      'beginner' => Colors.green,
      'intermediate' => Colors.orange,
      'advanced' => Colors.red,
      _ => cs.outline,
    };
  }
}
