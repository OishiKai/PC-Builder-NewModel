import '../category_search_parameter.dart';

class SsdSearchParameter extends CategorySearchParameter {
  SsdSearchParameter(this.volumes, this.type, this.interface);
  final List<PartsSearchParameter> volumes;
  final List<PartsSearchParameter> type;
  final List<PartsSearchParameter> interface;

  @override
  List<Map<String, List<PartsSearchParameter>>> alignParameters() {
    return [
      {'容量': volumes},
      {'規格': type},
      {'インターフェース': interface},
    ];
  }

  @override
  CategorySearchParameter clearSelectedParameter() {
    final clearVolumes = <PartsSearchParameter>[];
    for (final element in volumes) {
      element.isSelect = false;
      clearVolumes.add(element);
    }
    final clearType = <PartsSearchParameter>[];
    for (final element in type) {
      element.isSelect = false;
      clearType.add(element);
    }
    final clearInterface = <PartsSearchParameter>[];
    for (final element in interface) {
      element.isSelect = false;
      clearInterface.add(element);
    }

    return SsdSearchParameter(clearVolumes, clearType, clearInterface);
  }

  @override
  List<String> selectedParameters() {
    final params = <String>[];
    for (final element in volumes) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in type) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    for (final element in interface) {
      if (element.isSelect) {
        params.add(element.parameter);
      }
    }
    return params;
  }

  @override
  List<String> selectedParameterNames() {
    final params = <String>[];
    for (final element in volumes) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in type) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    for (final element in interface) {
      if (element.isSelect) {
        params.add(element.name);
      }
    }
    return params;
  }

  @override
  CategorySearchParameter toggleParameterSelect(String paramName, int index) {
    if (paramName == '容量') {
      final toggleVolumes = volumes;
      toggleVolumes[index].isSelect = !volumes[index].isSelect;
      return SsdSearchParameter(
        toggleVolumes,
        type,
        interface,
      );
    } else if (paramName == '規格') {
      final toggleType = type;
      toggleType[index].isSelect = !type[index].isSelect;
      return SsdSearchParameter(
        volumes,
        toggleType,
        interface,
      );
    } else if (paramName == 'インターフェース') {
      final toggleInterface = interface;
      toggleInterface[index].isSelect = !interface[index].isSelect;
      return SsdSearchParameter(
        volumes,
        type,
        toggleInterface,
      );
    } else {
      return this;
    }
  }
}
