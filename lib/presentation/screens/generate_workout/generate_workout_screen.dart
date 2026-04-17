import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fitforge/domain/models/workout_generation_request.dart';
import 'package:fitforge/domain/generator/progressive_target_calculator.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class GenerateWorkoutScreen extends ConsumerStatefulWidget {
  const GenerateWorkoutScreen({super.key});

  @override
  ConsumerState<GenerateWorkoutScreen> createState() =>
      _GenerateWorkoutScreenState();
}

class _GenerateWorkoutScreenState extends ConsumerState<GenerateWorkoutScreen> {
  WorkoutType _selectedType = WorkoutType.strength;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.intermediate;
  int _selectedDuration = 30;
  List<MuscleGroup> _selectedMuscles = [];
  GeneratedWorkout? _generatedWorkout;
  bool _isGenerating = false;
  DateTime _selectedDate = DateTime.now();

  String get _dateKey {
    return '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate Workout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Date', tt),
            const SizedBox(height: 8),
            _buildDateSelector(cs, tt),
            const SizedBox(height: 16),
            _buildSectionTitle('Workout Type', tt),
            const SizedBox(height: 8),
            _buildChipRow(
              options: WorkoutType.values,
              selected: _selectedType,
              labelBuilder: (t) => _workoutTypeLabel(t),
              onSelected: (t) => setState(() => _selectedType = t),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Difficulty', tt),
            const SizedBox(height: 8),
            _buildChipRow(
              options: DifficultyLevel.values,
              selected: _selectedDifficulty,
              labelBuilder: (d) => _difficultyLabel(d),
              onSelected: (d) => setState(() => _selectedDifficulty = d),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Duration (minutes)', tt),
            const SizedBox(height: 8),
            _buildDurationSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Target Muscles (optional)', tt),
            const SizedBox(height: 8),
            _buildMuscleGroupSelector(cs),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isGenerating ? null : _generate,
              child: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Generate Workout'),
            ),
            if (_generatedWorkout != null) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Generated Workout', tt),
              const SizedBox(height: 8),
              _buildWorkoutSummary(cs, tt),
              const SizedBox(height: 16),
              _buildExerciseList(cs, tt),
              const SizedBox(height: 16),
              _buildPostGenerationActions(cs, tt),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextTheme tt) {
    return Text(title, style: tt.titleMedium);
  }

