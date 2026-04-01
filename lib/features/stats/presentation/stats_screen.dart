import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../services/session_providers.dart';
import 'weight_progress_chart.dart';
import 'volume_chart.dart';
import 'adherence_chart.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(allSessionsProvider);

    return SafeArea(
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
                  Icon(Icons.bar_chart, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: AppSpacing.md),
                  GradientText('Grafici', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'I grafici appariranno dopo\nle prime sessioni registrate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const GradientText(
                'Grafici',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 1. Progressione carico
              _SectionTitle(title: 'Progressione Carico', icon: Icons.trending_up),
              const SizedBox(height: AppSpacing.sm),
              WeightProgressChart(sessions: sessions),
              const SizedBox(height: AppSpacing.xl),

              // 2. Volume per gruppo muscolare
              _SectionTitle(title: 'Volume per Gruppo', icon: Icons.stacked_bar_chart),
              const SizedBox(height: AppSpacing.sm),
              VolumeChart(sessions: sessions),
              const SizedBox(height: AppSpacing.xl),

              // 3. Aderenza
              _SectionTitle(title: 'Aderenza', icon: Icons.check_circle_outline),
              const SizedBox(height: AppSpacing.sm),
              AdherenceChart(sessions: sessions),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
