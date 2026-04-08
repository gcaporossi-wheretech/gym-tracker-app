import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/body_measurement.dart';

/// Bottom sheet form for adding a new body measurement.
/// Pre-fills from [prefill] (last measurement) for convenience.
class AddMeasurementDialog extends StatefulWidget {
  const AddMeasurementDialog({
    super.key,
    required this.onSave,
    this.prefill,
  });

  final Future<void> Function(BodyMeasurement) onSave;
  final BodyMeasurement? prefill;

  @override
  State<AddMeasurementDialog> createState() => _AddMeasurementDialogState();
}

class _AddMeasurementDialogState extends State<AddMeasurementDialog> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;

  // Controllers for all fields
  late final TextEditingController _weightCtrl;
  late final TextEditingController _chestCtrl;
  late final TextEditingController _waistCtrl;
  late final TextEditingController _hipsCtrl;
  late final TextEditingController _shouldersCtrl;
  late final TextEditingController _bicepLeftCtrl;
  late final TextEditingController _bicepRightCtrl;
  late final TextEditingController _thighLeftCtrl;
  late final TextEditingController _thighRightCtrl;
  late final TextEditingController _calfLeftCtrl;
  late final TextEditingController _calfRightCtrl;
  late final TextEditingController _notesCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    final p = widget.prefill;
    _weightCtrl = _ctrl(p?.weight);
    _chestCtrl = _ctrl(p?.chest);
    _waistCtrl = _ctrl(p?.waist);
    _hipsCtrl = _ctrl(p?.hips);
    _shouldersCtrl = _ctrl(p?.shoulders);
    _bicepLeftCtrl = _ctrl(p?.bicepLeft);
    _bicepRightCtrl = _ctrl(p?.bicepRight);
    _thighLeftCtrl = _ctrl(p?.thighLeft);
    _thighRightCtrl = _ctrl(p?.thighRight);
    _calfLeftCtrl = _ctrl(p?.calfLeft);
    _calfRightCtrl = _ctrl(p?.calfRight);
    _notesCtrl = TextEditingController(text: p?.notes ?? '');
  }

  TextEditingController _ctrl(double? value) {
    if (value == null || value == 0) return TextEditingController();
    return TextEditingController(text: value.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _chestCtrl.dispose();
    _waistCtrl.dispose();
    _hipsCtrl.dispose();
    _shouldersCtrl.dispose();
    _bicepLeftCtrl.dispose();
    _bicepRightCtrl.dispose();
    _thighLeftCtrl.dispose();
    _thighRightCtrl.dispose();
    _calfLeftCtrl.dispose();
    _calfRightCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  double _parse(TextEditingController ctrl) {
    return double.tryParse(ctrl.text.replaceAll(',', '.')) ?? 0.0;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final measurement = BodyMeasurement(
      id: const Uuid().v4(),
      date: _selectedDate,
      weight: _parse(_weightCtrl),
      chest: _parse(_chestCtrl),
      waist: _parse(_waistCtrl),
      hips: _parse(_hipsCtrl),
      shoulders: _parse(_shouldersCtrl),
      bicepLeft: _parse(_bicepLeftCtrl),
      bicepRight: _parse(_bicepRightCtrl),
      thighLeft: _parse(_thighLeftCtrl),
      thighRight: _parse(_thighRightCtrl),
      calfLeft: _parse(_calfLeftCtrl),
      calfRight: _parse(_calfRightCtrl),
      notes: _notesCtrl.text.trim(),
    );

    await widget.onSave(measurement);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.bgElevated,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg + bottomInset,
      ),
      child: Form(
        key: _formKey,
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
                    color: AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Title
              const GradientText(
                'Nuova misurazione',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.md),

              // Date picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(_selectedDate),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // --- Peso ---
              _SectionHeader('Peso'),
              _MeasurementField(
                controller: _weightCtrl,
                label: 'Peso corporeo',
                unit: 'kg',
                prominent: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              // --- Busto ---
              _SectionHeader('Busto'),
              _FieldRow(children: [
                _MeasurementField(
                  controller: _chestCtrl,
                  label: 'Petto',
                  unit: 'cm',
                ),
                _MeasurementField(
                  controller: _shouldersCtrl,
                  label: 'Spalle',
                  unit: 'cm',
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // --- Arti superiori ---
              _SectionHeader('Arti superiori'),
              _FieldRow(children: [
                _MeasurementField(
                  controller: _bicepLeftCtrl,
                  label: 'Bicipite sx',
                  unit: 'cm',
                ),
                _MeasurementField(
                  controller: _bicepRightCtrl,
                  label: 'Bicipite dx',
                  unit: 'cm',
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // --- Core ---
              _SectionHeader('Core'),
              _FieldRow(children: [
                _MeasurementField(
                  controller: _waistCtrl,
                  label: 'Vita',
                  unit: 'cm',
                ),
                _MeasurementField(
                  controller: _hipsCtrl,
                  label: 'Fianchi',
                  unit: 'cm',
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // --- Arti inferiori ---
              _SectionHeader('Arti inferiori'),
              _FieldRow(children: [
                _MeasurementField(
                  controller: _thighLeftCtrl,
                  label: 'Coscia sx',
                  unit: 'cm',
                ),
                _MeasurementField(
                  controller: _thighRightCtrl,
                  label: 'Coscia dx',
                  unit: 'cm',
                ),
              ]),
              const SizedBox(height: AppSpacing.sm),
              _FieldRow(children: [
                _MeasurementField(
                  controller: _calfLeftCtrl,
                  label: 'Polpaccio sx',
                  unit: 'cm',
                ),
                _MeasurementField(
                  controller: _calfRightCtrl,
                  label: 'Polpaccio dx',
                  unit: 'cm',
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // --- Note ---
              _SectionHeader('Note'),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Note opzionali'),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Save button
              GlowButton(
                label: 'Salva misurazione',
                icon: Icons.check,
                onPressed: _saving ? () {} : _save,
                enabled: !_saving,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.expand((child) sync* {
        yield Expanded(child: child);
        if (child != children.last) {
          yield const SizedBox(width: AppSpacing.sm);
        }
      }).toList(),
    );
  }
}

class _MeasurementField extends StatelessWidget {
  const _MeasurementField({
    required this.controller,
    required this.label,
    required this.unit,
    this.prominent = false,
  });

  final TextEditingController controller;
  final String label;
  final String unit;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
      ],
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: prominent ? 22 : 16,
        fontWeight: prominent ? FontWeight.w700 : FontWeight.normal,
      ),
      decoration: _inputDecoration(label, unit: unit),
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        final parsed = double.tryParse(value.replaceAll(',', '.'));
        if (parsed == null) return 'Numero non valido';
        if (parsed < 0) return 'Valore negativo';
        return null;
      },
    );
  }
}

InputDecoration _inputDecoration(String label, {String? unit}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    suffixText: unit,
    suffixStyle:
        const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    filled: true,
    fillColor: AppColors.bgElevated,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide:
          const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorStyle: const TextStyle(fontSize: 11),
  );
}
