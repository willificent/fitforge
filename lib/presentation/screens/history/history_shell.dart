import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';
import 'package:fitforge/presentation/screens/history/workout_charts_tab.dart';

class HistoryShell extends ConsumerStatefulWidget {
  const HistoryShell({super.key});

  @override
  ConsumerState<HistoryShell> createState() => _HistoryShellState();
}

class _HistoryShellState extends ConsumerState<HistoryShell>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Diary', icon: Icon(Icons.calendar_month)),
            Tab(text: 'Charts', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_WorkoutDiary(), WorkoutChartsTab()],
      ),
    );
  }
}

class _WorkoutDiary extends ConsumerStatefulWidget {
  const _WorkoutDiary();

  @override
  ConsumerState<_WorkoutDiary> createState() => _WorkoutDiaryState();
}

class _WorkoutDiaryState extends ConsumerState<_WorkoutDiary> {
  DateTime _selectedMonth = DateTime.now();

  String get _monthKey =>
      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month - 1,
                    );
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedMonth),
                style: tt.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<WorkoutSet>>(
            future: ref
                .read(workoutRepositoryProvider)
                .getAllSetsForMonth(_monthKey),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final sets = snapshot.data!;
              if (sets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 48, color: cs.outline),
                      const SizedBox(height: 16),
                      Text(
                        'No workouts this month',
                        style: tt.bodyLarge?.copyWith(color: cs.outline),
                      ),
                    ],
                  ),
                );
              }

              final grouped = <String, List<WorkoutSet>>{};
              for (final set in sets) {
                grouped.putIfAbsent(set.date, () => []).add(set);
              }

              final dates = grouped.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return ListView.builder(
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final daySets = grouped[date]!;
                  final dateObj = DateTime.parse(date);
                  final exerciseNames = daySets
                      .map((s) => s.exerciseName)
                      .toSet()
                      .toList();
                  final totalVolume = daySets.fold(
                    0.0,
                    (sum, s) => sum + s.weight * s.reps,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ExpansionTile(
                      title: Text(DateFormat('EEEE, MMM d').format(dateObj)),
                      subtitle: Text(
                        '${exerciseNames.length} exercises • ${daySets.length} sets • ${totalVolume.toStringAsFixed(0)} lbs',
                      ),
                      leading: CircleAvatar(
                        backgroundColor: cs.primaryContainer,
                        foregroundColor: cs.onPrimaryContainer,
                        child: Text('${dateObj.day}'),
                      ),
                      children: daySets.map((set) {
                        return ListTile(
                          dense: true,
                          title: Text(
                            '${set.exerciseName}: ${set.weight} x ${set.reps.toInt()}',
                          ),
                          subtitle: set.comment != null
                              ? Text(
                                  set.comment!,
                                  style: tt.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : null,
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
