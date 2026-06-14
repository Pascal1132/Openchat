import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/models/artifact.dart';
import '../../presentation/themes/colors.dart';
import '../../presentation/themes/typography.dart';

class MarkdownArtifactRenderer extends StatelessWidget {
  const MarkdownArtifactRenderer({required this.artifact, super.key});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    return Markdown(
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
    );
  }
}
