import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/artifact.dart';
import '../../presentation/themes/colors.dart';
import '../../presentation/themes/typography.dart';

class JsonArtifactRenderer extends StatelessWidget {
  const JsonArtifactRenderer({required this.artifact, super.key});

  final Artifact artifact;

  String get _pretty {
    try {
      final decoded = jsonDecode(artifact.content);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } on FormatException {
      return artifact.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToolbar(context),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: SelectableText(
              _pretty,
              style: AppTypography.code,
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
          const Icon(Icons.data_object, size: 16, color: AppColors.primary),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: _pretty));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceRaised,
                    content: Text(
                      'JSON copied',
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
