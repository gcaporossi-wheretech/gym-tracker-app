import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/rest_timer_service.dart';
import 'active_session_notifier.dart';
import 'rest_timer_overlay.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key, required this.dayPlan});
  final DayPlan dayPlan;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  final _restTimer = RestTimerService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeSessionProvider);
      if (session == null) {
        ref.read(activeSessionProvider.notifier).startSession(widget.dayPlan);
      }
    });
  }

  @override
  void dispose() {
    _restTimer.dispose();
    super.dispose();
  }

  void _onSetCompleted(int exerciseIndex, int setIndex, double weight, int reps) {
    ref.read(activeSessionProvider.notifier).logSet(
      exerciseIndex: exerciseIndex,
      setIndex: setIndex,
      weight: weight,
      reps: reps,
    );
    // Auto-start rest timer
    final restSeconds = widget.dayPlan.exercises[exerciseIndex].restSeconds;
    if (restSeconds > 0) {
      _restTimer.start(restSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(activeSessionProvider);

    if (sessionState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (sessionState.isCompleted) {
      return _CompletionScreen(session: sessionState.session);
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(sessionState.session.workoutName),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Text(
                '${sessionState.completedExercises}/${sessionState.totalExercises}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: sessionState.totalExercises > 0
                ? sessionState.completedExercises / sessionState.totalExercises
                : 0,
            backgroundColor: AppColors.bgSecondary,
            color: AppColors.primary,
            minHeight: 3,
          ),

          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: sessionState.session.exercises.length,
              itemBuilder: (context, index) {
                final exercise = sessionState.session.exercises[index];
                final plan = widget.dayPlan.exercises[index];
                final isCurrent = index == sessionState.currentExerciseIndex;

                return _ExerciseSetTracker(
                  exercise: exercise,
                  plan: plan,
                  exerciseIndex: index,
                  isCurrent: isCurrent,
                  onSetCompleted: (setIndex, weight, reps) {
                    _onSetCompleted(index, setIndex, weight, reps);
                  },
                  onSkip: () {
                    ref.read(activeSessionProvider.notifier).skipExercise(index);
                  },
                  onTap: () {
                    ref.read(activeSessionProvider.notifier).goToExercise(index);
                  },
                );
              },
            ),
          ),

          // Bottom action
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: GlowButton(
                label: 'Completa Workout',
                icon: Icons.check_circle,
                color: AppColors.success,
                onPressed: () {
                  ref.read(activeSessionProvider.notifier).completeSession();
                },
              ),
            ),
          ),
        ],
      ),
          // Timer overlay
          RestTimerOverlay(
            timer: _restTimer,
            onSkip: () => _restTimer.skip(),
            onAddThirty: () => _restTimer.addThirtySeconds(),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text('Abbandonare il workout?'),
        content: const Text('I dati registrati finora verranno salvati.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continua'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(activeSessionProvider.notifier).completeSession();
              Navigator.pop(context);
            },
            child: const Text('Esci e salva', style: TextStyle(color: AppColors.warning)),
          ),
        ],
      ),
    );
  }
}

/// Set tracker per singolo esercizio (ispirato a Strong)
class _ExerciseSetTracker extends StatelessWidget {
  const _ExerciseSetTracker({
    required this.exercise,
    required this.plan,
    required this.exerciseIndex,
    required this.isCurrent,
    required this.onSetCompleted,
    required this.onSkip,
    required this.onTap,
  });

  final ExerciseLog exercise;
  final ExercisePlan plan;
  final int exerciseIndex;
  final bool isCurrent;
  final void Function(int setIndex, double weight, int reps) onSetCompleted;
  final VoidCallback onSkip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final allCompleted = exercise.sets.every((s) => s.completed);

