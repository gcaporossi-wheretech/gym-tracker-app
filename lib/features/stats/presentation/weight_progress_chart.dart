import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';

/// Grafico line chart: progressione carico per esercizio nel tempo.
/// L'utente seleziona l'esercizio dal dropdown.
class WeightProgressChart extends StatefulWidget {
  const WeightProgressChart({super.key, required this.sessions});
  final List<WorkoutSession> sessions;

  @override
  State<WeightProgressChart> createState() => _WeightProgressChartState();
}

class _WeightProgressChartState extends State<WeightProgressChart> {
  String? _selectedExercise;

  /// Raccoglie tutti i nomi degli esercizi unici dalle sessioni
  List<String> get _exerciseNames {
    final names = <String>{};
    for (final session in widget.sessions) {
      for (final ex in session.exercises) {
        if (!ex.skipped && ex.sets.any((s) => s.completed)) {
          names.add(ex.exerciseName);
        }
      }
    }
    final sorted = names.toList()..sort();
    return sorted;
  }

  /// Dati per il grafico: data -> peso massimo usato
  List<_WeightDataPoint> get _dataPoints {
    if (_selectedExercise == null) return [];

    final points = <_WeightDataPoint>[];
    final sorted = widget.sessions.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final session in sorted) {
      for (final ex in session.exercises) {
        if (ex.exerciseName == _selectedExercise && !ex.skipped) {
          final completedSets = ex.sets.where((s) => s.completed);
          if (completedSets.isNotEmpty) {
            final maxWeight = completedSets
                .map((s) => s.weight)
                .reduce((a, b) => a > b ? a : b);
            points.add(_WeightDataPoint(date: session.date, weight: maxWeight));
          }
        }
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _exerciseNames;
    if (exercises.isEmpty) {
      return const GlassmorphismCard(
        child: Text('Nessun dato disponibile.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    _selectedExercise ??= exercises.first;
    final data = _dataPoints;

    return GlassmorphismCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown esercizio
          DropdownButton<String>(
            value: _selectedExercise,
            isExpanded: true,
            dropdownColor: AppColors.bgElevated,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            items: exercises.map((name) {
              return DropdownMenuItem(value: name, child: Text(name, overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged: (val) => setState(() => _selectedExercise = val),
          ),
          const SizedBox(height: AppSpacing.md),

          // Chart
          if (data.length < 2)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'Servono almeno 2 sessioni\nper vedere il grafico.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calcInterval(data),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.bgElevated,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.weight);
                      }).toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final point = data[spot.spotIndex];
                          return LineTooltipItem(
                            '${point.weight.toStringAsFixed(1)} kg\n${point.date.day}/${point.date.month}',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _calcInterval(List<_WeightDataPoint> data) {
    if (data.isEmpty) return 10;
    final max = data.map((d) => d.weight).reduce((a, b) => a > b ? a : b);
    final min = data.map((d) => d.weight).reduce((a, b) => a < b ? a : b);
    final range = max - min;
    if (range <= 10) return 2;
    if (range <= 30) return 5;
    return 10;
  }
}

class _WeightDataPoint {
  const _WeightDataPoint({required this.date, required this.weight});
  final DateTime date;
  final double weight;
}
