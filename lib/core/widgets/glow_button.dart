import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Bottone con effetto glow neon. Usato per CTA principali come
/// "Inizia Workout", "Completa Serie", ecc.
class GlowButton extends StatefulWidget {
  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.glowColor,
    this.width,
    this.height = 56,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final Color? glowColor;
  final double? width;
  final double height;
  final bool enabled;

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.primary;
    final glow = widget.glowColor ?? buttonColor;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: widget.enabled
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: glow.withValues(alpha: _glowAnimation.value * 0.5),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: glow.withValues(alpha: _glowAnimation.value * 0.2),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                )
              : null,
          child: child,
        );
      },
      child: ElevatedButton(
        onPressed: widget.enabled ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          minimumSize: Size(widget.width ?? double.infinity, widget.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              widget.width != null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 22),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AnimatedBuilder che rebuilda in base a un'animazione.
/// Wrapper leggero attorno ad AnimatedWidget.
class AnimatedBuilder extends StatelessWidget {
  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  const AnimatedBuilder2({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}
