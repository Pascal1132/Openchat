import 'package:flutter/material.dart';

import '../../domain/models/artifact.dart';
import '../../presentation/themes/colors.dart';
import '../../presentation/themes/typography.dart';
import '../artifact_types.dart';
import '../renderers/code_artifact_renderer.dart';
import '../renderers/document_artifact_renderer.dart';
import '../renderers/html_artifact_renderer.dart';
import '../renderers/json_artifact_renderer.dart';
import '../renderers/markdown_artifact_renderer.dart';
import '../renderers/table_artifact_renderer.dart';

class ArtifactPanel extends StatefulWidget {
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
  State<ArtifactPanel> createState() => _ArtifactPanelState();
}

class _ArtifactPanelState extends State<ArtifactPanel> {
  late String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedArtifactId;
  }

  @override
  void didUpdateWidget(covariant ArtifactPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.artifacts != oldWidget.artifacts && widget.artifacts.isNotEmpty) {
      _selectedId ??= widget.artifacts.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.artifacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_mosaic,
              size: 40,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              'No artifacts',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      );
    }

    final selected = widget.artifacts.firstWhere(
      (a) => a.id == _selectedId,
      orElse: () => widget.artifacts.first,
    );

    return Column(
      children: [
        _buildArtifactList(selected),
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: _ArtifactDetail(
            artifact: selected,
            onDelete: widget.onArtifactDeleted,
          ),
        ),
      ],
    );
  }

  Widget _buildArtifactList(Artifact selected) {
    return Container(
      height: 52,
      color: AppColors.surfaceRaised,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: widget.artifacts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final artifact = widget.artifacts[index];
          final isSelected = artifact.id == selected.id;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedId = artifact.id);
              widget.onArtifactSelected?.call(artifact);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceOverlay,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _iconFor(artifact.type),
                    size: 14,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    artifact.title,
                    style: AppTypography.label.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
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
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  artifact.title,
                  style: AppTypography.title.copyWith(fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  artifact.type.label,
                  style: AppTypography.label.copyWith(fontSize: 10),
                ),
              ),
              if (onDelete != null)
                GestureDetector(
                  onTap: () => onDelete?.call(artifact),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
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
