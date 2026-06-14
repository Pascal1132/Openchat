import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

import '../../domain/models/artifact.dart';
import '../../presentation/themes/colors.dart';
import '../../presentation/themes/typography.dart';

class CodeArtifactRenderer extends StatelessWidget {
  const CodeArtifactRenderer({required this.artifact, super.key});

  final Artifact artifact;

  String get _language => artifact.language ?? 'text';

  @override
  Widget build(BuildContext context) {
    const theme = atomOneDarkTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToolbar(context),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              artifact.content,
              language: _language,
              theme: theme,
              padding: const EdgeInsets.all(16),
              textStyle: AppTypography.code,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: AppColors.surfaceRaised,
      child: Row(
        children: [
          const Icon(
            Icons.code,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            _language.toUpperCase(),
            style: AppTypography.label.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: artifact.content));
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
                Text(
                  'Copy',
                  style: AppTypography.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
