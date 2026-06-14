import 'package:flutter/material.dart';

import '../../themes/colors.dart';

/// A small icon-only custom button.
class IconButtonCustom extends StatefulWidget {
  const IconButtonCustom({
    required this.icon,
    this.onTap,
    this.size = 38,
    this.iconSize = 20,
    this.color = AppColors.textSecondary,
    this.activeColor = AppColors.primary,
    this.isActive = false,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color color;
  final Color activeColor;
  final bool isActive;
  final String? tooltip;

  @override
  State<IconButtonCustom> createState() => _IconButtonCustomState();
}

class _IconButtonCustomState extends State<IconButtonCustom> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _hovering || widget.isActive
                  ? AppColors.surfaceOverlay
                  : AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovering || widget.isActive
                    ? AppColors.borderLight
                    : AppColors.border,
              ),
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.isActive ? widget.activeColor : widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
