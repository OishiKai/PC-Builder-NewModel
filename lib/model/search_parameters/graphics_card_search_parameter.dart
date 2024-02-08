import '../category_search_parameter.dart';

class GraphicsCardSearchParameter extends CategorySearchParameter {
  GraphicsCardSearchParameter(this.nvidiaChips, this.amdChips);
  final List<PartsSearchParameter> nvidiaChips;
  final List<PartsSearchParameter> amdChips;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'チップ(NVIDIA)': nvidiaChips},
      {'チップ(AMD)': amdChips},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearNvidiaChips = <PartsSearchParameter>[];
    for (final element in nvidiaChips) {
      element.isSelect = false;
      clearNvidiaChips.add(element);
    }
    final clearAmdChips = <PartsSearchParameter>[];
    for (final element in amdChips) {
      element.isSelect = false;
      clearAmdChips.add(element);
    }

    return GraphicsCardSearchParameter(clearNvidiaChips, clearAmdChips);
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in nvidiaChips) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in amdChips) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in nvidiaChips) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in amdChips) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    if (paramName == 'チップ(NVIDIA)') {
      final toggleNviviaChips = nvidiaChips;
      toggleNviviaChips[index].isSelect = !nvidiaChips[index].isSelect;
      return GraphicsCardSearchParameter(toggleNviviaChips, amdChips);
    } else if (paramName == 'チップ(AMD)') {
      final toggleAmdChips = amdChips;
      toggleAmdChips[index].isSelect = !amdChips[index].isSelect;
      return GraphicsCardSearchParameter(nvidiaChips, toggleAmdChips);
    } else {
      return this;
    }
  }
}
