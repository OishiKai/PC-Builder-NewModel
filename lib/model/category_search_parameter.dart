/// カテゴリごとの検索パラメータモデル
abstract class CategorySearchParameter {
  List<String> selectedParameters();
  List<String> selectedParameterNames();
  CategorySearchParameter clearSelectedParameter();
  List<Map<String, List<PartsSearchParameter>>> alignParameters();
  CategorySearchParameter toggleParameterSelect(String paramName, int index);
}

/// パーツ検索用パラメータモデル
class PartsSearchParameter {
  PartsSearchParameter(this.name, this.parameter);
  final String name;
  final String parameter;
  bool isSelect = false;
}
