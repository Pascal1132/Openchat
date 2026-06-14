import 'package:flutter/material.dart';

import '../../themes/colors.dart';

/// A subtle animated gradient border used around high-value surfaces.
class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    required this.child,
    this.strokeWidth = 1.5,
    this.borderRadius = 20,
    this.isActive = true,
    super.key,
  });

  final Widget child;
  final double strokeWidth;
  final double borderRadius;
  final bool isActive;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              colors: const [
                AppColors.primary,
                AppColors.accent,
                AppColors.primaryMuted,
                AppColors.primary,
              ],
              transform: GradientRotation(_controller.value * 6.28),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.strokeWidth),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius - widget.strokeWidth,
                ),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
