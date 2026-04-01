import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            GradientText('Profilo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(
              'Impostazioni e export dati\nin arrivo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
