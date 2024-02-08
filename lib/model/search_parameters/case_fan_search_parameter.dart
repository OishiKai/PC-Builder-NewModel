import '../category_search_parameter.dart';

class CaseFanSearchParameter extends CategorySearchParameter {
  CaseFanSearchParameter(this.maker, this.size, this.maxAirVolume);
  final List<PartsSearchParameter> maker;
  final List<PartsSearchParameter> size;
  final List<PartsSearchParameter> maxAirVolume;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'メーカー': maker},
      {'サイズ': size},
      {'最大風量': maxAirVolume},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearMaker = <PartsSearchParameter>[];
    for (final element in maker) {
      element.isSelect = false;
      clearMaker.add(element);
    }
    final clearSize = <PartsSearchParameter>[];
    for (final element in size) {
      element.isSelect = false;
      clearSize.add(element);
    }
    final clearMaxAirVolume = <PartsSearchParameter>[];
    for (final element in maxAirVolume) {
      element.isSelect = false;
      clearMaxAirVolume.add(element);
    }

    return CaseFanSearchParameter(clearMaker, clearSize, clearMaxAirVolume);
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in maker) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in size) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in maxAirVolume) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in maker) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in size) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in maxAirVolume) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case 'メーカー':
        final toggleMaker = maker;
        toggleMaker[index].isSelect = !maker[index].isSelect;
        return CaseFanSearchParameter(toggleMaker, size, maxAirVolume);
      case 'サイズ':
        final toggleSize = size;
        toggleSize[index].isSelect = !size[index].isSelect;
        return CaseFanSearchParameter(maker, toggleSize, maxAirVolume);
      case '最大風量':
        final toggleMaxAirVolume = maxAirVolume;
        toggleMaxAirVolume[index].isSelect = !maxAirVolume[index].isSelect;
        return CaseFanSearchParameter(maker, size, toggleMaxAirVolume);
      default:
        return this;
    }
  }
}
