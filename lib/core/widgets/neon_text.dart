import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Testo con effetto neon glow. Usato per personal records,
/// numeri importanti, titoli premium.
class NeonText extends StatelessWidget {
  const NeonText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.glowIntensity = 0.5,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    final neonColor = color ?? AppColors.success;
    final textStyle = style ?? Theme.of(context).textTheme.displayLarge;

    return Text(
      text,
      style: textStyle?.copyWith(
        color: neonColor,
        shadows: [
          Shadow(
            color: neonColor.withValues(alpha: glowIntensity),
            blurRadius: 10,
          ),
          Shadow(
            color: neonColor.withValues(alpha: glowIntensity * 0.6),
            blurRadius: 20,
          ),
        ],
      ),
    );
  }
}
