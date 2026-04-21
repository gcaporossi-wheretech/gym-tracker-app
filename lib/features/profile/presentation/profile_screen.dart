import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/phase.dart';
import '../../../services/providers.dart';

/// Descrizioni dettagliate per ogni fase del programma
const _phaseDetails = <int, ({String focus, List<String> changes, List<String> tips})>{
  1: (
    focus: 'Apprendere i movimenti e costruire forza base. Carichi moderati, alto volume di tecnica.',
    changes: [
      'Rep range 8-15 per serie',
      'RPE 7-8 (2-3 rep in riserva)',
      '90-120s di recupero tra serie',
      'Focus tecnica e ROM completo',
      'Cardio leggero (LISS) 1-2x/settimana',
    ],
    tips: [
      'Non cercare il cedimento - lascia sempre 2 rep in canna',
      'Registra il peso iniziale come baseline',
      'Priorita: forma corretta > peso sollevato',
    ],
  ),
  2: (
    focus: 'Sviluppare forza e ipertrofia con carichi piu alti e tecniche di intensita.',
    changes: [
      '5x6 sui compound (panca, squat, stacco)',
      'RPE 8-8.5 (1-2 rep in riserva)',
      'Drop set su esercizi di isolamento',
      'Recupero 2-3 min su compound',
      '1 sessione HIIT + LISS',
    ],
    tips: [
      'Aumenta progressivamente i carichi settimana per settimana',
      'Le drop set: ultima serie -20% carico senza pausa',
      'Aumenta proteine e carboidrati',
    ],
  ),
  3: (
    focus: 'Massima intensita e definizione. Tecniche avanzate e cardio aumentato.',
    changes: [
      'Rest-pause sui top set',
      'Superserie antagoniste (petto+dorso, bicipiti+tricipiti)',
      'RPE 8.5-9 (0-1 rep in riserva)',
      '2 sessioni HIIT + 1 LISS a settimana',
      'Recupero ridotto 60-90s',
    ],
    tips: [
      'Rest-pause: cedimento, 15s pausa, altre rep fino a cedimento',
      'Deficit calorico leggero per definizione',
      'Settimana 4: deload per recupero completo',
    ],
  ),
};

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activePlanProvider);
    final position = ref.watch(programPositionProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const GradientText(
            'Profilo',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Program info
          planAsync.when(
            loading: () => const GlassmorphismCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
            error: (e, _) => GlassmorphismCard(
              child: Text('Errore caricamento scheda: $e',
                  style: const TextStyle(color: AppColors.error)),
            ),
            data: (plan) {
              final startDate = '${plan.startDate.day}/${plan.startDate.month}/${plan.startDate.year}';
              return GlassmorphismCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Scheda attiva', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    _InfoRow(label: 'Nome', value: plan.name),
                    _InfoRow(label: 'Inizio', value: startDate),
                    _InfoRow(label: 'Durata', value: '${plan.totalWeeks} settimane'),
                    if (position != null) ...[
                      const Divider(color: AppColors.bgElevated, height: AppSpacing.lg),
                      _InfoRow(
                        label: 'Settimana',
                        value: '${position.week}/${position.totalWeeks}',
                        valueColor: AppColors.primary,
                      ),
                      _InfoRow(
                        label: 'Fase',
                        value: position.phase?.name ?? '-',
                        valueColor: AppColors.primary,
                      ),
                      if (position.phase?.description.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            position.phase!.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                          ),
                        ),
                      if (position.isDeload) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber, color: AppColors.warning, size: 18),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Settimana di DELOAD: 50% del carico, 2 serie invece di 3-4',
                                  style: TextStyle(color: AppColors.warning, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: position.progressPercentage,
                          backgroundColor: AppColors.bgElevated,
                          color: AppColors.primary,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${(position.progressPercentage * 100).round()}% completato',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Fasi del programma
          planAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (plan) => GlassmorphismCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fasi del programma', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  ...plan.phases.map((phase) {
                    final isCurrent = position?.phase?.number == phase.number;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          onTap: () => _showPhaseDetails(context, phase, isCurrent),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: isCurrent ? AppColors.primary.withValues(alpha: 0.15) : AppColors.bgElevated,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              border: isCurrent ? Border.all(color: AppColors.primary.withValues(alpha: 0.4)) : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${phase.number}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        phase.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        'Settimane ${phase.weekStart}-${phase.weekEnd}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isCurrent)
                                  const Icon(Icons.play_arrow, color: AppColors.primary, size: 18),
                                const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Misure button
          GlowButton(
            label: 'Misure corporee',
            icon: Icons.monitor_weight_outlined,
            color: AppColors.success,
            onPressed: () {
              Navigator.pushNamed(context, '/measurements');
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Export button
          GlowButton(
            label: 'Esporta Dati',
            icon: Icons.download,
            onPressed: () {
              Navigator.pushNamed(context, '/export');
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // App info
          GlassmorphismCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Info', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                const _InfoRow(label: 'Versione', value: '1.2.46'),
                const _InfoRow(label: 'Framework', value: 'Flutter PWA'),
                const _InfoRow(label: 'Storage', value: 'Locale (offline)'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// Bottom sheet con dettagli di una fase del programma
void _showPhaseDetails(BuildContext context, Phase phase, bool isCurrent) {
  final details = _phaseDetails[phase.number];

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Header with phase number
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent ? AppColors.primary : AppColors.bgElevated,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${phase.number}',
                    style: TextStyle(
                      color: isCurrent ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phase.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Settimane ${phase.weekStart}-${phase.weekEnd}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: const Text(
                      'IN CORSO',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Focus
            if (details != null) ...[
              const Text(
                'OBIETTIVO',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                details.focus,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // What changes
              const Text(
                'COSA CAMBIA',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...details.changes.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  ',
                        style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700)),
                    Expanded(
                      child: Text(c,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 14, height: 1.4)),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: AppSpacing.lg),

              // Tips
              const Text(
                'CONSIGLI',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...details.tips.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: AppColors.success, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(t,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 14, height: 1.4)),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: AppSpacing.md),
            ] else ...[
              Text(
                phase.description,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 15, height: 1.4),
              ),
            ],

            // Deload note
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Settimana ${phase.weekEnd}: deload (carichi -40%, volume -50%)',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: valueColor ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
