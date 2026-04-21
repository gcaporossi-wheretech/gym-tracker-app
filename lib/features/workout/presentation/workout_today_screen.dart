import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/providers.dart';
import '../../../services/timer_notification.dart'
    if (dart.library.js_interop) '../../../services/timer_notification_web.dart';
import '../../../services/workout_plan_service.dart';
import 'active_workout_screen.dart';
import 'active_session_notifier.dart';
import 'edit_plan_screen.dart';

enum _StartChoice { cancel, resume, newSession }

class WorkoutTodayScreen extends ConsumerWidget {
  const WorkoutTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activePlanProvider);
    final position = ref.watch(programPositionProvider);

    return planAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text('Errore: $e', style: const TextStyle(color: AppColors.error)),
      ),
      data: (plan) => _WorkoutSelector(plan: plan, position: position),
    );
  }
}

/// Schermata principale: lista workout disponibili per la settimana (GYM-17)
class _WorkoutSelector extends ConsumerStatefulWidget {
  const _WorkoutSelector({required this.plan, this.position});
  final WorkoutPlan plan;
  final ProgramPosition? position;

  @override
  ConsumerState<_WorkoutSelector> createState() => _WorkoutSelectorState();
}

class _WorkoutSelectorState extends ConsumerState<_WorkoutSelector> {
  List<WorkoutSession> _weekSessions = [];

  @override
  void initState() {
    super.initState();
    _loadWeekSessions();
  }

  Future<void> _loadWeekSessions() async {
    final repo = ref.read(sessionRepositoryProvider);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final sessions = await repo.getSessionsInRange(start, now);
    if (mounted) setState(() => _weekSessions = sessions);
  }

  bool _isDoneThisWeek(DayPlan day) {
    return _weekSessions.any((s) => s.dayPlanId == day.id && s.completed);
  }

  @override
  Widget build(BuildContext context) {
    final days = widget.plan.days.toList()
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
    final todayWeekday = DateTime.now().weekday;
    final dayNames = ['', 'Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi', 'Sabato', 'Domenica'];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.position != null) _ProgramHeader(position: widget.position!),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Expanded(
                        child: GradientText(
                          'Scegli il workout',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_note, color: AppColors.primary),
                        tooltip: 'Modifica scheda',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditPlanScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${_weekSessions.where((s) => s.completed).length}/${days.length} completati questa settimana',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),

          // Workout cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final day = days[index];
                  final isDone = _isDoneThisWeek(day);
                  final isToday = day.dayOfWeek == todayWeekday;

                  return _WorkoutCard(
                    dayPlan: day,
                    dayName: dayNames[day.dayOfWeek],
                    isDoneThisWeek: isDone,
                    isToday: isToday,
                    exerciseCount: day.exercises.length,
                    onStart: () async {
                      // Check if there's already an active (in-progress) session for this dayPlan
                      final active = ref.read(activeSessionProvider);
                      final hasActiveSameDay = active != null
                          && !active.isCompleted
                          && active.session.dayPlanId == day.id;

                      // Choose dialog message based on state
                      final confirmed = await showDialog<_StartChoice>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.bgSecondary,
                          title: Text(hasActiveSameDay
                              ? '${day.name} in corso'
                              : 'Iniziare ${day.name}?'),
                          content: Text(hasActiveSameDay
                              ? 'Hai una sessione in corso. Riprenderla o iniziarne una nuova (si perdono i dati)?'
                              : '${day.exercises.length} esercizi${day.hasCardio ? ' + cardio' : ''}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, _StartChoice.cancel),
                              child: const Text('Annulla'),
                            ),
                            if (hasActiveSameDay)
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, _StartChoice.newSession),
                                child: const Text('Nuova', style: TextStyle(color: AppColors.warning)),
                              ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, hasActiveSameDay
                                  ? _StartChoice.resume
                                  : _StartChoice.newSession),
                              child: Text(
                                hasActiveSameDay ? 'Riprendi' : 'Inizia!',
                                style: const TextStyle(color: AppColors.success),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == null || confirmed == _StartChoice.cancel) return;
                      if (!context.mounted) return;
                      // Unlock audio from user gesture context (iOS Safari)
                      TimerNotification.unlockAudio();
                      if (confirmed == _StartChoice.newSession) {
                        await ref.read(activeSessionProvider.notifier).startSession(day);
                      }
                      // If resume, just navigate - session is already in state
                      if (context.mounted) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ActiveWorkoutScreen(dayPlan: day)),
                        );
                        _loadWeekSessions(); // Refresh after returning
                      }
                    },
                  );
                },
                childCount: days.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

/// Card per un singolo workout disponibile
class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.dayPlan,
    required this.dayName,
    required this.isDoneThisWeek,
    required this.isToday,
    required this.exerciseCount,
    required this.onStart,
  });

  final DayPlan dayPlan;
  final String dayName;
  final bool isDoneThisWeek;
  final bool isToday;
  final int exerciseCount;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      borderColor: isToday
          ? AppColors.primary.withValues(alpha: 0.5)
          : isDoneThisWeek
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.1),
      onTap: onStart,
      child: Row(
        children: [
          // Day badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: isDoneThisWeek ? null : (isToday ? AppColors.heroGradient : null),
              color: isDoneThisWeek
                  ? AppColors.success.withValues(alpha: 0.2)
                  : isToday
                      ? null
                      : AppColors.bgElevated,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            alignment: Alignment.center,
            child: isDoneThisWeek
                ? const Icon(Icons.check, color: AppColors.success, size: 28)
                : Text(
                    dayName.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isToday ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dayPlan.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDoneThisWeek ? AppColors.textSecondary : null,
                        ),
                      ),
                    ),
                    if (isToday && !isDoneThisWeek)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: const Text(
                          'OGGI',
                          style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$exerciseCount esercizi${dayPlan.hasCardio ? ' + cardio' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),

          // Arrow
          Icon(
            isDoneThisWeek ? Icons.replay : Icons.play_arrow,
            color: isDoneThisWeek ? AppColors.textSecondary : AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Header con info programma
class _ProgramHeader extends StatelessWidget {
  const _ProgramHeader({required this.position});
  final ProgramPosition position;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settimana ${position.week}/${position.totalWeeks}',
                  style: Theme.of(context).textTheme.titleMedium),
              if (position.phase != null)
                Text(position.phase!.name, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          if (position.isDeload)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: const Text('DELOAD',
                  style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700, fontSize: 12)),
            )
          else
            SizedBox(
              width: 48, height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: position.progressPercentage,
                    backgroundColor: AppColors.bgElevated,
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                  Text('${(position.progressPercentage * 100).round()}%',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
