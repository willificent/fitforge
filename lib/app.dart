import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitforge/data/database/app_database.dart';
import 'package:fitforge/domain/models/workout_generation_request.dart';
import 'package:fitforge/presentation/screens/home/home_screen.dart';
import 'package:fitforge/presentation/screens/workout/workout_tab_screen.dart';
import 'package:fitforge/presentation/screens/generate_workout/generate_workout_screen.dart';
import 'package:fitforge/presentation/screens/exercise_browser/exercise_browser_screen.dart';
import 'package:fitforge/presentation/screens/exercise_detail/exercise_detail_screen.dart';
import 'package:fitforge/presentation/screens/history/history_shell.dart';
import 'package:fitforge/presentation/screens/settings/settings_screen.dart';
import 'package:fitforge/presentation/screens/log_workout/workout_log_screen.dart';
import 'package:fitforge/presentation/screens/workout_session/workout_session_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _historyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'history');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workout',
              builder: (context, state) => const WorkoutTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/generate',
              builder: (context, state) => const GenerateWorkoutScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/exercises',
              builder: (context, state) => const ExerciseBrowserScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _historyNavigatorKey,
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryShell(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/log-workout',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return WorkoutLogScreen(
          exercise: extra['exercise'] as Exercise,
          date: extra['date'] as String,
          returnPath: extra['returnPath'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/workout-session',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return WorkoutSessionScreen(
          workout: extra['workout'] as GeneratedWorkout,
          date: extra['date'] as String,
        );
      },
    ),
    GoRoute(
      path: '/exercise-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return ExerciseDetailScreen(exercise: extra['exercise'] as Exercise);
      },
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Generate',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}