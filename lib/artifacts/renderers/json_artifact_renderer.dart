import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/artifact.dart';

class JsonArtifactRenderer extends StatelessWidget {
  const JsonArtifactRenderer({
    required this.artifact,
    super.key,
  });

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
            color: Theme.of(context).colorScheme.surface,
            child: SelectableText(
              _pretty,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.data_object, size: 16, color: Theme.of(context).colorScheme.primary),
          const Spacer(),
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _pretty));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('JSON copied')),
                );
              }
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
