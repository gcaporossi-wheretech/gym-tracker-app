import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../services/providers.dart';

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
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
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
                const _InfoRow(label: 'Versione', value: '1.0.41'),
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
