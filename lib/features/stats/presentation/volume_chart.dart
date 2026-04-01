import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';

/// Bar chart: volume totale per gruppo muscolare (somma di tutte le sessioni).
class VolumeChart extends StatelessWidget {
  const VolumeChart({super.key, required this.sessions});
  final List<WorkoutSession> sessions;

  static const _muscleGroupColors = {
    'chest': AppColors.primary,
    'back': Color(0xFF9B59B6),
    'legs': Color(0xFF2ECC71),
    'shoulders': AppColors.warning,
    'biceps': Color(0xFFE74C3C),
    'triceps': Color(0xFFE67E22),
    'core': Color(0xFF1ABC9C),
    'glutes': Color(0xFFF39C12),
    'calves': Color(0xFF3498DB),
    'traps': Color(0xFF8E44AD),
  };

  static const _muscleGroupLabels = {
    'chest': 'Petto',
    'back': 'Dorso',
    'legs': 'Gambe',
    'shoulders': 'Spalle',
    'biceps': 'Bicipiti',
    'triceps': 'Tricipiti',
    'core': 'Core',
    'glutes': 'Glutei',
    'calves': 'Polpacci',
    'traps': 'Trapezi',
  };

  Map<String, double> get _volumeByGroup {
    final volumes = <String, double>{};
    for (final session in sessions) {
      for (final ex in session.exercises) {
        if (ex.skipped) continue;
        for (final set in ex.sets) {
          if (!set.completed) continue;
          final volume = set.weight * set.actualReps;
          volumes[ex.muscleGroup] = (volumes[ex.muscleGroup] ?? 0) + volume;
        }
      }
    }
    // Sort by volume descending
    final sorted = volumes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted);
  }

  @override
  Widget build(BuildContext context) {
    final data = _volumeByGroup;
    if (data.isEmpty) {
      return const GlassmorphismCard(
        child: Text('Nessun dato disponibile.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final maxVolume = data.values.reduce((a, b) => a > b ? a : b);

    return GlassmorphismCard(
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxVolume * 1.15,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxVolume / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.bgElevated,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  getTitlesWidget: (value, _) {
                    if (value >= 1000) {
                      return Text(
                        '${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      );
                    }
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= data.length) return const Text('');
                    final key = data.keys.elementAt(index);
                    final label = _muscleGroupLabels[key] ?? key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        label.length > 5 ? '${label.substring(0, 5)}.' : label,
                        style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: data.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final muscleGroup = entry.value.key;
              final volume = entry.value.value;
              final color = _muscleGroupColors[muscleGroup] ?? AppColors.primary;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: volume,
                    color: color,
                    width: 16,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final key = data.keys.elementAt(group.x);
                  final label = _muscleGroupLabels[key] ?? key;
                  final vol = rod.toY;
                  return BarTooltipItem(
                    '$label\n${vol >= 1000 ? '${(vol / 1000).toStringAsFixed(1)}k' : vol.toInt()} kg',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
