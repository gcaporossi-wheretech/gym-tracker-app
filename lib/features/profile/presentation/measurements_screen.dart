import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/body_measurement.dart';
import '../../../services/providers.dart';
import 'add_measurement_dialog.dart';

// ---------------------------------------------------------------------------
// Screen — uses ConsumerStatefulWidget with manual loading (like HistoryScreen)
// ---------------------------------------------------------------------------

class MeasurementsScreen extends ConsumerStatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  ConsumerState<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends ConsumerState<MeasurementsScreen> {
  List<BodyMeasurement> _measurements = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final repo = ref.read(measurementRepositoryProvider);
      final data = await repo.getAllMeasurements();
      if (mounted) {
        setState(() { _measurements = data; _loading = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _error = e.toString(); _loading = false; });
      }
    }
  }

  Future<void> _showAddDialog() async {
    final repo = ref.read(measurementRepositoryProvider);
    final latest = _measurements.isNotEmpty ? _measurements.first : null;

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddMeasurementDialog(
        prefill: latest,
        onSave: (m) async {
          await repo.saveMeasurement(m);
          _load();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _error != null
                ? Center(child: Text('Errore: $_error', style: const TextStyle(color: AppColors.error)))
                : _MeasurementsBody(
                    measurements: _measurements,
                    onDelete: (m) => _confirmDelete(m),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Aggiungi', style: TextStyle(fontWeight: FontWeight.w600)),
        onPressed: _showAddDialog,
      ),
    );
  }

  Future<void> _confirmDelete(BodyMeasurement m) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text('Eliminare questa misurazione?'),
        content: Text(DateFormat('d MMMM yyyy', 'it').format(m.date)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annulla')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final repo = ref.read(measurementRepositoryProvider);
      await repo.deleteMeasurement(m.id);
      _load();
    }
  }
}

// ---------------------------------------------------------------------------
// Body (scrollable content)
// ---------------------------------------------------------------------------

class _MeasurementsBody extends StatelessWidget {
  const _MeasurementsBody({required this.measurements, required this.onDelete});

