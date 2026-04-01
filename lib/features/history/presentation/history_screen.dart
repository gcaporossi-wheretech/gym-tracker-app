import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/session_providers.dart';
import '../../../services/providers.dart';
import 'session_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(filteredSessionsProvider);
    final currentFilter = ref.watch(sessionFilterProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GradientText(
                  'Storico',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: AppSpacing.md),
                // Filter chips
                Row(
                  children: SessionFilter.values.map((filter) {
                    final isSelected = filter == currentFilter;
                    final label = switch (filter) {
                      SessionFilter.thisWeek => 'Settimana',
                      SessionFilter.thisMonth => 'Mese',
                      SessionFilter.all => 'Tutto',
                    };
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) => ref.read(sessionFilterProvider.notifier).set(filter),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.bgElevated,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        side: BorderSide.none,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Session list
          Expanded(
            child: sessionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(child: Text('Errore: $e')),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 48, color: AppColors.textSecondary),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          'Nessuna sessione registrata.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Completa il tuo primo workout!',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(allSessionsProvider);
                  },
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return _SessionCard(
                        session: sessions[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SessionDetailScreen(session: sessions[index]),
                            ),
                          );
                        },
                        onDelete: () => _confirmDelete(context, ref, sessions[index]),
                    );
                  },
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

  void _confirmDelete(BuildContext context, WidgetRef ref, WorkoutSession session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text('Eliminare questo workout?'),
        content: Text('${session.workoutName} del ${session.date.day}/${session.date.month}/${session.date.year}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final repo = ref.read(sessionRepositoryProvider);
              await repo.deleteSession(session.id);
              ref.invalidate(allSessionsProvider);
              ref.invalidate(filteredSessionsProvider);
            },
            child: const Text('Elimina', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session, required this.onTap, required this.onDelete});
  final WorkoutSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final completedSets = session.totalCompletedSets;
    final totalExercises = session.exercises.length;
    final done = session.exercises
        .where((e) => !e.skipped && e.sets.every((s) => s.completed))
        .length;

    return GlassmorphismCard(
      onTap: onTap,
      child: Row(
        children: [
          // Date column
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: session.completed ? AppColors.heroGradient : null,
              color: session.completed ? null : AppColors.bgElevated,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${session.date.day}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateFormat('MMM', 'it_IT').format(session.date).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.workoutName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '$done/$totalExercises esercizi • $completedSets serie • ${session.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),

          // Delete + Arrow
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.textSecondary, size: 20),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
