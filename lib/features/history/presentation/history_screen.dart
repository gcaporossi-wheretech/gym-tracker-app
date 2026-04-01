import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            GradientText('Storico', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(
              'Completa il tuo primo workout\nper vedere lo storico qui.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
