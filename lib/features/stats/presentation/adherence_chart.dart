import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';

/// Radial chart: aderenza (giorni allenati vs pianificati).
/// Mostra percentuale con ring animato.
class AdherenceChart extends StatelessWidget {
  const AdherenceChart({super.key, required this.sessions});
  final List<WorkoutSession> sessions;

  @override
  Widget build(BuildContext context) {
    // Calcola aderenza: sessioni completate / sessioni che avremmo dovuto fare
    // Assume 5 allenamenti a settimana
    final now = DateTime.now();
    final completedCount = sessions.where((s) => s.completed).length;

    // Calcola quante settimane di dati abbiamo
    if (sessions.isEmpty) {
      return const GlassmorphismCard(
        child: Text('Nessun dato disponibile.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final earliest = sessions.map((s) => s.date).reduce((a, b) => a.isBefore(b) ? a : b);
    final daysSinceStart = now.difference(earliest).inDays + 1;
    final weeksSinceStart = (daysSinceStart / 7).ceil();
    final plannedSessions = weeksSinceStart * 5; // 5 allenamenti/settimana
    final adherence = plannedSessions > 0
        ? (completedCount / plannedSessions).clamp(0.0, 1.0)
        : 0.0;
    final percentage = (adherence * 100).round();

    return GlassmorphismCard(
      child: Row(
        children: [
          // Ring chart
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _AdherenceRingPainter(
                progress: adherence,
                color: adherence >= 0.8
                    ? AppColors.success
                    : adherence >= 0.6
                        ? AppColors.warning
                        : AppColors.error,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: adherence >= 0.8
                            ? AppColors.success
                            : adherence >= 0.6
                                ? AppColors.warning
                                : AppColors.error,
                      ),
                    ),
                    const Text(
                      'aderenza',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatRow(
                  label: 'Sessioni completate',
                  value: '$completedCount',
                  color: AppColors.success,
                ),
                const SizedBox(height: AppSpacing.sm),
                _StatRow(
                  label: 'Sessioni pianificate',
                  value: '$plannedSessions',
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppSpacing.sm),
                _StatRow(
                  label: 'Settimane attive',
                  value: '$weeksSinceStart',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AdherenceRingPainter extends CustomPainter {
  _AdherenceRingPainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 8.0;

    // Background
    final bgPaint = Paint()
      ..color = AppColors.bgElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AdherenceRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
