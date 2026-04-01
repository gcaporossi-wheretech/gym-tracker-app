import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../services/export_service.dart';
import '../../../services/providers.dart';
import '../../../services/session_providers.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(allSessionsProvider);
    final planAsync = ref.watch(activePlanProvider);
    final position = ref.watch(programPositionProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(title: const Text('Esporta Dati')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GradientText(
              'Esporta i tuoi dati',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Scarica i dati delle tue sessioni per analizzarli o per rimodulare la scheda.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),

            // JSON export
            GlassmorphismCard(
              onTap: () {
                sessionsAsync.whenData((sessions) {
                  planAsync.whenData((plan) {
                    final export = ExportService();
                    export.exportJson(
                      sessions: sessions,
                      plan: plan,
                      currentWeek: position?.week ?? 1,
                      currentPhase: position?.phase?.number ?? 1,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export JSON scaricato!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  });
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.data_object, color: AppColors.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Esporta JSON', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          'Formato completo con tutti i dati, ideale per analisi con Claude',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.download, color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // CSV export
            GlassmorphismCard(
              onTap: () {
                sessionsAsync.whenData((sessions) {
                  final export = ExportService();
                  export.exportCsv(sessions: sessions);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Export CSV scaricato!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.table_chart, color: AppColors.success),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Esporta CSV', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          'Formato tabellare, apribile con Excel o Google Sheets',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.download, color: AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Info
            sessionsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (sessions) => Text(
                '${sessions.length} sessioni disponibili per l\'export',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
