import 'package:flutter/material.dart';

import '../../domain/models/artifact.dart';
import '../artifact_types.dart';
import '../renderers/code_artifact_renderer.dart';
import '../renderers/document_artifact_renderer.dart';
import '../renderers/html_artifact_renderer.dart';
import '../renderers/json_artifact_renderer.dart';
import '../renderers/markdown_artifact_renderer.dart';
import '../renderers/table_artifact_renderer.dart';

class ArtifactPanel extends StatelessWidget {
  const ArtifactPanel({
    required this.artifacts,
    this.selectedArtifactId,
    this.onArtifactSelected,
    this.onArtifactDeleted,
    super.key,
  });

  final List<Artifact> artifacts;
  final String? selectedArtifactId;
  final ValueChanged<Artifact>? onArtifactSelected;
  final ValueChanged<Artifact>? onArtifactDeleted;

  @override
  Widget build(BuildContext context) {
    if (artifacts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_mosaic_outlined, size: 40),
            SizedBox(height: 8),
            Text('No artifacts yet'),
          ],
        ),
      );
    }

    final selected = artifacts.firstWhere(
      (a) => a.id == selectedArtifactId,
      orElse: () => artifacts.first,
    );

    return Column(
      children: [
        _buildArtifactList(context, selected),
        const Divider(height: 1),
        Expanded(
          child: _ArtifactDetail(
            artifact: selected,
            onDelete: onArtifactDeleted,
          ),
        ),
      ],
    );
  }

  Widget _buildArtifactList(BuildContext context, Artifact selected) {
    return Container(
      height: 48,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: artifacts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final artifact = artifacts[index];
          final isSelected = artifact.id == selected.id;
          return ChoiceChip(
            label: Text(artifact.title),
            selected: isSelected,
            onSelected: (_) => onArtifactSelected?.call(artifact),
            avatar: Icon(
              _iconFor(artifact.type),
              size: 16,
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(ArtifactType type) {
    switch (type) {
      case ArtifactType.code:
        return Icons.code;
      case ArtifactType.markdown:
      case ArtifactType.document:
        return Icons.article;
      case ArtifactType.html:
        return Icons.html;
      case ArtifactType.json:
        return Icons.data_object;
      case ArtifactType.table:
        return Icons.table_chart;
    }
  }
}

class _ArtifactDetail extends StatelessWidget {
  const _ArtifactDetail({required this.artifact, this.onDelete});

  final Artifact artifact;
  final ValueChanged<Artifact>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  artifact.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                artifact.type.label,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => onDelete?.call(artifact),
                  tooltip: 'Delete artifact',
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: _rendererFor(artifact)),
      ],
    );
  }

  Widget _rendererFor(Artifact artifact) {
    switch (artifact.type) {
      case ArtifactType.code:
        return CodeArtifactRenderer(artifact: artifact);
      case ArtifactType.markdown:
        return MarkdownArtifactRenderer(artifact: artifact);
      case ArtifactType.html:
        return HtmlArtifactRenderer(artifact: artifact);
      case ArtifactType.json:
        return JsonArtifactRenderer(artifact: artifact);
      case ArtifactType.table:
        return TableArtifactRenderer(artifact: artifact);
      case ArtifactType.document:
        return DocumentArtifactRenderer(artifact: artifact);
    }
  }
}
