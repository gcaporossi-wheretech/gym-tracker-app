import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/rest_timer_service.dart';
import '../../../services/timer_notification.dart'
    if (dart.library.js_interop) '../../../services/timer_notification_web.dart';
import 'active_session_notifier.dart';
import 'rest_timer_overlay.dart';
import '../../../services/session_providers.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key, required this.dayPlan});
  final DayPlan dayPlan;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  final _restTimer = RestTimerService();
  bool _timerFullscreen = true;
  String? _lastExerciseName;
  int? _lastSetNumber;
  int? _lastTotalSets;
  late DateTime _workoutStartTime;

  @override
  void initState() {
    super.initState();
    // Unlock audio on first user gesture context (GYM-30)
    TimerNotification.unlockAudio();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeSessionProvider);
      if (session == null) {
        ref.read(activeSessionProvider.notifier).startSession(widget.dayPlan);
      }
      // Use original session start time for resumed workouts (GYM-33)
      final s = ref.read(activeSessionProvider);
      if (s != null) {
        _workoutStartTime = s.session.date;
      } else {
        _workoutStartTime = DateTime.now();
      }
      if (mounted) setState(() {});
    });
    _workoutStartTime = DateTime.now();
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
    // Save info for timer display
    final plan = widget.dayPlan.exercises[exerciseIndex];
    _lastExerciseName = plan.name;
    _lastSetNumber = setIndex + 1;
    _lastTotalSets = plan.sets;
    _timerFullscreen = true;
    // Auto-start rest timer
    if (plan.restSeconds > 0) {
      _restTimer.start(plan.restSeconds);
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
      return _CompletionScreen(
        session: sessionState.session,
        onClose: () {
          ref.read(activeSessionProvider.notifier).closeSession();
          // Invalidate sessions so History tab refreshes
          ref.invalidate(allSessionsProvider);
          Navigator.pop(context);
        },
      );
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
          // Workout duration timer (GYM-19)
          Center(
            child: _WorkoutClock(startTime: _workoutStartTime),
          ),
          const SizedBox(width: 8),
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
          // Mini timer bar (when dismissed from fullscreen) - GYM-21
          ListenableBuilder(
            listenable: _restTimer,
            builder: (context, _) {
              if (!_restTimer.isRunning || _timerFullscreen) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () => setState(() => _timerFullscreen = true),
                child: Container(
                  color: AppColors.bgSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: _restTimer.remainingSeconds <= 5
                            ? AppColors.warning
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _restTimer.formattedTime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _restTimer.remainingSeconds <= 5
                              ? AppColors.warning
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (_lastExerciseName != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Serie $_lastSetNumber/$_lastTotalSets',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Mini progress
                      SizedBox(
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _restTimer.progress,
                            backgroundColor: AppColors.bgElevated,
                            color: _restTimer.remainingSeconds <= 5
                                ? AppColors.warning
                                : AppColors.primary,
                            minHeight: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Progress bar
          LinearProgressIndicator(
            value: sessionState.totalExercises > 0
                ? sessionState.completedExercises / sessionState.totalExercises
                : 0,
            backgroundColor: AppColors.bgSecondary,
            color: AppColors.primary,
            minHeight: 3,
          ),

          // Exercise list with warmup + reorder + add
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Warmup section (GYM-20)
                if (widget.dayPlan.warmup.isNotEmpty)
                  _WarmupChecklist(warmup: widget.dayPlan.warmup),

                // Exercise list
                ...sessionState.session.exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  // Find matching plan by exercisePlanId
                  final planMatches = widget.dayPlan.exercises.where((p) => p.id == exercise.exercisePlanId);
                  final plan = planMatches.isNotEmpty
                      ? planMatches.first
                      : ExercisePlan(
                          id: exercise.exercisePlanId,
                          name: exercise.exerciseName,
                          equipment: '',
                          muscleGroup: exercise.muscleGroup,
                          sets: exercise.sets.length,
                          reps: exercise.sets.isNotEmpty ? exercise.sets.first.plannedReps : 8,
                        );
                  final isCurrent = index == sessionState.currentExerciseIndex;

                  return Column(
                    children: [
                      _ExerciseSetTracker(
                        exercise: exercise,
                        plan: plan,
                        exerciseIndex: index,
                        isCurrent: isCurrent,
                        onSetCompleted: (setIndex, weight, reps) {
                          _onSetCompleted(index, setIndex, weight, reps);
                        },
                        onUndoSet: (setIndex) {
                          ref.read(activeSessionProvider.notifier).undoSet(
                            exerciseIndex: index, setIndex: setIndex,
                          );
                        },
                        onRemoveSet: (setIndex) {
                          ref.read(activeSessionProvider.notifier).removeSet(
                            exerciseIndex: index, setIndex: setIndex,
                          );
                        },
                        onAddSet: () {
                          ref.read(activeSessionProvider.notifier).addSet(
                            exerciseIndex: index,
                          );
                        },
                        onApplyWeightToAll: (weight) {
                          ref.read(activeSessionProvider.notifier).applyWeightToAll(
                            exerciseIndex: index,
                            weight: weight,
                          );
                        },
                        onApplyRepsToAll: (reps) {
                          ref.read(activeSessionProvider.notifier).applyRepsToAll(
                            exerciseIndex: index,
                            reps: reps,
                          );
                        },
                        onSkip: () {
                          ref.read(activeSessionProvider.notifier).skipExercise(index);
                        },
                        onUnskip: () {
                          ref.read(activeSessionProvider.notifier).unskipExercise(index);
                        },
                        onRemoveExercise: () {
                          ref.read(activeSessionProvider.notifier).removeExercise(index);
                        },
                        onTap: () {
                          ref.read(activeSessionProvider.notifier).goToExercise(index);
                        },
                      ),
                      // Reorder buttons (GYM-27)
                      if (isCurrent && !exercise.skipped)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (index > 0)
                              IconButton(
                                icon: const Icon(Icons.arrow_upward, size: 18, color: AppColors.textSecondary),
                                onPressed: () => ref.read(activeSessionProvider.notifier).moveExercise(index, index - 1),
                                tooltip: 'Sposta su',
                              ),
                            if (index < sessionState.session.exercises.length - 1)
                              IconButton(
                                icon: const Icon(Icons.arrow_downward, size: 18, color: AppColors.textSecondary),
                                onPressed: () => ref.read(activeSessionProvider.notifier).moveExercise(index, index + 1),
                                tooltip: 'Sposta giu',
                              ),
                          ],
                        ),
                    ],
                  );
                }),

                // Cardio section (if defined in plan)
                if (widget.dayPlan.hasCardio && widget.dayPlan.cardioDescription.isNotEmpty)
                  _CardioSection(description: widget.dayPlan.cardioDescription),

                // Add exercise button (GYM-26)
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showAddExerciseDialog(context, ref),
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                    label: const Text('Aggiungi esercizio', style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),

          // Bottom action - hidden when keyboard is open (GYM-28)
          Builder(
            builder: (context) {
              final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 50;
              if (keyboardOpen) return const SizedBox.shrink();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: _HoldToCompleteButton(
                    onConfirmed: () {
                      ref.read(activeSessionProvider.notifier).completeSession();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
          // Timer overlay (fullscreen or mini)
          if (_timerFullscreen)
            RestTimerOverlay(
              timer: _restTimer,
              exerciseName: _lastExerciseName,
              currentSet: _lastSetNumber,
              totalSets: _lastTotalSets,
              onSkip: () { _restTimer.skip(); setState(() {}); },
              onAddThirty: () => _restTimer.addThirtySeconds(),
              onDismiss: () => setState(() => _timerFullscreen = false),
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

  /// Dialog per aggiungere esercizio con selezione tipo (GYM-26, GYM-34)
  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _AddExerciseDialog(
        onAdd: ({
          required String name,
          required int sets,
          required int reps,
          required String exerciseType,
          String notes = '',
          String muscleGroup = 'other',
        }) {
          ref.read(activeSessionProvider.notifier).addCustomExercise(
            name: name,
            sets: sets,
            reps: reps,
            exerciseType: exerciseType,
            notes: notes,
            muscleGroup: muscleGroup,
          );
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

/// Sezione cardio a fine workout (mostra cardioDescription dal DayPlan)
class _CardioSection extends StatefulWidget {
  const _CardioSection({required this.description});
  final String description;

  @override
  State<_CardioSection> createState() => _CardioSectionState();
}

class _CardioSectionState extends State<_CardioSection> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      borderColor: _done
          ? AppColors.success.withValues(alpha: 0.3)
          : AppColors.primary.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _done = !_done),
            child: Row(
              children: [
                Icon(
                  _done ? Icons.check_circle : Icons.directions_run,
                  color: _done ? AppColors.success : AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _done ? 'Cardio completato!' : 'Cardio finale',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _done ? AppColors.success : null,
                    ),
                  ),
                ),
                Icon(
                  _done ? Icons.check_box : Icons.check_box_outline_blank,
                  color: _done ? AppColors.success : AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 14,
              color: _done ? AppColors.textSecondary : AppColors.textPrimary,
              decoration: _done ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog per aggiungere esercizio con tipo selezionabile (GYM-34)
class _AddExerciseDialog extends StatefulWidget {
  const _AddExerciseDialog({required this.onAdd});
  final void Function({
    required String name,
    required int sets,
    required int reps,
    required String exerciseType,
    String notes,
    String muscleGroup,
  }) onAdd;

  @override
  State<_AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<_AddExerciseDialog> {
  final _nameController = TextEditingController();
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '12');
  final _durationController = TextEditingController(text: '30');
  final _speedController = TextEditingController();
  final _inclineController = TextEditingController();
  String _type = 'weighted'; // weighted, bodyweight, cardio

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    _speedController.dispose();
    _inclineController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_type == 'cardio') {
      final minutes = int.tryParse(_durationController.text) ?? 30;
      final speed = _speedController.text.trim();
      final incline = _inclineController.text.trim();
      // Build notes with cardio details
      final parts = <String>[];
      if (speed.isNotEmpty) parts.add('$speed km/h');
      if (incline.isNotEmpty) parts.add('$incline% pendenza');
      widget.onAdd(
        name: name,
        sets: 1,
        reps: minutes * 60, // store as seconds for timed type
        exerciseType: 'timed',
        notes: parts.join(' • '),
        muscleGroup: 'cardio',
      );
    } else {
      widget.onAdd(
        name: name,
        sets: int.tryParse(_setsController.text) ?? 3,
        reps: int.tryParse(_repsController.text) ?? 12,
        exerciseType: _type,
        muscleGroup: _type == 'bodyweight' ? 'bodyweight' : 'other',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgSecondary,
      title: const Text('Aggiungi esercizio'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Type selector chips
            Wrap(
              spacing: 8,
              children: [
                _typeChip('Con pesi', 'weighted', Icons.fitness_center),
                _typeChip('Corpo libero', 'bodyweight', Icons.accessibility_new),
                _typeChip('Cardio', 'cardio', Icons.directions_run),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Name field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome esercizio',
                hintText: _type == 'cardio'
                    ? 'es. Tapis roulant'
                    : _type == 'bodyweight'
                        ? 'es. Crunch, Flessioni'
                        : 'es. Curl manubri',
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Dynamic fields based on type
            if (_type == 'cardio') ...[
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Durata (minuti)',
                  suffixText: 'min',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _speedController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Velocita',
                        suffixText: 'km/h',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _inclineController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Pendenza',
                        suffixText: '%',
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _setsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Serie'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Rep'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Aggiungi', style: TextStyle(color: AppColors.success)),
        ),
      ],
    );
  }

  Widget _typeChip(String label, String value, IconData icon) {
    final selected = _type == value;
    return GestureDetector(
      onTap: () => setState(() => _type = value),
      child: Chip(
        avatar: Icon(icon, size: 16, color: selected ? Colors.white : AppColors.textSecondary),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
        backgroundColor: selected ? AppColors.primary : AppColors.bgElevated,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.bgElevated,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}

/// Warmup checklist - persisted in session state (GYM-20, GYM-29)
class _WarmupChecklist extends ConsumerStatefulWidget {
  const _WarmupChecklist({required this.warmup});
  final List<String> warmup;

  @override
  ConsumerState<_WarmupChecklist> createState() => _WarmupChecklistState();
}

class _WarmupChecklistState extends ConsumerState<_WarmupChecklist> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);
    final checked = session?.warmupChecked ?? [];
    final allDone = session?.warmupAllDone ?? false;
    final doneCount = session?.warmupDoneCount ?? 0;

    return GlassmorphismCard(
      borderColor: allDone
          ? AppColors.success.withValues(alpha: 0.3)
          : AppColors.warning.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Icon(
                  allDone ? Icons.check_circle : Icons.whatshot,
                  color: allDone ? AppColors.success : AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    allDone ? 'Riscaldamento completato!' : 'Riscaldamento ($doneCount/${widget.warmup.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.sm),
            ...widget.warmup.asMap().entries.map((entry) {
              final idx = entry.key;
              final step = entry.value;
              final isChecked = idx < checked.length && checked[idx];
              return GestureDetector(
                onTap: () => ref.read(activeSessionProvider.notifier).toggleWarmup(idx),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isChecked ? AppColors.success : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            fontSize: 14,
                            color: isChecked ? AppColors.textSecondary : AppColors.textPrimary,
                            decoration: isChecked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
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
    required this.onUndoSet,
    required this.onRemoveSet,
    required this.onAddSet,
    required this.onApplyWeightToAll,
    required this.onApplyRepsToAll,
    required this.onSkip,
    required this.onUnskip,
    required this.onRemoveExercise,
    required this.onTap,
  });

  final ExerciseLog exercise;
  final ExercisePlan plan;
  final int exerciseIndex;
  final bool isCurrent;
  final void Function(int setIndex, double weight, int reps) onSetCompleted;
  final void Function(int setIndex) onUndoSet;
  final void Function(int setIndex) onRemoveSet;
  final VoidCallback onAddSet;
  final void Function(double weight) onApplyWeightToAll;
  final void Function(int reps) onApplyRepsToAll;
  final VoidCallback onSkip;
  final VoidCallback onUnskip;
  final VoidCallback onRemoveExercise;
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onSelected: (value) {
                  switch (value) {
                    case 'skip': onSkip();
                    case 'unskip': onUnskip();
                    case 'remove': onRemoveExercise();
                  }
                },
                itemBuilder: (ctx) => [
                  if (exercise.skipped)
                    const PopupMenuItem(value: 'unskip', child: Text('Riattiva'))
                  else if (!allCompleted)
                    const PopupMenuItem(value: 'skip', child: Text('Salta')),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text('Rimuovi', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ],
          ),

          if (!exercise.skipped) ...[
            // Equipment + rest info
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 2, bottom: AppSpacing.sm),
              child: Text(
                '${plan.equipment} • ${plan.restSeconds}s rec${plan.rpe > 0 ? ' • Intensita ${plan.rpe.toStringAsFixed(plan.rpe.truncateToDouble() == plan.rpe ? 0 : 1)}/10' : ''}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
            ),

            // Set tracker table
            _SetTable(
              sets: exercise.sets,
              suggestedWeight: plan.suggestedWeight,
              onSetCompleted: onSetCompleted,
              onUndoSet: onUndoSet,
              onRemoveSet: onRemoveSet,
              onApplyWeightToAll: onApplyWeightToAll,
              onApplyRepsToAll: onApplyRepsToAll,
              exerciseType: plan.exerciseType,
            ),
            // Action buttons row
            Wrap(
              spacing: 4,
              children: [
                // Applica peso a tutte
                TextButton.icon(
                  onPressed: () {
                    final firstCompleted = exercise.sets.where((s) => s.completed);
                    if (firstCompleted.isNotEmpty) {
                      onApplyWeightToAll(firstCompleted.last.weight);
                    }
                  },
                  icon: const Icon(Icons.copy_all, size: 14, color: AppColors.warning),
                  label: const Text('Kg a tutte', style: TextStyle(color: AppColors.warning, fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(40, 30),
                  ),
                ),
                if (exercise.sets.length > 1)
                  TextButton.icon(
                    onPressed: () => onRemoveSet(exercise.sets.length - 1),
                    icon: const Icon(Icons.remove, size: 14, color: AppColors.error),
                    label: const Text('Serie', style: TextStyle(color: AppColors.error, fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(40, 30),
                    ),
                  ),
                TextButton.icon(
                  onPressed: onAddSet,
                  icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
                  label: const Text('Serie', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(40, 30),
                  ),
                ),
              ],
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
    required this.onUndoSet,
    required this.onRemoveSet,
    required this.onApplyWeightToAll,
    required this.onApplyRepsToAll,
    this.exerciseType = 'weighted',
  });

  final List<SetLog> sets;
  final double suggestedWeight;
  final void Function(int setIndex, double weight, int reps) onSetCompleted;
  final void Function(int setIndex) onUndoSet;
  final void Function(int setIndex) onRemoveSet;
  final void Function(double weight) onApplyWeightToAll;
  final void Function(int reps) onApplyRepsToAll;
  final String exerciseType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const SizedBox(width: 36, child: Text('SET', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
              if (exerciseType == 'weighted')
                const Expanded(child: Center(child: Text('KG', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text(
                exerciseType == 'timed' ? 'SEC' : 'REP',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ))),
              const SizedBox(width: 48),
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
            canRemove: sets.length > 1,
            exerciseType: exerciseType,
            onCompleted: (weight, reps) => onSetCompleted(index, weight, reps),
            onUndo: () => onUndoSet(index),
            onRemove: () => onRemoveSet(index),
            onApplyWeightToAll: onApplyWeightToAll,
            onApplyRepsToAll: onApplyRepsToAll,
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
    required this.onUndo,
    required this.onRemove,
    required this.onApplyWeightToAll,
    required this.onApplyRepsToAll,
    this.canRemove = true,
    this.exerciseType = 'weighted',
  });

  final SetLog set;
  final int setIndex;
  final double suggestedWeight;
  final void Function(double weight, int reps) onCompleted;
  final VoidCallback onUndo;
  final VoidCallback onRemove;
  final void Function(double weight) onApplyWeightToAll;
  final void Function(int reps) onApplyRepsToAll;
  final bool canRemove;
  final String exerciseType;

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

  void _fillDownWeight() {
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0;
    if (weight > 0) {
      widget.onApplyWeightToAll(weight);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${weight.toStringAsFixed(1)} kg applicato a tutte le serie'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.bgElevated,
        ),
      );
    }
  }

  void _fillDownReps() {
    final reps = int.tryParse(_repsController.text) ?? 0;
    if (reps > 0) {
      widget.onApplyRepsToAll(reps);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$reps rep applicate a tutte le serie'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.bgElevated,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.set.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // Set number / remove button
          SizedBox(
            width: 36,
            child: widget.canRemove && !isCompleted
                ? GestureDetector(
                    onLongPress: widget.onRemove,
                    child: Text(
                      '${widget.setIndex + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isCompleted ? AppColors.success : AppColors.textPrimary,
                      ),
                    ),
                  )
                : Text(
                    '${widget.setIndex + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? AppColors.success : AppColors.textPrimary,
                    ),
                  ),
          ),

          // Weight input (hidden for timed/bodyweight)
          if (widget.exerciseType == 'weighted')
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                enabled: !isCompleted,
                onTap: () => _weightController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _weightController.text.length,
                ),
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

          // Fill-down weight button (separate from TextField)
          if (widget.exerciseType == 'weighted' && !isCompleted)
            SizedBox(
              width: 28,
              height: 36,
              child: IconButton(
                onPressed: _fillDownWeight,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.south, size: 16, color: AppColors.warning),
                tooltip: 'Applica kg a tutte',
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
                onTap: () => _repsController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _repsController.text.length,
                ),
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

          // Fill-down reps button
          if (!isCompleted)
            SizedBox(
              width: 28,
              height: 36,
              child: IconButton(
                onPressed: _fillDownReps,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.south, size: 16, color: AppColors.warning),
                tooltip: 'Applica rep a tutte',
              ),
            ),

          // Check button (tap to complete, tap again to undo)
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: isCompleted ? widget.onUndo : _complete,
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
    if (widget.exerciseType == 'timed') {
      final seconds = int.tryParse(_repsController.text) ?? 0;
      if (seconds > 0) widget.onCompleted(0, seconds);
    } else if (widget.exerciseType == 'bodyweight') {
      final reps = int.tryParse(_repsController.text) ?? 0;
      if (reps > 0) widget.onCompleted(0, reps);
    } else {
      final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0;
      final reps = int.tryParse(_repsController.text) ?? 0;
      if (weight > 0 && reps > 0) widget.onCompleted(weight, reps);
    }
  }
}

/// Bottone hold-to-complete: tieni premuto 2s poi conferma (GYM-28)
class _HoldToCompleteButton extends StatefulWidget {
  const _HoldToCompleteButton({required this.onConfirmed});
  final VoidCallback onConfirmed;

  @override
  State<_HoldToCompleteButton> createState() => _HoldToCompleteButtonState();
}

class _HoldToCompleteButtonState extends State<_HoldToCompleteButton>
    with SingleTickerProviderStateMixin {
  static const _holdDuration = Duration(milliseconds: 2000);
  late AnimationController _controller;
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _holdDuration);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _holding = false;
        _controller.reset();
        _showConfirmation();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown() {
    setState(() => _holding = true);
    _controller.forward();
  }

  void _onPointerUp() {
    if (_controller.isAnimating) {
      _controller.reset();
      setState(() => _holding = false);
    }
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text('Completare il workout?'),
        content: const Text('La sessione verra salvata nello storico.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onConfirmed();
            },
            child: const Text('Completa', style: TextStyle(color: AppColors.success)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _onPointerDown(),
      onLongPressEnd: (_) => _onPointerUp(),
      onLongPressCancel: _onPointerUp,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: _holding
                    ? AppColors.success.withValues(alpha: 0.8)
                    : AppColors.success.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd - 2),
              child: Stack(
                children: [
                  // Progress fill
                  FractionallySizedBox(
                    widthFactor: _controller.value,
                    child: Container(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  // Label
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: _holding ? AppColors.success : AppColors.textSecondary,
                          size: 22,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _holding ? 'Tieni premuto...' : 'Tieni premuto per completare',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _holding ? AppColors.success : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Schermata di completamento workout
class _CompletionScreen extends StatefulWidget {
  const _CompletionScreen({required this.session, required this.onClose});
  final WorkoutSession session;
  final VoidCallback onClose;

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
                onPressed: widget.onClose,
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

/// Cronometro durata workout (GYM-19)
class _WorkoutClock extends StatefulWidget {
  const _WorkoutClock({required this.startTime});
  final DateTime startTime;

  @override
  State<_WorkoutClock> createState() => _WorkoutClockState();
}

class _WorkoutClockState extends State<_WorkoutClock> {
  late Stream<int> _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _ticker,
      builder: (context, _) {
        final elapsed = DateTime.now().difference(widget.startTime);
        final minutes = elapsed.inMinutes;
        final seconds = elapsed.inSeconds % 60;
        return Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        );
      },
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
