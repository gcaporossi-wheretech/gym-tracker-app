import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE d MMMM yyyy', 'it_IT');

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: Text(session.workoutName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Header stats
          Text(
            dateFormat.format(session.date),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),

          GlassmorphismCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(
                  value: '${session.durationMinutes}',
                  unit: 'min',
                  label: 'Durata',
                ),
                _StatColumn(
                  value: '${session.totalCompletedSets}',
                  unit: 'serie',
                  label: 'Completate',
                ),
                _StatColumn(
                  value: session.totalVolume >= 1000
                      ? '${(session.totalVolume / 1000).toStringAsFixed(1)}k'
                      : '${session.totalVolume.round()}',
                  unit: 'kg',
                  label: 'Volume',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Exercises
          ...session.exercises.asMap().entries.map((entry) {
            final idx = entry.key;
            final exercise = entry.value;

            return GlassmorphismCard(
              opacity: exercise.skipped ? 0.4 : 0.7,
              borderColor: exercise.skipped
                  ? AppColors.error.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (exercise.skipped)
                        const Icon(Icons.skip_next, color: AppColors.error, size: 18)
                      else
                        const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          '${idx + 1}. ${exercise.exerciseName}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: exercise.skipped ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!exercise.skipped && exercise.sets.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    // Set details table
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(36),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        const TableRow(
                          children: [
                            Text('SET', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                            Center(child: Text('KG', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
                            Center(child: Text('REP', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
                          ],
                        ),
                        ...exercise.sets.map((set) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  '${set.setNumber}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: set.completed ? AppColors.success : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  set.completed ? set.weight.toStringAsFixed(1) : '-',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: set.completed ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  set.completed ? '${set.actualReps}' : '-',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: set.completed ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                  if (exercise.notes.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      exercise.notes,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          if (session.notes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            GlassmorphismCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Note sessione', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(session.notes, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.unit,
    required this.label,
  });
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BigNumber(value, unit: unit, fontSize: 24),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
