import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/workout/presentation/workout_today_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/stats/presentation/stats_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/export/presentation/export_screen.dart';
import 'features/profile/presentation/measurements_screen.dart';
import 'repositories/hive_measurement_repository.dart';
import 'repositories/hive_workout_plan_repository.dart';
import 'repositories/hive_session_repository.dart';
import 'services/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Initialize repositories
  final planRepo = HiveWorkoutPlanRepository();
  await planRepo.init();
  final sessionRepo = HiveSessionRepository();
  await sessionRepo.init();
  final measurementRepo = HiveMeasurementRepository();
  await measurementRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        workoutPlanRepositoryProvider.overrideWithValue(planRepo),
        sessionRepositoryProvider.overrideWithValue(sessionRepo),
        measurementRepositoryProvider.overrideWithValue(measurementRepo),
      ],
      child: const GymTrackerApp(),
    ),
  );
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymTracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routes: {
        '/export': (context) => const ExportScreen(),
        '/measurements': (context) => const MeasurementsScreen(),
      },
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  Widget _buildScreen() {
    return switch (_currentIndex) {
      0 => const WorkoutTodayScreen(),
      1 => const HistoryScreen(),
      2 => const StatsScreen(),
      3 => const ProfileScreen(),
      _ => const WorkoutTodayScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Storico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Grafici',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
        ],
      ),
    );
  }
}
