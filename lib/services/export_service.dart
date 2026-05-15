import 'dart:convert';

import '../models/models.dart';

/// Service per esportare i dati di allenamento in JSON e CSV.
/// Il download effettivo avviene nel widget chiamante via callback.
class ExportService {
  /// Genera JSON completo delle sessioni.
  /// [bodyweight] usato come carico per esercizi a corpo libero (weight=0)
  /// nel calcolo del volume effettivo.
  String generateJson({
    required List<WorkoutSession> sessions,
    required WorkoutPlan? plan,
    required int currentWeek,
    required int currentPhase,
    double bodyweight = 75.0,
  }) {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': '1.0.0',
      'planName': plan?.name ?? 'N/A',
      'planStartDate': plan?.startDate.toIso8601String(),
      'currentWeek': currentWeek,
      'currentPhase': currentPhase,
      'totalSessions': sessions.length,
      'sessions': sessions.map((s) => s.toJson()).toList(),
      'progressionSummary': _buildSummary(sessions, bodyweight),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Genera CSV tabellare delle sessioni
  String generateCsv({required List<WorkoutSession> sessions}) {
    final buffer = StringBuffer();
    buffer.writeln('data,giorno,workout,esercizio,gruppo_muscolare,serie,rep_target,rep_effettive,peso_kg,rpe,note');

    final dayNames = ['', 'lunedi', 'martedi', 'mercoledi', 'giovedi', 'venerdi', 'sabato', 'domenica'];

    for (final session in sessions) {
      final date = '${session.date.year}-${session.date.month.toString().padLeft(2, '0')}-${session.date.day.toString().padLeft(2, '0')}';
      final day = dayNames[session.date.weekday];

      for (final ex in session.exercises) {
        if (ex.skipped) {
          buffer.writeln('$date,$day,${_csvEscape(session.workoutName)},${_csvEscape(ex.exerciseName)},${ex.muscleGroup},,,,,SALTATO,');
          continue;
        }
        for (final set in ex.sets) {
          buffer.writeln(
            '$date,$day,${_csvEscape(session.workoutName)},${_csvEscape(ex.exerciseName)},'
            '${ex.muscleGroup},${set.setNumber},${set.plannedReps},'
            '${set.completed ? set.actualReps : ""},'
            '${set.completed ? set.weight : ""},'
            '${set.completed && set.rpe > 0 ? set.rpe : ""},'
            '${_csvEscape(set.notes)}',
          );
        }
      }
    }

    return buffer.toString();
  }

  Map<String, dynamic> _buildSummary(List<WorkoutSession> sessions, double bodyweight) {
    final completed = sessions.where((s) => s.completed).length;
    final totalVolume = sessions.fold(0.0, (sum, s) => sum + s.totalVolume);
    final totalEffectiveVolume = sessions.fold(
      0.0, (sum, s) => sum + s.effectiveVolume(bodyweight));

    final volumeByGroup = <String, double>{};
    final effectiveVolumeByGroup = <String, double>{};
    for (final session in sessions) {
      for (final ex in session.exercises) {
        if (ex.skipped) continue;
        for (final set in ex.sets) {
          if (!set.completed) continue;
          final raw = set.weight * set.actualReps;
          final eff = (set.weight > 0 ? set.weight : bodyweight) * set.actualReps;
          volumeByGroup[ex.muscleGroup] =
              (volumeByGroup[ex.muscleGroup] ?? 0) + raw;
          effectiveVolumeByGroup[ex.muscleGroup] =
              (effectiveVolumeByGroup[ex.muscleGroup] ?? 0) + eff;
        }
      }
    }

    return {
      'totalSessions': sessions.length,
      'completedSessions': completed,
      'completionRate': sessions.isNotEmpty ? completed / sessions.length : 0,
      'totalVolume': totalVolume,
      'totalEffectiveVolume': totalEffectiveVolume,
      'bodyweightUsed': bodyweight,
      'volumeByMuscleGroup': volumeByGroup,
      'effectiveVolumeByMuscleGroup': effectiveVolumeByGroup,
    };
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
