import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

import '../themes/colors.dart';
import '../themes/typography.dart';

class CodeBlock extends StatelessWidget {
  const CodeBlock({
    required this.code,
    this.language,
    super.key,
  });

  final String code;
  final String? language;

  String get _effectiveLanguage {
    if (language == null || language!.isEmpty || language == 'text') {
      return 'plaintext';
    }
    return language!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = atomOneDarkTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.codeBlock,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              code,
              language: _effectiveLanguage,
              theme: theme,
              padding: const EdgeInsets.all(16),
              textStyle: AppTypography.code,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Text(
            language?.toUpperCase() ?? 'CODE',
            style: AppTypography.label.copyWith(color: AppColors.textTertiary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: code));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceRaised,
                    content: Text(
                      'Code copied',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.copy, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Copy', style: AppTypography.label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
