import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../services/export_service.dart';
import '../../../services/providers.dart';
import '../../../services/session_providers.dart';

void _downloadFile(String content, String filename, String mimeType) {
  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}

String _dateStamp() {
  final now = DateTime.now();
  return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
}

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(allSessionsProvider);
    final planAsync = ref.watch(activePlanProvider);
    final position = ref.watch(programPositionProvider);
    final exportService = ExportService();

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
              onTap: () async {
                final sessions = sessionsAsync.whenOrNull(data: (d) => d);
                final plan = planAsync.whenOrNull(data: (d) => d);
                if (sessions == null) return;
                // Recupera ultimo peso corporeo per volume esercizi bodyweight
                final measRepo = ref.read(measurementRepositoryProvider);
                final latest = await measRepo.getLatestMeasurement();
                final bodyweight = (latest?.weight ?? 0) > 0 ? latest!.weight : 75.0;
                final json = exportService.generateJson(
                  sessions: sessions,
                  plan: plan,
                  currentWeek: position?.week ?? 1,
                  currentPhase: position?.phase?.number ?? 1,
                  bodyweight: bodyweight,
                );
                _downloadFile(json, 'gymtracker_export_${_dateStamp()}.json', 'application/json');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export JSON scaricato!'), backgroundColor: AppColors.success),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
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
                        Text('Formato completo, ideale per analisi con Claude',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
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
                  final csv = exportService.generateCsv(sessions: sessions);
                  _downloadFile(csv, 'gymtracker_export_${_dateStamp()}.csv', 'text/csv');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export CSV scaricato!'), backgroundColor: AppColors.success),
                  );
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
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
                        Text('Apribile con Excel o Google Sheets',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(Icons.download, color: AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

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
