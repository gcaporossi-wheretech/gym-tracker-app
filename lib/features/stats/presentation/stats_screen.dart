import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            GradientText('Grafici', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(
              'I grafici appariranno dopo\nle prime sessioni registrate.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
