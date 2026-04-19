import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class AddCustomExerciseScreen extends ConsumerStatefulWidget {
  const AddCustomExerciseScreen({super.key});

  @override
  ConsumerState<AddCustomExerciseScreen> createState() =>
      _AddCustomExerciseScreenState();
}

class _AddCustomExerciseScreenState
    extends ConsumerState<AddCustomExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '10, 10, 10');
  final _restController = TextEditingController(text: '90');
  final _equipmentController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _workoutType = 'strength';
  String _difficulty = 'intermediate';
  String _bodyPart = 'Chest';

  static const _bodyParts = [
    'Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Core',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    _equipmentController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Exercise'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Exercise Details', style: tt.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _workoutType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ['strength', 'cardio', 'hiit', 'flexibility']
                    .map((t) => DropdownMenuItem(
                        value: t, child: Text(t[0].toUpperCase() + t.substring(1))))
                    .toList(),
                onChanged: (v) => setState(() => _workoutType = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(),
                ),
                items: ['beginner', 'intermediate', 'advanced']
                    .map((d) => DropdownMenuItem(
                        value: d, child: Text(d[0].toUpperCase() + d.substring(1))))
                    .toList(),
                onChanged: (v) => setState(() => _difficulty = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _bodyPart,
                decoration: const InputDecoration(
                  labelText: 'Body Part',
                  border: OutlineInputBorder(),
                ),
                items: _bodyParts
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (v) => setState(() => _bodyPart = v!),
              ),
              const SizedBox(height: 24),
              Text('Set Configuration', style: tt.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _setsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Default Sets',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repsController,
                decoration: const InputDecoration(
                  labelText: 'Default Reps (comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _restController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rest Between Sets (seconds)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text('Additional Info', style: tt.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _equipmentController,
                decoration: const InputDecoration(
                  labelText: 'Equipment (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Instructions (optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exercise'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(exerciseRepositoryProvider);
    await repo.addCustomExercise(
      name: _nameController.text.trim(),
      bodyPart: _bodyPart,
      workoutType: _workoutType,
      difficulty: _difficulty,
      defaultSets: int.tryParse(_setsController.text) ?? 3,
      defaultReps: _repsController.text,
      defaultRestSeconds: int.tryParse(_restController.text) ?? 90,
      equipment: _equipmentController.text.trim().isEmpty
          ? null
          : _equipmentController.text.trim(),
      instructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise added')),
      );
      Navigator.pop(context);
    }
  }
}