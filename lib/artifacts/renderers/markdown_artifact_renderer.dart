import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/models/artifact.dart';

class MarkdownArtifactRenderer extends StatelessWidget {
  const MarkdownArtifactRenderer({
    required this.artifact,
    super.key,
  });

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: artifact.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
    );
  }
}
