import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class ExerciseBrowserScreen extends ConsumerStatefulWidget {
  const ExerciseBrowserScreen({super.key});

  @override
  ConsumerState<ExerciseBrowserScreen> createState() =>
      _ExerciseBrowserScreenState();
}

class _ExerciseBrowserScreenState extends ConsumerState<ExerciseBrowserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  static const _bodyParts = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Full Body',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _bodyParts.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _dateKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final exerciseRepo = ref.watch(exerciseRepositoryProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddCustomExerciseDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _bodyParts.map((p) => Tab(text: p)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _bodyParts.map((bodyPart) {
                return FutureBuilder<List<Exercise>>(
                  future: bodyPart == 'All'
                      ? exerciseRepo.getAll()
                      : exerciseRepo.getByBodyPart(bodyPart),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var exercises = snapshot.data!;
                    if (_searchQuery.isNotEmpty) {
                      exercises = exercises
                          .where(
                            (e) =>
                                e.name.toLowerCase().contains(_searchQuery) ||
                                e.bodyPart.toLowerCase().contains(_searchQuery),
                          )
                          .toList();
                    }

                    if (exercises.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: cs.outline),
                            const SizedBox(height: 16),
                            Text(
                              'No exercises found',
                              style: TextStyle(color: cs.outline),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return _ExerciseTile(
                          exercise: exercise,
                          onTap: () => _navigateToLog(context, exercise),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLog(BuildContext context, Exercise exercise) {
    context.go('/log-workout', extra: {'exercise': exercise, 'date': _dateKey});
  }

  void _showAddCustomExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final bodyPartController = TextEditingController();
    final setsController = TextEditingController(text: '3');
    final repsController = TextEditingController(text: '10, 10, 10');
    final restController = TextEditingController(text: '90');
    final equipmentController = TextEditingController();
    final instructionsController = TextEditingController();
    String workoutType = 'strength';
    String difficulty = 'intermediate';

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Custom Exercise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name *'),
                ),
                DropdownButtonFormField<String>(
                  value: workoutType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: ['strength', 'cardio', 'hiit', 'flexibility']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => workoutType = v!),
                ),
                DropdownButtonFormField<String>(
                  value: difficulty,
                  decoration: const InputDecoration(labelText: 'Difficulty'),
                  items: ['beginner', 'intermediate', 'advanced']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => difficulty = v!),
                ),
                DropdownButtonFormField<String>(
                  value: 'Chest',
                  decoration: const InputDecoration(labelText: 'Body Part'),
                  items: ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Core']
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  onChanged: (v) => bodyPartController.text = v!,
                ),
                TextField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Default Sets'),
                ),
                TextField(
                  controller: repsController,
                  decoration: const InputDecoration(
                    labelText: 'Default Reps (comma-separated)',
                  ),
                ),
                TextField(
                  controller: restController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Rest (seconds)'),
                ),
                TextField(
                  controller: equipmentController,
                  decoration: const InputDecoration(labelText: 'Equipment (optional)'),
                ),
                TextField(
                  controller: instructionsController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Instructions (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                final repo = ref.read(exerciseRepositoryProvider);
                await repo.addCustomExercise(
                  name: nameController.text,
                  bodyPart: bodyPartController.text.isEmpty
                      ? 'Chest'
                      : bodyPartController.text,
                  workoutType: workoutType,
                  difficulty: difficulty,
                  defaultSets: int.tryParse(setsController.text) ?? 3,
                  defaultReps: repsController.text,
                  defaultRestSeconds: int.tryParse(restController.text) ?? 90,
                  equipment: equipmentController.text.isEmpty
                      ? null
                      : equipmentController.text,
                  instructions: instructionsController.text.isEmpty
                      ? null
                      : instructionsController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exercise added')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseTile({required this.exercise, required this.onTap});

  Color _difficultyColor(String difficulty, ColorScheme cs) {
    return switch (difficulty) {
      'beginner' => Colors.green,
      'intermediate' => Colors.orange,
      'advanced' => Colors.red,
      _ => cs.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ListTile(
      title: Text(exercise.name, style: tt.bodyLarge),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _difficultyColor(
                exercise.difficulty,
                cs,
              ).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              exercise.difficulty,
              style: tt.labelSmall?.copyWith(
                color: _difficultyColor(exercise.difficulty, cs),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            exercise.bodyPart,
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          if (exercise.equipment != null) ...[
            const SizedBox(width: 8),
            Text(
              exercise.equipment!,
              style: tt.bodySmall?.copyWith(color: cs.outline),
            ),
          ],
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outlined),
        onPressed: onTap,
      ),
      onTap: () =>
          context.go('/exercise-detail', extra: {'exercise': exercise}),
    );
  }
}
