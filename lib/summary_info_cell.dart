import 'package:custom_pc_new_model/config/build_context_ex.dart';
import 'package:flutter/material.dart';

import 'model/parts_category.dart';

/// 詳細画面で表示する、パーツの概要を表示するセル
class SummaryInfoCell extends StatelessWidget {
  const SummaryInfoCell({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
  });

  final IconData icon;
  final String title;
  final PartsCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // cell間の余白
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        // 二列で表示するためpaddingを考慮して、画面*45%
        width: context.width * 0.45,
        height: context.height * 0.45,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              category.categoryShortName,
              style: TextStyle(
                color: context.colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
