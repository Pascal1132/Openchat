import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../themes/typography.dart';

/// Custom text field built from primitives.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.focusNode,
    this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.onSubmitted,
    this.suffix,
    this.obscureText = false,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final bool obscureText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: maxLines,
              minLines: minLines,
              obscureText: obscureText,
              autofocus: autofocus,
              style: AppTypography.body,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.textTertiary,
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
