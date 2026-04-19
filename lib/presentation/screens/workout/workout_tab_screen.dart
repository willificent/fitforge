import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/domain/models/workout_generation_request.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class WorkoutTabScreen extends ConsumerStatefulWidget {
  const WorkoutTabScreen({super.key});

  @override
  ConsumerState<WorkoutTabScreen> createState() => _WorkoutTabScreenState();
}

class _WorkoutTabScreenState extends ConsumerState<WorkoutTabScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final selectedDate = ref.watch(selectedDateProvider);
    final dateKey =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final workoutRepo = ref.watch(workoutRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              ref.read(selectedDateProvider.notifier).state = picked;
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat('EEEE, MMM d').format(selectedDate)),
              const SizedBox(width: 4),
              Icon(Icons.calendar_today, size: 18, color: cs.primary),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<WorkoutSet>>(
        stream: workoutRepo.watchSetsForDate(dateKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sets = snapshot.data ?? [];

          if (sets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 48, color: cs.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No exercises planned',
                    style: tt.bodyLarge?.copyWith(color: cs.outline),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add exercises or generate a workout',
                    style: tt.bodyMedium?.copyWith(color: cs.outline),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => _showAddExerciseSheet(context, dateKey),
                    child: const Text('Add Exercise'),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => context.go('/generate'),
                    child: const Text('Generate Workout'),
                  ),
                ],
              ),
            );
          }

          final grouped = <String, List<WorkoutSet>>{};
          for (final set in sets) {
            grouped.putIfAbsent(set.exerciseName, () => []).add(set);
          }

          final exerciseNames = grouped.keys.toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Text(
                      '${exerciseNames.length} exercises • ${sets.length} sets',
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _showAddExerciseSheet(context, dateKey),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onReorder: (oldIndex, newIndex) {
                    _persistReorder(exerciseNames, oldIndex, newIndex);
                  },
                  children: [
                    for (var i = 0; i < exerciseNames.length; i++)
                      _ExerciseSectionCard(
                        key: ValueKey(exerciseNames[i]),
                        exerciseName: exerciseNames[i],
                        sets: grouped[exerciseNames[i]]!,
                        index: i,
                        dateKey: dateKey,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _startWorkout(context, dateKey),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Workout'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _persistReorder(
    List<String> exerciseNames,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex < newIndex) newIndex--;
    final item = exerciseNames.removeAt(oldIndex);
    exerciseNames.insert(newIndex, item);

    final repo = ref.read(workoutRepositoryProvider);
    final dateKey =
        '${ref.read(selectedDateProvider).year}-${ref.read(selectedDateProvider).month.toString().padLeft(2, '0')}-${ref.read(selectedDateProvider).day.toString().padLeft(2, '0')}';
    final allSets = await repo.getSetsForDate(dateKey);

    final updates = <({int id, int order})>[];
    for (var i = 0; i < exerciseNames.length; i++) {
      final name = exerciseNames[i];
      final exerciseSets = allSets.where((s) => s.exerciseName == name);
      for (final set in exerciseSets) {
        updates.add((id: set.id, order: i * 100 + set.id));
      }
    }
    await repo.reorderExercises(updates);
  }

  void _startWorkout(BuildContext context, String dateKey) async {
    final repo = ref.read(workoutRepositoryProvider);
    final exerciseRepo = ref.read(exerciseRepositoryProvider);
    final sets = await repo.getSetsForDate(dateKey);

    if (sets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add exercises first')),
      );
      return;
    }

    final exerciseNames = sets.map((s) => s.exerciseName).toSet().toList();

    final exercises = <GeneratedExercise>[];
    for (final name in exerciseNames) {
      final ex = await exerciseRepo.getByName(name);
      if (ex == null) continue;

      final exerciseSets = sets.where((s) => s.exerciseName == name).toList();
      final target = exerciseSets.isNotEmpty && exerciseSets.last.weight > 0
          ? exerciseSets.last.weight
          : null;
      final targetReps = exerciseSets.isNotEmpty
          ? exerciseSets.last.reps.toInt()
          : null;

      exercises.add(GeneratedExercise(
        name: ex.name,
        muscleGroup: _bodyPartToMuscleGroup(ex.bodyPart),
        difficulty: DifficultyLevel.values.firstWhere(
          (d) => d.name == ex.difficulty,
          orElse: () => DifficultyLevel.beginner,
        ),
        defaultSets: ex.defaultSets,
        defaultReps: ex.defaultReps.split(',').map(int.parse).toList(),
        defaultRestSeconds: ex.defaultRestSeconds,
        equipment: ex.equipment,
        instructions: ex.instructions,
        targetWeight: target,
        targetReps: targetReps,
      ));
    }

    if (exercises.isEmpty) return;

    final workout = GeneratedWorkout(
      id: 'session_$dateKey',
      workoutType: WorkoutType.strength,
      difficulty: DifficultyLevel.intermediate,
      exercises: exercises,
      estimatedDuration: 30,
      caloriesEstimate: 200,
    );

    if (mounted) {
      context.go('/workout-session', extra: {
        'workout': workout,
        'date': dateKey,
      });
    }
  }

  void _showAddExerciseSheet(BuildContext context, String dateKey) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddExerciseBottomSheet(dateKey: dateKey),
    );
  }

  MuscleGroup _bodyPartToMuscleGroup(String bodyPart) {
    return switch (bodyPart.toLowerCase()) {
      'chest' => MuscleGroup.chest,
      'back' => MuscleGroup.back,
      'legs' => MuscleGroup.legs,
      'shoulders' => MuscleGroup.shoulders,
      'biceps' || 'triceps' || 'arms' => MuscleGroup.arms,
      'abs' || 'core' => MuscleGroup.core,
      _ => MuscleGroup.fullBody,
    };
  }
}

