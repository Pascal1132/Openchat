import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/artifact.dart';

class TableArtifactRenderer extends StatelessWidget {
  const TableArtifactRenderer({
    required this.artifact,
    super.key,
  });

  final Artifact artifact;

  List<List<String>> _parseRows() {
    final lines = artifact.content.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final rows = <List<String>>[];
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      // Skip markdown separator lines.
      if (RegExp(r'^\|?\s*[-:]+\s*(\|\s*[-:]+\s*)*\|?$').hasMatch(line)) {
        continue;
      }
      final cells = line
          .split('|')
          .map((cell) => cell.trim())
          .where((cell) => cell.isNotEmpty)
          .toList();
      if (cells.isNotEmpty) rows.add(cells);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _parseRows();
    if (rows.length < 2) {
      return Center(
        child: SelectableText(artifact.content),
      );
    }
    final headers = rows.first;
    final data = rows.sublist(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildToolbar(context),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: headers
                  .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontWeight: FontWeight.bold))))
                  .toList(),
              rows: data
                  .map(
                    (row) => DataRow(
                      cells: row.map((cell) => DataCell(Text(cell))).toList(),
                    ),
                  )
                  .toList(),
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
          Icon(Icons.table_chart, size: 16, color: Theme.of(context).colorScheme.primary),
          const Spacer(),
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: artifact.content));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Table copied')),
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
