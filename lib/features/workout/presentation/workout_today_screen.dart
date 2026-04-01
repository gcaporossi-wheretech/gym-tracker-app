import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/providers.dart';
import '../../../services/workout_plan_service.dart';
import 'active_workout_screen.dart';
import 'active_session_notifier.dart';

class WorkoutTodayScreen extends ConsumerWidget {
  const WorkoutTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activePlanProvider);
    final todayPlan = ref.watch(todayPlanProvider);
    final position = ref.watch(programPositionProvider);

    return planAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text('Errore: $e', style: const TextStyle(color: AppColors.error)),
      ),
      data: (plan) {
        if (todayPlan == null) {
          return _RestDayView(position: position);
        }
        return _WorkoutDayView(
          dayPlan: todayPlan,
          position: position,
        );
      },
    );
  }
}

/// Vista per giorno di riposo (weekend)
class _RestDayView extends StatelessWidget {
  const _RestDayView({this.position});
  final ProgramPosition? position;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (position != null) _ProgramHeader(position: position!),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.self_improvement, size: 64, color: AppColors.success),
                    SizedBox(height: AppSpacing.md),
                    GradientText(
                      'Giorno di riposo',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Recupera, mangia bene, dormi 7-8 ore.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista per giorno di allenamento
class _WorkoutDayView extends ConsumerWidget {
  const _WorkoutDayView({required this.dayPlan, this.position});
  final DayPlan dayPlan;
  final ProgramPosition? position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (position != null) _ProgramHeader(position: position!),
                  const SizedBox(height: AppSpacing.md),
                  GradientText(
                    dayPlan.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${dayPlan.exercises.length} esercizi',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (dayPlan.warmup.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _WarmupSection(warmup: dayPlan.warmup),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final exercise = dayPlan.exercises[index];
                  return _ExerciseCard(
                    exercise: exercise,
                    index: index + 1,
                  );
                },
                childCount: dayPlan.exercises.length,
              ),
            ),
          ),
          if (dayPlan.hasCardio && dayPlan.cardioDescription.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _CardioCard(description: dayPlan.cardioDescription),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg,
              ),
              child: GlowButton(
                label: 'Inizia Workout',
                icon: Icons.fitness_center,
                onPressed: () {
                  ref.read(activeSessionProvider.notifier).startSession(dayPlan);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActiveWorkoutScreen(dayPlan: dayPlan),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }
}

/// Header con info programma: settimana, fase, deload
class _ProgramHeader extends StatelessWidget {
  const _ProgramHeader({required this.position});
  final ProgramPosition position;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settimana ${position.week}/${position.totalWeeks}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (position.phase != null)
                Text(
                  position.phase!.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
          if (position.isDeload)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: const Text(
                'DELOAD',
                style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            )
          else
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: position.progressPercentage,
                    backgroundColor: AppColors.bgElevated,
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                  Text(
                    '${(position.progressPercentage * 100).round()}%',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Sezione riscaldamento collassabile
class _WarmupSection extends StatefulWidget {
  const _WarmupSection({required this.warmup});
  final List<String> warmup;

  @override
  State<_WarmupSection> createState() => _WarmupSectionState();
}

class _WarmupSectionState extends State<_WarmupSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.whatshot, color: AppColors.warning, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Riscaldamento (${widget.warmup.length} step)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.sm),
            ...widget.warmup.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.warning)),
                  Expanded(
                    child: Text(
                      step,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}

/// Card singolo esercizio
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise, required this.index});
  final ExercisePlan exercise;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exercise.equipment,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _InfoChip(
                label: '${exercise.sets}x${exercise.reps}',
                icon: Icons.repeat,
              ),
              const SizedBox(width: AppSpacing.sm),
              if (exercise.suggestedWeight > 0)
                _InfoChip(
                  label: '${exercise.suggestedWeight.toStringAsFixed(exercise.suggestedWeight.truncateToDouble() == exercise.suggestedWeight ? 0 : 1)} kg',
                  icon: Icons.fitness_center,
                ),
              if (exercise.suggestedWeight > 0)
                const SizedBox(width: AppSpacing.sm),
              _InfoChip(
                label: '${exercise.restSeconds}s',
                icon: Icons.timer,
              ),
              if (exercise.rpe > 0) ...[
                const SizedBox(width: AppSpacing.sm),
                _InfoChip(
                  label: 'RPE ${exercise.rpe.toStringAsFixed(exercise.rpe.truncateToDouble() == exercise.rpe ? 0 : 1)}',
                  icon: Icons.speed,
                ),
              ],
            ],
          ),
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
  }
}

/// Chip informativo (serie, peso, timer, RPE)
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card cardio post-allenamento
class _CardioCard extends StatelessWidget {
  const _CardioCard({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      borderColor: AppColors.warning.withValues(alpha: 0.3),
      child: Row(
        children: [
          const Icon(Icons.directions_run, color: AppColors.warning, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cardio post-allenamento',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
