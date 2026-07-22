// lib/widgets/blocks/data_table.dart — renders a TablePage.
// 1:1 port of src/components/blocks/DataTable.tsx.

import 'package:flutter/material.dart';

import '../../theme/theme_builder.dart';
import '../../theme/utils.dart';

class DataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final String accent;

  const DataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accentColor = hexToColor(accent);
    return Container(
      decoration: BoxDecoration(
        color: t.surfaceAlt,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(13),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row.
          Container(
            decoration: BoxDecoration(
              color: tint(accent, 0.12),
              border: Border(bottom: BorderSide(color: t.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: columns
                  .map(
                    (c) => Expanded(
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Body rows.
          for (int ri = 0; ri < rows.length; ri++)
            Container(
              decoration: BoxDecoration(
                color: t.surface,
                border: ri < rows.length - 1
                    ? Border(bottom: BorderSide(color: t.border))
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: rows[ri]
                    .map(
                      (cell) => Expanded(
                        child: Text(
                          cell,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: t.textMid,
                            height: 1.45,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}