import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitforge/core/constants/app_constants.dart';
import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/domain/generator/progressive_target_calculator.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class WorkoutLogScreen extends ConsumerStatefulWidget {
  final Exercise exercise;
  final String date;

  const WorkoutLogScreen({
    super.key,
    required this.exercise,
    required this.date,
  });

  @override
  ConsumerState<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends ConsumerState<WorkoutLogScreen> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _commentController = TextEditingController();

  List<WorkoutSet> _sets = [];
  TargetResult? _target;
  bool _isLoading = true;
  Timer? _restTimer;
  int _restSecondsRemaining = 0;
  bool _restTimerActive = false;

  String get _dateKey => widget.date;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _commentController.dispose();
    _restTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final repo = ref.read(workoutRepositoryProvider);
    final sets = await repo.getSetsForDate(_dateKey);
    final exerciseSets = sets
        .where((s) => s.exerciseName == widget.exercise.name)
        .toList();

    TargetResult? target;
    if (exerciseSets.isNotEmpty) {
      final calculator = ref.read(progressiveTargetProvider);
      target = await calculator.calculateForExercise(
        ref.read(databaseProvider).workoutSetDao,
        widget.exercise.name,
      );
    }

    setState(() {
      _sets = exerciseSets;
      _target = target;
      _isLoading = false;
    });

    _prefillFromTarget();
  }

  void _prefillFromTarget() {
    if (_target != null) {
      _weightController.text = _target!.targetWeight.toStringAsFixed(1);
      _repsController.text = _target!.targetReps.toString();
    } else {
      _weightController.text = '0';
      _repsController.text = widget.exercise.defaultReps
          .split(',')
          .first
          .trim();
    }
  }

  Future<void> _logSet() async {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final reps = double.tryParse(_repsController.text) ?? 0;
    final comment = _commentController.text.isEmpty
        ? null
        : _commentController.text;

    if (weight <= 0 || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid weight and reps')),
      );
      return;
    }

    final repo = ref.read(workoutRepositoryProvider);
    await repo.logSet(
      date: _dateKey,
      exerciseName: widget.exercise.name,
      bodyPart: widget.exercise.bodyPart,
      weight: weight,
      reps: reps,
      comment: comment,
      restSeconds: widget.exercise.defaultRestSeconds,
    );

    _commentController.clear();
    await _loadData();

    _startRestTimer(widget.exercise.defaultRestSeconds);
  }

  void _startRestTimer(int seconds) {
    _restTimer?.cancel();
    setState(() {
      _restSecondsRemaining = seconds;
      _restTimerActive = true;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _restSecondsRemaining--;
      });
      if (_restSecondsRemaining <= 0) {
        timer.cancel();
        setState(() {
          _restTimerActive = false;
          _restSecondsRemaining = 0;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Rest complete!')));
      }
    });
  }

  void _cancelRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _restTimerActive = false;
      _restSecondsRemaining = 0;
    });
  }

  Future<void> _deleteSet(int id) async {
    final repo = ref.read(workoutRepositoryProvider);
    await repo.deleteSet(id);
    await _loadData();
  }

  Future<void> _editSet(WorkoutSet set) async {
    final weightController = TextEditingController(text: set.weight.toString());
    final repsController = TextEditingController(text: set.reps.toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Set'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight'),
            ),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final repo = ref.read(workoutRepositoryProvider);
      await repo.updateSet(
        id: set.id,
        weight: double.tryParse(weightController.text) ?? set.weight,
        reps: double.tryParse(repsController.text) ?? set.reps,
      );
      await _loadData();
    }
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        actions: [
          if (_restTimerActive)
            TextButton(onPressed: _cancelRestTimer, child: const Text('Skip')),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_restTimerActive) _buildRestTimer(cs, tt),
                _buildProgressBar(cs, tt),
                Expanded(child: _buildSetsList(cs, tt)),
                _buildInputCard(cs, tt),
              ],
            ),
    );
  }

  Widget _buildRestTimer(ColorScheme cs, TextTheme tt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: cs.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: cs.onPrimaryContainer),
          const SizedBox(width: 8),
          Text(
            'Rest: ${_formatDuration(_restSecondsRemaining)}',
            style: tt.titleMedium?.copyWith(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ColorScheme cs, TextTheme tt) {
    final defaultSets = widget.exercise.defaultSets;
    final completedSets = _sets.length;
    final progress = defaultSets > 0 ? completedSets / defaultSets : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
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
                '$completedSets / $defaultSets sets',
                style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsList(ColorScheme cs, TextTheme tt) {
    if (_sets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 48, color: cs.outline),
            const SizedBox(height: 16),
            Text(
              'Log your first set!',
              style: tt.bodyLarge?.copyWith(color: cs.outline),
            ),
            if (_target != null) ...[
              const SizedBox(height: 8),
              Text(
                'Target: ${_target!.targetWeight.toStringAsFixed(1)} x ${_target!.targetReps}',
                style: tt.bodyMedium?.copyWith(color: cs.primary),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _sets.length,
      itemBuilder: (context, index) {
        final set = _sets[index];
        final isLast = index == _sets.length - 1;
        return Dismissible(
          key: ValueKey(set.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteSet(set.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: cs.error,
            child: Icon(Icons.delete, color: cs.onError),
          ),
          child: Card(
            color: isLast ? cs.primaryContainer : null,
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: isLast
                    ? cs.primary
                    : cs.surfaceContainerHighest,
                foregroundColor: isLast ? cs.onPrimary : cs.onSurfaceVariant,
                radius: 14,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    '${set.weight} x ${set.reps.toInt()}',
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (set.comment != null && set.comment!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        set.comment!,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _editSet(set),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputCard(ColorScheme cs, TextTheme tt) {
    final unitAsync = ref.watch(unitProvider);
    final unit = unitAsync.valueOrNull ?? AppConstants.defaultUnit;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_target != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Target: ${_target!.targetWeight.toStringAsFixed(1)} $unit x ${_target!.targetReps} reps',
                style: tt.bodySmall?.copyWith(color: cs.primary),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Weight ($unit)',
                    isDense: true,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _logSet,
            icon: const Icon(Icons.add),
            label: const Text('Log Set'),
          ),
        ],
      ),
    );
  }
}
