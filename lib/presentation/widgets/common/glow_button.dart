import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../themes/typography.dart';

/// A fun glowing action button.
class GlowButton extends StatefulWidget {
  const GlowButton({
    required this.label,
    this.icon,
    this.onPressed,
    this.isPrimary = true,
    super.key,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.isPrimary ? AppColors.primary : AppColors.surfaceRaised;
    final foreground = AppColors.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (_hovering && widget.isPrimary)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 18,
                  spreadRadius: -2,
                ),
            ],
            border: widget.isPrimary
                ? null
                : Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTypography.body.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
