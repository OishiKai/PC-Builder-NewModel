import 'parts_category.dart';

class RecommendParameter {
  RecommendParameter(
    this.category,
    this.paramSectionIndex,
    this.paramValueName,
    this.paramIndex,
  );

  final PartsCategory category;
  final int paramSectionIndex;
  final String paramValueName;
  final int paramIndex;
}
