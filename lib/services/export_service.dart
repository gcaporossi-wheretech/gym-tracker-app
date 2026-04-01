import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../models/models.dart';

/// Service per esportare i dati di allenamento in JSON e CSV.
class ExportService {
  /// Esporta tutte le sessioni in formato JSON completo
  void exportJson({
    required List<WorkoutSession> sessions,
    required WorkoutPlan? plan,
    required int currentWeek,
    required int currentPhase,
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
      'progressionSummary': _buildSummary(sessions),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    _download(jsonString, 'gymtracker_export_${_dateStamp()}.json', 'application/json');
  }

  /// Esporta tutte le sessioni in formato CSV tabellare
  void exportCsv({required List<WorkoutSession> sessions}) {
    final buffer = StringBuffer();
    buffer.writeln('data,giorno,workout,esercizio,gruppo_muscolare,serie,rep_target,rep_effettive,peso_kg,rpe,note');

    for (final session in sessions) {
      final date = '${session.date.year}-${session.date.month.toString().padLeft(2, '0')}-${session.date.day.toString().padLeft(2, '0')}';
      final dayNames = ['', 'lunedi', 'martedi', 'mercoledi', 'giovedi', 'venerdi', 'sabato', 'domenica'];
      final day = dayNames[session.date.weekday];

      for (final ex in session.exercises) {
        if (ex.skipped) {
          buffer.writeln('$date,$day,${session.workoutName},${_csvEscape(ex.exerciseName)},${ex.muscleGroup},,,,,SALTATO,');
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

    _download(buffer.toString(), 'gymtracker_export_${_dateStamp()}.csv', 'text/csv');
  }

  Map<String, dynamic> _buildSummary(List<WorkoutSession> sessions) {
    final completed = sessions.where((s) => s.completed).length;
    final totalVolume = sessions.fold(0.0, (sum, s) => sum + s.totalVolume);

    final volumeByGroup = <String, double>{};
    for (final session in sessions) {
      for (final ex in session.exercises) {
        if (ex.skipped) continue;
        for (final set in ex.sets) {
          if (!set.completed) continue;
          volumeByGroup[ex.muscleGroup] =
              (volumeByGroup[ex.muscleGroup] ?? 0) + (set.weight * set.actualReps);
        }
      }
    }

    return {
      'totalSessions': sessions.length,
      'completedSessions': completed,
      'completionRate': sessions.isNotEmpty ? completed / sessions.length : 0,
      'totalVolume': totalVolume,
      'volumeByMuscleGroup': volumeByGroup,
    };
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _dateStamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }

  void _download(String content, String filename, String mimeType) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