class _ExerciseSectionCard extends ConsumerWidget {
  final String exerciseName;
  final List<WorkoutSet> sets;
  final int index;
  final String dateKey;

  const _ExerciseSectionCard({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.index,
    required this.dateKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final ex = await ref
                          .read(exerciseRepositoryProvider)
                          .getByName(exerciseName);
                      if (ex != null && context.mounted) {
                        context.go('/exercise-detail', extra: {'exercise': ex});
                      }
                    },
                    child: Text(
                      exerciseName,
                      style: tt.titleMedium?.copyWith(color: cs.primary),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _deleteExercise(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...sets.asMap().entries.map((entry) {
              final i = entry.key;
              final set = entry.value;
              final isPlanned = set.comment == 'planned';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: InkWell(
                  onTap: () => _editSet(context, ref, set),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${i + 1}',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.weight == 0
                              ? 'x ${set.reps.toInt()}'
                              : '${set.weight} x ${set.reps.toInt()}',
                          style: tt.bodyMedium?.copyWith(
                            color: isPlanned ? cs.outline : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _addSet(context, ref),
                  child: const Text('+ Set'),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () => _editExercise(context, ref),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExercise(BuildContext context, WidgetRef ref) {
    final repo = ref.read(workoutRepositoryProvider);
    for (final set in sets) {
      repo.deleteSet(set.id);
    }
  }

  void _editSet(BuildContext context, WidgetRef ref, WorkoutSet set) {
    final weightCtrl = TextEditingController(text: set.weight.toString());
    final repsCtrl = TextEditingController(text: set.reps.toString());

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Set'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Weight'),
            ),
            TextField(
              controller: repsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final repo = ref.read(workoutRepositoryProvider);
              await repo.deleteSet(set.id);
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(workoutRepositoryProvider);
              await repo.updateSet(
                id: set.id,
                weight: double.tryParse(weightCtrl.text) ?? set.weight,
                reps: double.tryParse(repsCtrl.text) ?? set.reps,
                comment: set.comment == 'planned' &&
                        double.tryParse(weightCtrl.text) != null &&
                        double.tryParse(weightCtrl.text)! > 0
                    ? null
                    : set.comment,
              );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addSet(BuildContext context, WidgetRef ref) async {
    final ex = await ref
        .read(exerciseRepositoryProvider)
        .getByName(exerciseName);
    if (ex == null) return;

    final lastSet = sets.isNotEmpty ? sets.last : null;
    final repo = ref.read(workoutRepositoryProvider);
    await repo.logSet(
      date: dateKey,
      exerciseName: exerciseName,
      bodyPart: ex.bodyPart,
      weight: lastSet?.weight ?? 0,
      reps: lastSet?.reps ?? double.parse(ex.defaultReps.split(',').first.trim()),
      comment: 'planned',
    );
  }

  void _editExercise(BuildContext context, WidgetRef ref) async {
    final ex = await ref
        .read(exerciseRepositoryProvider)
        .getByName(exerciseName);
    if (ex == null || !context.mounted) return;

    context.go('/log-workout', extra: {'exercise': ex, 'date': dateKey, 'returnPath': '/workout'});
  }
}

class _AddExerciseBottomSheet extends ConsumerStatefulWidget {
  final String dateKey;

  const _AddExerciseBottomSheet({required this.dateKey});

  @override
  ConsumerState<_AddExerciseBottomSheet> createState() =>
      _AddExerciseBottomSheetState();
}

class _AddExerciseBottomSheetState
    extends ConsumerState<_AddExerciseBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final exerciseRepo = ref.watch(exerciseRepositoryProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search exercises...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: exerciseRepo.getAll(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final exercises = snapshot.data!.where((e) {
                    if (_searchQuery.isEmpty) return true;
                    return e.name.toLowerCase().contains(_searchQuery) ||
                        e.bodyPart.toLowerCase().contains(_searchQuery);
                  }).toList();

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(exercise.bodyPart),
                        trailing: const Icon(Icons.add),
                        onTap: () async {
                          final repo = ref.read(workoutRepositoryProvider);
                          final reps = exercise.defaultReps
                              .split(',')
                              .map((r) => double.parse(r.trim()))
                              .toList();
                          for (int i = 0; i < exercise.defaultSets; i++) {
                            final rep =
                                i < reps.length ? reps[i] : reps.last;
                            await repo.logSet(
                              date: widget.dateKey,
                              exerciseName: exercise.name,
                              bodyPart: exercise.bodyPart,
                              weight: 0,
                              reps: rep,
                              comment: 'planned',
                            );
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}