import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Testo con gradiente hero (blue -> green). Usato per titoli
/// dell'app e intestazioni premium.
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient,
  });

  final String text;
  final TextStyle? style;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.headlineMedium;

    return ShaderMask(
      shaderCallback: (bounds) =>
          (gradient ?? AppColors.heroGradient).createShader(bounds),
      child: Text(
        text,
        style: textStyle?.copyWith(color: Colors.white),
      ),
    );
  }
}