    return GlassmorphismCard(
      borderColor: exercise.skipped
          ? AppColors.error.withValues(alpha: 0.3)
          : isCurrent
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.primary.withValues(alpha: 0.1),
      opacity: exercise.skipped ? 0.4 : 0.7,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              if (allCompleted && !exercise.skipped)
                const Icon(Icons.check_circle, color: AppColors.success, size: 20)
              else if (exercise.skipped)
                const Icon(Icons.skip_next, color: AppColors.error, size: 20)
              else
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                      width: 2,
                    ),
                  ),
                ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  exercise.exerciseName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    decoration: exercise.skipped ? TextDecoration.lineThrough : null,
                    color: exercise.skipped ? AppColors.textSecondary : null,
                  ),
                ),
              ),
              if (!exercise.skipped && !allCompleted)
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(48, 36),
                  ),
                  child: const Text('Skip', style: TextStyle(fontSize: 13)),
                ),
            ],
          ),

          if (!exercise.skipped) ...[
            // Equipment + rest info
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 2, bottom: AppSpacing.sm),
              child: Text(
                '${plan.equipment} • ${plan.restSeconds}s rec',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
            ),

            // Set tracker table
            _SetTable(
              sets: exercise.sets,
              suggestedWeight: plan.suggestedWeight,
              onSetCompleted: onSetCompleted,
            ),

            // Notes
            if (plan.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  plan.notes,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Tabella serie con input peso/rep inline (stile Strong)
class _SetTable extends StatelessWidget {
  const _SetTable({
    required this.sets,
    required this.suggestedWeight,
    required this.onSetCompleted,
  });

  final List<SetLog> sets;
  final double suggestedWeight;
  final void Function(int setIndex, double weight, int reps) onSetCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              SizedBox(width: 36, child: Text('SET', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
              Expanded(child: Center(child: Text('KG', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('REP', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)))),
              SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Set rows
        ...sets.asMap().entries.map((entry) {
          final index = entry.key;
          final set = entry.value;
          return _SetRow(
            set: set,
            setIndex: index,
            suggestedWeight: suggestedWeight,
            onCompleted: (weight, reps) => onSetCompleted(index, weight, reps),
          );
        }),
      ],
    );
  }
}

/// Singola riga serie con input
class _SetRow extends StatefulWidget {
  const _SetRow({
    required this.set,
    required this.setIndex,
    required this.suggestedWeight,
    required this.onCompleted,
  });

  final SetLog set;
  final int setIndex;
  final double suggestedWeight;
  final void Function(double weight, int reps) onCompleted;

  @override
  State<_SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<_SetRow> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.set.completed
          ? widget.set.weight.toStringAsFixed(1)
          : widget.suggestedWeight > 0
              ? widget.suggestedWeight.toStringAsFixed(1)
              : '',
    );
    _repsController = TextEditingController(
      text: widget.set.completed
          ? widget.set.actualReps.toString()
          : widget.set.plannedReps.toString(),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.set.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 36,
            child: Text(
              '${widget.setIndex + 1}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isCompleted ? AppColors.success : AppColors.textPrimary,
              ),
            ),
          ),

          // Weight input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                enabled: !isCompleted,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? AppColors.success : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  filled: true,
                  fillColor: isCompleted
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.bgElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Reps input
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                enabled: !isCompleted,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? AppColors.success : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  filled: true,
                  fillColor: isCompleted
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.bgElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Check button
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: isCompleted ? null : _complete,
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                color: isCompleted ? AppColors.success : AppColors.textSecondary,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _complete() {
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0;
    final reps = int.tryParse(_repsController.text) ?? 0;
    if (weight > 0 && reps > 0) {
      widget.onCompleted(weight, reps);
    }
  }
}

/// Schermata di completamento workout
class _CompletionScreen extends StatefulWidget {
  const _CompletionScreen({required this.session});
  final WorkoutSession session;

  @override
  State<_CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<_CompletionScreen> {
  bool _showCelebration = true;

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final completedSets = session.totalCompletedSets;
    final totalVolume = session.totalVolume;
    final skippedCount = session.exercises.where((e) => e.skipped).length;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: AppColors.warning),
              const SizedBox(height: AppSpacing.lg),
              const GradientText(
                'Workout Completato!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                session.workoutName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Stats
              GlassmorphismCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      value: '${session.durationMinutes}',
                      unit: 'min',
                      label: 'Durata',
                    ),
                    _StatItem(
                      value: '$completedSets',
                      unit: 'serie',
                      label: 'Completate',
                    ),
                    _StatItem(
                      value: totalVolume >= 1000
                          ? '${(totalVolume / 1000).toStringAsFixed(1)}k'
                          : '${totalVolume.round()}',
                      unit: 'kg',
                      label: 'Volume',
                    ),
                  ],
                ),
              ),

              if (skippedCount > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$skippedCount esercizi saltati',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),
              GlowButton(
                label: 'Chiudi',
                icon: Icons.home,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
          ),
          if (_showCelebration)
            CelebrationOverlay(
              onComplete: () => setState(() => _showCelebration = false),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
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
        BigNumber(value, unit: unit, fontSize: 28),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