  final List<BodyMeasurement> measurements;
  final void Function(BodyMeasurement) onDelete;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: AppSpacing.minTapTarget,
                        minHeight: AppSpacing.minTapTarget,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const GradientText(
                      'Misure',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                if (measurements.isEmpty)
                  _EmptyState()
                else ...[
                  _LatestMeasurementCard(latest: measurements.first),
                  const SizedBox(height: AppSpacing.md),
                  if (measurements.length >= 2)
                    _WeightChart(measurements: measurements),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Storico',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ),
        if (measurements.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              100, // room for FAB
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final m = measurements[index];
                  return _MeasurementHistoryCard(
                    measurement: m,
                    onDelete: () => onDelete(m),
                  );
                },
                childCount: measurements.length,
              ),
            ),
          ),
      ],
    );
  }

}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Icon(
            Icons.monitor_weight_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Nessuna misurazione',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Aggiungi la prima misurazione\nper tracciare i tuoi progressi.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Latest measurement summary card
// ---------------------------------------------------------------------------

class _LatestMeasurementCard extends StatelessWidget {
  const _LatestMeasurementCard({required this.latest});

  final BodyMeasurement latest;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(latest.date);

    return GlassmorphismCard(
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ultima misurazione',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                dateStr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Peso prominente
          if (latest.weight > 0)
            Center(
              child: Column(
                children: [
                  BigNumber(
                    latest.weight.toStringAsFixed(1),
                    unit: 'kg',
                    color: AppColors.primary,
                    fontSize: 48,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Peso',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          // Key measurements grid
          _MeasurementGrid(measurement: latest),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Compact grid of key measurements
// ---------------------------------------------------------------------------

class _MeasurementGrid extends StatelessWidget {
  const _MeasurementGrid({required this.measurement});

  final BodyMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    final items = <(String, double, String)>[
      ('Petto', measurement.chest, 'cm'),
      ('Vita', measurement.waist, 'cm'),
      ('Spalle', measurement.shoulders, 'cm'),
      ('Bicipite sx', measurement.bicepLeft, 'cm'),
      ('Bicipite dx', measurement.bicepRight, 'cm'),
      ('Fianchi', measurement.hips, 'cm'),
    ];

    final visible = items.where((i) => i.$2 > 0).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: visible.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.$2.toStringAsFixed(1)} ${item.$3}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                item.$1,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Weight over time line chart
// ---------------------------------------------------------------------------

class _WeightChart extends StatelessWidget {
  const _WeightChart({required this.measurements});

  final List<BodyMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final withWeight =
        measurements.where((m) => m.weight > 0).toList().reversed.toList();

    if (withWeight.length < 2) return const SizedBox.shrink();

    final spots = withWeight.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    final weights = withWeight.map((m) => m.weight);
    final minW = weights.reduce((a, b) => a < b ? a : b);
    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final range = maxW - minW;
    final interval = range <= 2 ? 0.5 : (range <= 10 ? 1.0 : 2.0);

    return GlassmorphismCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Andamento peso',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: minW - 1,
                maxY: maxW + 1,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.bgElevated,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: interval,
                      getTitlesWidget: (value, _) => Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= withWeight.length) {
                          return const SizedBox.shrink();
                        }
                        // Show only first, middle, last label to avoid crowding
                        final showLabel = idx == 0 ||
                            idx == withWeight.length - 1 ||
                            (withWeight.length > 4 &&
                                idx == withWeight.length ~/ 2);
                        if (!showLabel) return const SizedBox.shrink();
                        return Text(
                          DateFormat('dd/MM')
                              .format(withWeight[idx].date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.success,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, ___) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.success,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.success.withValues(alpha: 0.12),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final m = withWeight[spot.spotIndex];
                        return LineTooltipItem(
                          '${m.weight.toStringAsFixed(1)} kg\n'
                          '${DateFormat('dd/MM/yy').format(m.date)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// History card (one per measurement, expandable)
// ---------------------------------------------------------------------------

class _MeasurementHistoryCard extends StatefulWidget {
  const _MeasurementHistoryCard({
    required this.measurement,
    required this.onDelete,
  });

  final BodyMeasurement measurement;
  final VoidCallback onDelete;

  @override
  State<_MeasurementHistoryCard> createState() =>
      _MeasurementHistoryCardState();
}

class _MeasurementHistoryCardState extends State<_MeasurementHistoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.measurement;
    final dateStr = DateFormat('EEEE dd/MM/yyyy', 'it_IT').format(m.date);

    return GlassmorphismCard(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    if (m.weight > 0)
                      Text(
                        '${m.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              // Summary chips
              if (!_expanded) ...[
                if (m.chest > 0) _Chip('Petto ${m.chest.toStringAsFixed(0)}'),
                if (m.waist > 0) _Chip('Vita ${m.waist.toStringAsFixed(0)}'),
              ],
              const SizedBox(width: AppSpacing.xs),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
            ],
          ),

          // Expanded detail
          if (_expanded) ...[
            const Divider(
                color: AppColors.bgElevated, height: AppSpacing.lg),
            _DetailSection(
              title: 'Busto',
              items: [
                if (m.chest > 0) ('Petto', m.chest),
                if (m.shoulders > 0) ('Spalle', m.shoulders),
              ],
            ),
            _DetailSection(
              title: 'Arti superiori',
              items: [
                if (m.bicepLeft > 0) ('Bicipite sx', m.bicepLeft),
                if (m.bicepRight > 0) ('Bicipite dx', m.bicepRight),
              ],
            ),
            _DetailSection(
              title: 'Core',
              items: [
                if (m.waist > 0) ('Vita', m.waist),
                if (m.hips > 0) ('Fianchi', m.hips),
              ],
            ),
            _DetailSection(
              title: 'Arti inferiori',
              items: [
                if (m.thighLeft > 0) ('Coscia sx', m.thighLeft),
                if (m.thighRight > 0) ('Coscia dx', m.thighRight),
                if (m.calfLeft > 0) ('Polpaccio sx', m.calfLeft),
                if (m.calfRight > 0) ('Polpaccio dx', m.calfRight),
              ],
            ),
            if (m.notes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                m.notes,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 18),
                label: const Text(
                  'Elimina',
                  style: TextStyle(color: AppColors.error, fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  minimumSize:
                      const Size(AppSpacing.minTapTarget, AppSpacing.minTapTarget),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 11),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.items});

  final String title;
  final List<(String, double)> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: items.map((item) {
              return Text(
                '${item.$1}: ${item.$2.toStringAsFixed(1)} cm',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
