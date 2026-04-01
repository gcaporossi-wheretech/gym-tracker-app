import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../../services/providers.dart';
import 'plan_edit_notifier.dart';

/// Schermata di modifica della scheda settimanale.
/// Permette di: spostare sedute, saltare un giorno, modificare esercizi.
class EditPlanScreen extends ConsumerWidget {
  const EditPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activePlanProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Modifica Scheda')),
      body: planAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (plan) => _PlanEditor(plan: plan),
      ),
    );
  }
}

class _PlanEditor extends ConsumerWidget {
  const _PlanEditor({required this.plan});
  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = plan.days.toList()..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
    final dayNames = ['', 'Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi', 'Sabato', 'Domenica'];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          plan.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.lg),

        ...days.map((day) {
          return GlassmorphismCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        dayNames[day.dayOfWeek],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        day.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    // Swap day button
                    IconButton(
                      icon: const Icon(Icons.swap_horiz, color: AppColors.primary, size: 22),
                      tooltip: 'Sposta giorno',
                      onPressed: () => _showSwapDayDialog(context, ref, plan, day, dayNames),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${day.exercises.length} esercizi',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Exercise list with edit/remove
                ...day.exercises.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final ex = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${idx + 1}. ${ex.name}',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${ex.sets}x${ex.reps}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Edit exercise
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                            padding: EdgeInsets.zero,
                            onPressed: () => _showEditExerciseDialog(
                              context, ref, plan, day.id, idx, ex,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showSwapDayDialog(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    DayPlan day,
    List<String> dayNames,
  ) {
    final availableDays = [1, 2, 3, 4, 5]
        .where((d) => d != day.dayOfWeek)
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: Text('Sposta ${dayNames[day.dayOfWeek]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableDays.map((targetDay) {
            final targetPlan = plan.days.where((d) => d.dayOfWeek == targetDay);
            final targetName = targetPlan.isNotEmpty
                ? targetPlan.first.name
                : 'Vuoto';
            return ListTile(
              title: Text(dayNames[targetDay]),
              subtitle: Text('Attuale: $targetName', style: const TextStyle(fontSize: 12)),
              onTap: () {
                ref.read(planEditNotifierProvider.notifier)
                    .swapDays(plan, day.dayOfWeek, targetDay);
                ref.invalidate(activePlanProvider);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${dayNames[day.dayOfWeek]} scambiato con ${dayNames[targetDay]}'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showEditExerciseDialog(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    String dayId,
    int exerciseIndex,
    ExercisePlan exercise,
  ) {
    final setsController = TextEditingController(text: '${exercise.sets}');
    final repsController = TextEditingController(text: '${exercise.reps}');
    final weightController = TextEditingController(
      text: exercise.suggestedWeight > 0
          ? exercise.suggestedWeight.toStringAsFixed(1)
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: Text(exercise.name, style: const TextStyle(fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Serie'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Rep'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Peso consigliato (kg)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              final sets = int.tryParse(setsController.text) ?? exercise.sets;
              final reps = int.tryParse(repsController.text) ?? exercise.reps;
              final weight = double.tryParse(weightController.text.replaceAll(',', '.'))
                  ?? exercise.suggestedWeight;

              ref.read(planEditNotifierProvider.notifier).updateExercise(
                plan: plan,
                dayId: dayId,
                exerciseIndex: exerciseIndex,
                sets: sets,
                reps: reps,
                suggestedWeight: weight,
              );
              ref.invalidate(activePlanProvider);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${exercise.name} aggiornato'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Salva', style: TextStyle(color: AppColors.success)),
          ),
        ],
      ),
    );
  }
}
