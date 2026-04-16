import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/presentation/providers/app_providers.dart';

class WorkoutChartsTab extends ConsumerStatefulWidget {
  const WorkoutChartsTab({super.key});

  @override
  ConsumerState<WorkoutChartsTab> createState() => _WorkoutChartsTabState();
}

class _WorkoutChartsTabState extends ConsumerState<WorkoutChartsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '1M';

  static const _periods = {'1W': 7, '1M': 30, '3M': 90, '6M': 180, '1Y': 365};

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

  DateTime get _startDate {
    final days = _periods[_selectedPeriod] ?? 30;
    return DateTime.now().subtract(Duration(days: days));
  }

  String get _startDateKey {
    final d = _startDate;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text('Period:', style: tt.labelMedium),
              const SizedBox(width: 8),
              ..._periods.keys.map((period) {
                final isSelected = period == _selectedPeriod;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ChoiceChip(
                    label: Text(period),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedPeriod = period),
                  ),
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _VolumeChart(
                startDateKey: _startDateKey,
                period: _selectedPeriod,
              ),
              _ExerciseFrequencyChart(
                startDateKey: _startDateKey,
                period: _selectedPeriod,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VolumeChart extends ConsumerWidget {
  final String startDateKey;
  final String period;

  const _VolumeChart({required this.startDateKey, required this.period});

  String _endDateKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return FutureBuilder<List<WorkoutSet>>(
      future: ref
          .read(workoutRepositoryProvider)
          .getSetsForDateRange(startDateKey, _endDateKey()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final sets = snapshot.data!;
        if (sets.isEmpty) {
          return _buildEmptyState(cs, tt, 'No workout data yet');
        }

        final dailyVolume = <String, double>{};
        for (final set in sets) {
          dailyVolume[set.date] =
              (dailyVolume[set.date] ?? 0) + set.weight * set.reps;
        }

        final dates = dailyVolume.keys.toList()..sort();
        final spots = <FlSpot>[];
        final minY = dailyVolume.values.fold(
          double.infinity,
          (a, b) => a < b ? a : b,
        );
        final maxY = dailyVolume.values.fold(0.0, (a, b) => a > b ? a : b);

        for (int i = 0; i < dates.length; i++) {
          spots.add(FlSpot(i.toDouble(), dailyVolume[dates[i]]!));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Volume Over Time', style: tt.titleMedium),
              Text(
                'Total volume = weight x reps per session',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    minY: minY == maxY ? 0 : null,
                    maxY: maxY * 1.1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: cs.primary,
                        barWidth: 3,
                        dotData: FlDotData(show: spots.length < 15),
                        belowBarData: BarAreaData(
                          show: true,
                          color: cs.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              _formatVolume(value),
                              style: tt.labelSmall,
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatVolume(double value) {
    if (value >= 10000) return '${(value / 1000).toStringAsFixed(0)}k';
    return value.toStringAsFixed(0);
  }
}

class _ExerciseFrequencyChart extends ConsumerWidget {
  final String startDateKey;
  final String period;

  const _ExerciseFrequencyChart({
    required this.startDateKey,
    required this.period,
  });

  String _endDateKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return FutureBuilder<List<WorkoutSet>>(
      future: ref
          .read(workoutRepositoryProvider)
          .getSetsForDateRange(startDateKey, _endDateKey()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final sets = snapshot.data!;
        if (sets.isEmpty) {
          return _buildEmptyState(cs, tt, 'No workout data yet');
        }

        final exerciseCount = <String, int>{};
        for (final set in sets) {
          exerciseCount[set.exerciseName] =
              (exerciseCount[set.exerciseName] ?? 0) + 1;
        }

        final sorted = exerciseCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final top = sorted.take(10).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Top Exercises', style: tt.titleMedium),
              Text(
                'By number of sets in selected period',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: top.first.value.toDouble() * 1.15,
                    barGroups: top.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.value.toDouble(),
                            color: cs.primary,
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...top.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${entry.key + 1}.',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.value.key,
                          style: tt.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${entry.value.value} sets',
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildEmptyState(ColorScheme cs, TextTheme tt, String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bar_chart, size: 64, color: cs.outline),
        const SizedBox(height: 16),
        Text(message, style: tt.titleMedium?.copyWith(color: cs.outline)),
        const SizedBox(height: 8),
        Text(
          'Start logging workouts to see charts',
          style: tt.bodyMedium?.copyWith(color: cs.outline),
        ),
      ],
    ),
  );
}