  Widget _buildDateSelector(ColorScheme cs, TextTheme tt) {
    final isToday = _isSameDay(_selectedDate, DateTime.now());
    final label = isToday
        ? 'Today'
        : DateFormat('EEE, MMM d, yyyy').format(_selectedDate);

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: tt.bodyLarge),
            const Spacer(),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildChipRow<T>({
    required List<T> options,
    required T selected,
    required String Function(T) labelBuilder,
    required void Function(T) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        return ChoiceChip(
          label: Text(labelBuilder(option)),
          selected: option == selected,
          onSelected: (_) => onSelected(option),
        );
      }).toList(),
    );
  }

  Widget _buildDurationSelector() {
    return Slider(
      value: _selectedDuration.toDouble(),
      min: 15,
      max: 60,
      divisions: 9,
      label: '${_selectedDuration} min',
      onChanged: (v) => setState(() => _selectedDuration = v.round()),
    );
  }

  Widget _buildMuscleGroupSelector(ColorScheme cs) {
    return Wrap(
      spacing: 8,
      children: MuscleGroup.values.map((mg) {
        final isSelected = _selectedMuscles.contains(mg);
        return FilterChip(
          label: Text(_muscleGroupLabel(mg)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedMuscles.add(mg);
              } else {
                _selectedMuscles.remove(mg);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutSummary(ColorScheme cs, TextTheme tt) {
    final w = _generatedWorkout!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.timer, color: cs.primary),
            const SizedBox(width: 8),
            Text('${w.estimatedDuration} min', style: tt.bodyLarge),
            const SizedBox(width: 16),
            Icon(Icons.local_fire_department, color: cs.primary),
            const SizedBox(width: 8),
            Text('${w.caloriesEstimate} cal', style: tt.bodyLarge),
            const SizedBox(width: 16),
            Icon(Icons.fitness_center, color: cs.primary),
            const SizedBox(width: 8),
            Text('${w.exercises.length} exercises', style: tt.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList(ColorScheme cs, TextTheme tt) {
    final exercises = _generatedWorkout!.exercises;
    return Column(
      children: exercises.asMap().entries.map((entry) {
        final i = entry.key;
        final ex = entry.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
              radius: 16,
              child: Text('${i + 1}', style: const TextStyle(fontSize: 12)),
            ),
            title: Text(ex.name),
            subtitle: Text(
              '${ex.defaultSets} sets x ${ex.defaultReps.join(", ")} reps',
            ),
            trailing: ex.targetWeight != null && ex.targetWeight! > 0
                ? Text(
                    '${ex.targetWeight!.toStringAsFixed(1)} x ${ex.targetReps}',
                    style: tt.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPostGenerationActions(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: _addToCalendarAndStart,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Workout'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addToCalendarAndView,
          icon: const Icon(Icons.calendar_today),
          label: const Text('Add to Calendar'),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _regenerate,
          icon: const Icon(Icons.refresh),
          label: const Text('Create Another Workout'),
        ),
      ],
    );
  }

  Future<void> _addToCalendarAndStart() async {
    await _addExercisesToCalendar();
    if (mounted) {
      ref.read(selectedDateProvider.notifier).state = _selectedDate;
      context.go('/workout');
    }
  }

  Future<void> _addToCalendarAndView() async {
    await _addExercisesToCalendar();
    if (mounted) {
      ref.read(selectedDateProvider.notifier).state = _selectedDate;
      context.go('/workout');
    }
  }

  Future<void> _addExercisesToCalendar() async {
    final repo = ref.read(workoutRepositoryProvider);
    final exercises = _generatedWorkout!.exercises.map((ex) {
      return (
        name: ex.name,
        bodyPart: _muscleGroupLabel(ex.muscleGroup),
        sets: ex.defaultSets,
        reps: ex.defaultReps.join(', '),
      );
    }).toList();

    await repo.addPlannedExercises(
      date: _dateKey,
      exercises: exercises,
    );
  }

  Future<void> _generate() async {
    setState(() => _isGenerating = true);

    try {
      final generator = ref.read(workoutGeneratorProvider);
      final request = WorkoutGenerationRequest(
        workoutType: _selectedType,
        duration: _selectedDuration,
        difficulty: _selectedDifficulty,
        targetMuscles: _selectedMuscles.isEmpty ? null : _selectedMuscles,
      );

      final workout = await generator.generate(request);

      final calculator = ref.read(progressiveTargetProvider);
      final db = ref.read(databaseProvider);

      final enrichedExercises = <GeneratedExercise>[];
      for (final ex in workout.exercises) {
        TargetResult? target;
        try {
          target = await calculator.calculateForExercise(
            db.workoutSetDao,
            ex.name,
          );
        } catch (_) {}

        enrichedExercises.add(
          ex.copyWith(
            targetWeight: target?.targetWeight,
            targetReps: target?.targetReps,
          ),
        );
      }

      setState(() {
        _generatedWorkout = workout.copyWith(exercises: enrichedExercises);
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating workout: $e')),
        );
      }
    }
  }

  void _regenerate() {
    setState(() {
      _generatedWorkout = null;
    });
    _generate();
  }

  String _workoutTypeLabel(WorkoutType t) {
    return switch (t) {
      WorkoutType.strength => 'Strength',
      WorkoutType.cardio => 'Cardio',
      WorkoutType.hiit => 'HIIT',
      WorkoutType.flexibility => 'Flexibility',
      WorkoutType.mixed => 'Mixed',
    };
  }

  String _difficultyLabel(DifficultyLevel d) {
    return switch (d) {
      DifficultyLevel.beginner => 'Beginner',
      DifficultyLevel.intermediate => 'Intermediate',
      DifficultyLevel.advanced => 'Advanced',
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