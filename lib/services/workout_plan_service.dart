import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';
import '../repositories/workout_plan_repository.dart';

/// Service per caricare, gestire e calcolare la periodizzazione
/// delle schede di allenamento.
class WorkoutPlanService {
  WorkoutPlanService(this._repository);

  final WorkoutPlanRepository _repository;

  /// Carica la scheda di default dagli asset dell'app
  Future<WorkoutPlan> loadDefaultPlan() async {
    final jsonString =
        await rootBundle.loadString('assets/data/scheda_aprile_2026.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final plan = WorkoutPlan.fromJson(json);
    await _repository.savePlan(plan);
    return plan;
  }

  /// Restituisce la scheda attiva, o carica quella di default
  Future<WorkoutPlan> getOrLoadActivePlan() async {
    final existing = await _repository.getActivePlan();
    if (existing != null) return existing;
    return loadDefaultPlan();
  }

  /// Restituisce il DayPlan per un giorno della settimana (1=lun, 5=ven)
  DayPlan? getDayPlan(WorkoutPlan plan, int dayOfWeek) {
    final matches = plan.days.where((d) => d.dayOfWeek == dayOfWeek);
    return matches.isEmpty ? null : matches.first;
  }

  /// Restituisce il DayPlan per oggi
  DayPlan? getTodayPlan(WorkoutPlan plan) {
    final today = DateTime.now().weekday; // 1=Monday, 7=Sunday
    return getDayPlan(plan, today);
  }

  /// Calcola la settimana corrente (1-12) dalla data di inizio
  int getCurrentWeek(WorkoutPlan plan) {
    final now = DateTime.now();
    final diff = now.difference(plan.startDate).inDays;
    final week = (diff ~/ 7) + 1;
    return week.clamp(1, plan.totalWeeks);
  }

  /// Calcola la fase corrente (1-3) dalla settimana
  Phase? getCurrentPhase(WorkoutPlan plan) {
    final week = getCurrentWeek(plan);
    for (final phase in plan.phases) {
      if (week >= phase.weekStart && week <= phase.weekEnd) {
        return phase;
      }
    }
    return plan.phases.isNotEmpty ? plan.phases.last : null;
  }

  /// Verifica se e una settimana di deload
  bool isDeloadWeek(WorkoutPlan plan) {
    final week = getCurrentWeek(plan);
    return week == 4 || week == 8 || week == 12;
  }

  /// Restituisce un riepilogo della posizione nel programma
  ProgramPosition getProgramPosition(WorkoutPlan plan) {
    final week = getCurrentWeek(plan);
    final phase = getCurrentPhase(plan);
    final isDeload = isDeloadWeek(plan);
    return ProgramPosition(
      week: week,
      totalWeeks: plan.totalWeeks,
      phase: phase,
      isDeload: isDeload,
    );
  }
}

/// Posizione corrente nel programma di allenamento
class ProgramPosition {
  const ProgramPosition({
    required this.week,
    required this.totalWeeks,
    required this.phase,
    required this.isDeload,
  });

  final int week;
  final int totalWeeks;
  final Phase? phase;
  final bool isDeload;

  double get progressPercentage => week / totalWeeks;
}
