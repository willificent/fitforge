import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _pageController;
  static const int _initialPage = 365 * 5;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _pageController = PageController(initialPage: _initialPage);
    ref.read(exerciseSeedProvider);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getDateFromPageIndex(int index) {
    final now = DateTime.now();
    final difference = index - _initialPage;
    return DateTime(now.year, now.month, now.day + difference);
  }

  int _getPageIndexFromDate(DateTime date) {
    final now = DateTime.now();
    final selected = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    return _initialPage + selected.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatDate(_selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _pageController.animateToPage(
                _initialPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateCarousel(cs),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedDate = _getDateFromPageIndex(index);
                });
              },
              itemBuilder: (context, index) {
                final date = _getDateFromPageIndex(index);
                return _WorkoutDayView(date: date);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateCarousel(ColorScheme cs) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 31,
        controller: ScrollController(initialScrollOffset: 15 * 66.0),
        itemBuilder: (context, index) {
          final now = DateTime.now();
          final date = DateTime(now.year, now.month, now.day + (index - 15));
          final isToday =
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
          final isSelected =
              date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              _pageController.animateToPage(
                _getPageIndexFromDate(date),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 62,
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : null,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(color: cs.primary, width: 1)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (target == today.add(const Duration(days: 1))) return 'Tomorrow';
    return DateFormat('EEE, MMM d').format(date);
  }

  void _showAddExerciseSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddExerciseSheet(
        onExerciseSelected: (exercise) {
          final dateKey =
              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
          context.go(
            '/log-workout',
            extra: {'exercise': exercise, 'date': dateKey},
          );
        },
      ),
    );
  }
}

class _WorkoutDayView extends ConsumerWidget {
  final DateTime date;

  const _WorkoutDayView({required this.date});

  String get _dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutRepo = ref.watch(workoutRepositoryProvider);
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<WorkoutSet>>(
      stream: workoutRepo.watchSetsForDate(_dateKey),
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
                  'No workouts logged',
                  style: TextStyle(color: cs.outline, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add an exercise',
                  style: TextStyle(color: cs.outline, fontSize: 14),
                ),
              ],
            ),
          );
        }

        final grouped = <String, List<WorkoutSet>>{};
        for (final set in sets) {
          grouped.putIfAbsent(set.exerciseName, () => []).add(set);
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: grouped.entries.map((entry) {
            return _ExerciseCard(exerciseName: entry.key, sets: entry.value);
          }).toList(),
        );
      },
    );
  }
}

class _ExerciseCard extends ConsumerWidget {
  final String exerciseName;
  final List<WorkoutSet> sets;

  const _ExerciseCard({required this.exerciseName, required this.sets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

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
                      final exercise = await ref
                          .read(exerciseRepositoryProvider)
                          .getByName(exerciseName);
                      if (exercise != null && context.mounted) {
                        context.go(
                          '/exercise-detail',
                          extra: {'exercise': exercise},
                        );
                      }
                    },
                    child: Text(
                      exerciseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${sets.length} ${sets.length == 1 ? 'set' : 'sets'}',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...sets.asMap().entries.map((entry) {
              final i = entry.key;
              final set = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${set.weight} x ${set.reps}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (set.comment != null)
                      Text(
                        set.comment!,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  final void Function(Exercise exercise) onExerciseSelected;

  const _AddExerciseSheet({required this.onExerciseSelected});

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
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
                        onTap: () {
                          Navigator.pop(context);
                          widget.onExerciseSelected(exercise);
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
