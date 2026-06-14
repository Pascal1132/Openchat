import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/artifact.dart';
import '../../presentation/themes/colors.dart';
import '../../presentation/themes/typography.dart';

class TableArtifactRenderer extends StatelessWidget {
  const TableArtifactRenderer({required this.artifact, super.key});

  final Artifact artifact;

  List<List<String>> _parseRows() {
    final lines =
        artifact.content.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final rows = <List<String>>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (RegExp(r'^\|?\s*[-:]+\s*(\|\s*[-:]+\s*)*\|?$').hasMatch(trimmed)) {
        continue;
      }
      final cells = trimmed
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
        child: SelectableText(
          artifact.content,
          style: AppTypography.body,
        ),
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
              headingRowColor: WidgetStateProperty.all(AppColors.surfaceRaised),
              border: TableBorder.all(color: AppColors.border, width: 1),
              columns: headers
                  .map(
                    (h) => DataColumn(
                      label: Text(
                        h,
                        style: AppTypography.bodySmall
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                  .toList(),
              rows: data
                  .map(
                    (row) => DataRow(
                      cells: row
                          .map(
                            (cell) => DataCell(
                              Text(cell, style: AppTypography.bodySmall),
                            ),
                          )
                          .toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: AppColors.surfaceRaised,
      child: Row(
        children: [
          const Icon(Icons.table_chart, size: 16, color: AppColors.primary),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: artifact.content));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceRaised,
                    content: Text(
                      'Table copied',
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
