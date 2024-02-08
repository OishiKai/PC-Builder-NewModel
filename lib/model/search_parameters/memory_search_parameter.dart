import '../category_search_parameter.dart';

class MemorySearchParameter extends CategorySearchParameter {
  MemorySearchParameter(this.volume, this.interface, this.type);
  final List<PartsSearchParameter> volume;
  final List<PartsSearchParameter> interface;
  final List<PartsSearchParameter> type;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'容量(一枚あたり)': volume},
      {'インターフェース': interface},
      {'規格': type},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearVolume = <PartsSearchParameter>[];
    for (final element in volume) {
      element.isSelect = false;
      clearVolume.add(element);
    }
    final clearInterface = <PartsSearchParameter>[];
    for (final element in interface) {
      element.isSelect = false;
      clearInterface.add(element);
    }
    final clearType = <PartsSearchParameter>[];
    for (final element in type) {
      element.isSelect = false;
      clearType.add(element);
    }

    return MemorySearchParameter(clearVolume, clearInterface, clearType);
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in volume) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in interface) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in type) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in volume) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in interface) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in type) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    switch (paramName) {
      case '容量(一枚あたり)':
        final toggleVolume = volume;
        toggleVolume[index].isSelect = !volume[index].isSelect;
        return MemorySearchParameter(toggleVolume, interface, type);
      case 'インターフェース':
        final toggleInterface = interface;
        toggleInterface[index].isSelect = !interface[index].isSelect;
        return MemorySearchParameter(volume, toggleInterface, type);
      case '規格':
        final toggleType = type;
        toggleType[index].isSelect = !type[index].isSelect;
        return MemorySearchParameter(volume, interface, toggleType);
      default:
        return this;
    }
  }
}
