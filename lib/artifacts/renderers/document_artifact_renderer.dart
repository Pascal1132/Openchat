import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/models/artifact.dart';
import '../../presentation/themes/colors.dart';
import '../../presentation/themes/typography.dart';

class DocumentArtifactRenderer extends StatelessWidget {
  const DocumentArtifactRenderer({required this.artifact, super.key});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToolbar(context),
        Expanded(
          child: Markdown(
            data: artifact.content,
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: AppTypography.body,
              h1: AppTypography.display.copyWith(fontSize: 24),
              h2: AppTypography.title.copyWith(fontSize: 20),
              h3: AppTypography.title.copyWith(fontSize: 18),
              code: AppTypography.code.copyWith(
                backgroundColor: AppColors.codeBlock,
              ),
              codeblockDecoration: BoxDecoration(
                color: AppColors.codeBlock,
                borderRadius: BorderRadius.circular(14),
              ),
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
          const Icon(Icons.article, size: 16, color: AppColors.primary),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: artifact.content));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceRaised,
                    content: Text(
                      'Document copied',
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
